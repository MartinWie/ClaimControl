package de.mw.plugins

import de.mw.BASICAUTH_ADMIN_ID
import de.mw.OpenAIServiceKey
import io.ktor.http.* // ktlint-disable no-wildcard-imports
import io.ktor.server.application.* // ktlint-disable no-wildcard-imports
import io.ktor.server.auth.* // ktlint-disable no-wildcard-imports
import io.ktor.server.response.* // ktlint-disable no-wildcard-imports
import io.ktor.server.routing.* // ktlint-disable no-wildcard-imports

fun Application.configureRouting() {
    routing {
        get("/") {
            call.respondText("OK", status = HttpStatusCode.OK)
        }

        authenticate(BASICAUTH_ADMIN_ID) {
            get("/test") {
                val openAIService = call.application.attributes[OpenAIServiceKey]
                val response = openAIService.generateText("Tell me a joke")
                response?.also {
                    call.respondText(it)
                } ?: call.respond(HttpStatusCode.InternalServerError, "No valid response form ")
            }
        }
    }
}
