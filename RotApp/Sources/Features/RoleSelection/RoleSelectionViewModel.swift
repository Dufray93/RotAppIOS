//
//  RoleSelectionViewModel.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

@MainActor
final class RoleSelectionViewModel: ObservableObject {
    @Published private(set) var state = RoleSelectionViewState()

    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
        observeActiveUser()
    }

    private func observeActiveUser() {
        Task {
            for await user in userService.activeUserStream() {
                guard let user else { continue }
                state.selectedRoleId = user.roleId
            }
        }
    }

    func selectRole(_ roleId: String) {
        state.selectedRoleId = roleId
        state.errorMessage = nil
    }

    func confirmSelection() {
        guard let roleId = state.selectedRoleId else {
            state.errorMessage = "Selecciona un rol para continuar"
            return
        }

        state.isProcessing = true
        state.errorMessage = nil

        Task {
            defer { state.isProcessing = false }

            guard let activeUser = await userService.getActiveUser() else {
                state.errorMessage = "No encontramos tu usuario activo. Intenta iniciar sesion nuevamente"
                return
            }

            await userService.updateRole(for: activeUser.id, roleId: roleId)
            state.pendingNavigationRoleId = roleId
        }
    }

    func dismissError() {
        state.errorMessage = nil
    }

    func consumePendingNavigation() {
        state.pendingNavigationRoleId = nil
    }
}
