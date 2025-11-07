import Foundation

struct RoleSelectionViewState {
    var options: [RoleOption] = RoleOption.defaults
    var selectedRoleId: String?
    var isProcessing: Bool = false
    var errorMessage: String?
    var pendingNavigationRoleId: String?
}

struct RoleOption: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String

    static var defaults: [RoleOption] {
        [
            RoleOption(
                id: "admin",
                title: "Administrador",
                description: "Gestiona turnos, organiza equipos y supervisa la operacion completa."
            ),
            RoleOption(
                id: "staff",
                title: "Colaborador",
                description: "Consulta tus turnos, solicita cambios y mantente al dia con tus responsabilidades."
            )
        ]
    }
}
