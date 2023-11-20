package de.mw.service

import com.aallam.openai.api.http.Timeout
import com.aallam.openai.client.OpenAI
import com.aallam.openai.client.OpenAIConfig
import kotlin.time.Duration.Companion.seconds

class OpenAIService(apiKey: String) {
    private val openAI: OpenAI

    init {
        val config = OpenAIConfig(
            token = apiKey,
            timeout = Timeout(socket = 60.seconds),
        )
        openAI = OpenAI(config)
    }
    suspend fun generateText(prompt: String): String {
        // TODO: Implement prompt method
        return ""
    }

    // TODO: implement testing
}
