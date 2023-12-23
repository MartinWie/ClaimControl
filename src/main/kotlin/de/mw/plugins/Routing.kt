@file:Suppress("ktlint:standard:no-wildcard-imports")

package de.mw.plugins

import de.mw.BASICAUTH_ADMIN_ID
import de.mw.OpenAIServiceKey
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.configureRouting() {
    routing {
        get("/") {
            call.respondText("OK", status = HttpStatusCode.OK)
        }

        authenticate(BASICAUTH_ADMIN_ID) {
            get("/auth-test") {
                val openAIService = call.application.attributes[OpenAIServiceKey]
                val response = openAIService.generateText("Tell me a joke")
                response?.also {
                    call.respondText(it)
                } ?: call.respond(HttpStatusCode.InternalServerError, "No valid response form ")
            }
        }
    }
}
