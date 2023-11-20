package de.mw.plugins

import de.mw.OpenAIServiceKey
import io.ktor.server.application.* // ktlint-disable no-wildcard-imports
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.configureRouting() {
    routing {
        get("/") {
            call.respondText("Hello World!")
        }

        get("/test") {
            val openAIService = call.attributes[OpenAIServiceKey]
            // TODO: Implement first real endpoint with proper prompt response
            val response = openAIService.generateText("Tell me a joke")
            call.respondText(response)
        }
    }
}
