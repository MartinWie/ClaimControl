package de.mw

import de.mw.plugins.configureRouting
import de.mw.plugins.configureSecurity
import de.mw.plugins.configureSerialization
import io.ktor.client.request.* // ktlint-disable no-wildcard-imports
import io.ktor.client.statement.* // ktlint-disable no-wildcard-imports
import io.ktor.http.* // ktlint-disable no-wildcard-imports
import io.ktor.server.testing.* // ktlint-disable no-wildcard-imports
import kotlin.test.Test
import kotlin.test.assertEquals

class ApplicationTest {

    private fun ApplicationTestBuilder.configureTestApplication() {
        application {
            configureSecurity()
            configureSerialization()
            configureRouting()
        }
    }

    @Test
    fun testRoot() = testApplication {
        configureTestApplication()
        client.get("/").apply {
            assertEquals(HttpStatusCode.OK, status)
            assertEquals("OK", bodyAsText())
        }
    }

    @Test
    fun `Test authentication`() = testApplication {
        configureTestApplication()
        // Perform a request with invalid credentials
        val response = client.request("/auth-test") {
            method = HttpMethod.Get
            header(HttpHeaders.Authorization, "Basic ${encodeBase64("invalidUsername:invalidPassword")}")
        }

        assertEquals(HttpStatusCode.Unauthorized, response.status)
    }

    // Helper function to encode credentials in Base64
    private fun encodeBase64(credentials: String): String {
        return java.util.Base64.getEncoder().encodeToString(credentials.toByteArray(Charsets.UTF_8))
    }
}
