//
//  RegisterViewModel.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published private(set) var state = RegisterViewState()

    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
        observeActiveUser()
    }

    private func observeActiveUser() {
        Task {
            for await user in userService.activeUserStream() {
                guard let user else { continue }
                state.fullName = user.fullName
                state.email = user.email
            }
        }
    }

    func updateFullName(_ value: String) {
        state.fullName = value
        resetFeedback()
    }

    func updateEmail(_ value: String) {
        state.email = value
        resetFeedback()
    }

    func updatePassword(_ value: String) {
        state.password = value
        resetFeedback()
    }

    func updateConfirmPassword(_ value: String) {
        state.confirmPassword = value
        resetFeedback()
    }

    func handleRegisterTap() {
        guard validateForm() else { return }

        state.isLoading = true
        state.errorMessage = nil
        state.isSuccess = false

        Task {
            _ = await userService.registerUser(
                fullName: state.fullName.trimmingCharacters(in: .whitespacesAndNewlines),
                email: state.email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: state.password
            )

            state.isLoading = false
            state.isSuccess = true
            state.password = ""
            state.confirmPassword = ""
        }
    }

    func dismissError() {
        state.errorMessage = nil
    }

    func consumeSuccess() {
        state.isSuccess = false
    }

    private func resetFeedback() {
        state.errorMessage = nil
        state.isSuccess = false
    }

    @discardableResult
    private func validateForm() -> Bool {
        guard !state.fullName.isEmpty,
              !state.email.isEmpty,
              !state.password.isEmpty,
              !state.confirmPassword.isEmpty else {
            state.errorMessage = "Completa todos los campos para continuar"
            return false
        }

        guard state.password.count >= 6 else {
            state.errorMessage = "La contraseña debe tener al menos 6 caracteres"
            return false
        }

        guard state.password == state.confirmPassword else {
            state.errorMessage = "Las contraseñas no coinciden"
            return false
        }

        return true
    }
}
