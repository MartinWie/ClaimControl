package de.mw.plugins

import io.ktor.server.application.* // ktlint-disable no-wildcard-imports
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.configureRouting() {
    routing {
        get("/") {
            call.respondText("Hello World!")
        }
    }
}
