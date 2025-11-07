//
//  LoginViewModel.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published private(set) var state = LoginViewState()

    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
    }

    func updateEmail(_ value: String) {
        state.email = value
        state.errorMessage = nil
    }

    func updatePassword(_ value: String) {
        state.password = value
        state.errorMessage = nil
    }

    func handleLoginTap() {
        guard !state.email.isEmpty, !state.password.isEmpty else {
            state.errorMessage = "Debes ingresar correo y contraseña"
            return
        }

        state.isLoading = true
        Task {
            let success = await userService.validateCredentials(email: state.email, password: state.password)
            state.isLoading = false
            if success {
                state.isSuccess = true
                state.password = ""
            } else {
                state.errorMessage = "Credenciales inválidas"
            }
        }
    }

    func dismissError() {
        state.errorMessage = nil
    }

    func consumeSuccess() {
        state.isSuccess = false
    }

    func handleForgotPasswordTap() {
        state.errorMessage = "Funcionalidad aún no disponible"
    }
}
