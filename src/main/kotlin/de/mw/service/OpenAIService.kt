package de.mw.service

import com.aallam.openai.api.chat.ChatCompletionRequest
import com.aallam.openai.api.chat.ChatMessage
import com.aallam.openai.api.chat.ChatRole
import com.aallam.openai.api.http.Timeout
import com.aallam.openai.api.model.ModelId
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
    suspend fun generateText(prompt: String): String? {
        val chatCompletionRequest = ChatCompletionRequest(
            model = ModelId("gpt-4-1106-preview"),
            temperature = 0.3,
            messages = listOf(
                ChatMessage(
                    role = ChatRole.System,
                    content = PROMPT_INITIAL_ANALYSIS,
                ),
                ChatMessage(
                    role = ChatRole.User,
                    content = prompt,
                ),
            ),
        )
        val completion = openAI.chatCompletion(chatCompletionRequest)
        return completion.choices.first().message.content
    }

    companion object {
        const val PROMPT_INITIAL_ANALYSIS = """Gib alle Positionen zurück die von der Gegnerischen Versicherung bemängelt wurden. Im folgendem JSON Format.
Falls existierend, vergesse nicht "Verbringungskosten", "UPE Aufschläge". Erwähne nur Positionen, die tatsächlich bemängelt und gekürtzt wurden.
Wenn keinen Bemängelung vorliegt oder in dem gegebenen Text keine spezifischen Positionen aufgeführt sind oder keinen Zusammenhang zwischen dem gegebenen Text und der Bitte gibt, gibt "changed_positionen" als leere Liste zurück und nichts anderes. Ohne weiteren text.
Format:
{
"changed_positions": [
{
"name": "",
"description_short": ""
},
]
}
Gib nur valides JSON als Antwort."""
    }
}
