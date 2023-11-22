package de.mw.plugins

import de.mw.BASICAUTH_ADMIN_ID
import io.ktor.server.application.* // ktlint-disable no-wildcard-imports
import io.ktor.server.auth.* // ktlint-disable no-wildcard-imports

fun Application.configureSecurity() {
    val basiAuthAdminUsername = System.getenv("SECRET_CLAIMCONTROL_BASIC_AUTH_USERNAME") ?: throw IllegalStateException("Username not found in environment variables")
    val basicAuthAdminPassword = System.getenv("SECRET_CLAIMCONTROL_BASIC_AUTH_PASSWORD") ?: throw IllegalStateException("Password not found in environment variables")
    authentication {
        basic(BASICAUTH_ADMIN_ID) {
            realm = "Access to all endpoints on this server."
            validate { credentials ->
                if (credentials.name == basiAuthAdminUsername && credentials.password == basicAuthAdminPassword) {
                    UserIdPrincipal(credentials.name)
                } else {
                    null
                }
            }
        }
    }
}
