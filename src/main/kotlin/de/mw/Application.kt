package de.mw

import de.mw.plugins.configureRouting
import de.mw.plugins.configureSecurity
import de.mw.plugins.configureSerialization
import de.mw.service.OpenAIService
import io.ktor.server.application.* // ktlint-disable no-wildcard-imports
import io.ktor.server.engine.* // ktlint-disable no-wildcard-imports
import io.ktor.server.netty.* // ktlint-disable no-wildcard-imports
import io.ktor.util.* // ktlint-disable no-wildcard-imports

fun main() {
    val openAIApiKey = System.getenv("SECRET_CLAIMCONTROL_OPENAI_API_KEY") ?: throw IllegalArgumentException(
        "API key not set in the environment variables",
    )

    val openAIService = OpenAIService(openAIApiKey)

    embeddedServer(Netty, port = 8080, host = "0.0.0.0") {
        module(openAIService)
    }.start(wait = true)
}

fun Application.module(openAIService: OpenAIService) {
    attributes.put(OpenAIServiceKey, openAIService)
    configureSecurity()
    configureSerialization()
    configureRouting()
}

val OpenAIServiceKey = AttributeKey<OpenAIService>("OpenAIService")
const val BASICAUTH_ADMIN_ID = "admin-auth"