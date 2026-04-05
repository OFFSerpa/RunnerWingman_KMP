package com.wingman.shared.logic

/**
 * Interface do repositório de rotas — definida no shared module.
 * A implementação concreta (SwiftData) fica no lado iOS.
 */
interface RouteRepositoryInterface {
    fun rename(routeId: String, newName: String)
    fun delete(routeId: String)
}
