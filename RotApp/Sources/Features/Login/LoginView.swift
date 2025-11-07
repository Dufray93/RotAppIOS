//
//  LoginView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject private var viewModel: LoginViewModel

    var onBack: () -> Void = {}
    var onLoginSuccess: () -> Void = {}

    init(onBack: @escaping () -> Void = {},
         onLoginSuccess: @escaping () -> Void = {}) {
        self.onBack = onBack
        self.onLoginSuccess = onLoginSuccess
        _viewModel = StateObject(wrappedValue: LoginViewModel(userService: containerPlaceholder))
    }

    var body: some View {
        VStack(spacing: 24) {
            Button("Volver", action: onBack)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                TextField("Correo", text: Binding(
                    get: { viewModel.state.email },
                    set: viewModel.updateEmail
                ))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)

                SecureField("Contraseña", text: Binding(
                    get: { viewModel.state.password },
                    set: viewModel.updatePassword
                ))
            }

            if viewModel.state.isLoading {
                ProgressView()
            }

            Button("Iniciar sesión") {
                viewModel.handleLoginTap()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.state.isLoading)

            if let message = viewModel.state.errorMessage {
                VStack(spacing: 8) {
                    Text(message)
                        .foregroundColor(.red)
                    Button("Cerrar") { viewModel.dismissError() }
                        .font(.caption)
                }
            }

            Spacer()
        }
        .padding(24)
        .onChange(of: viewModel.state.isSuccess) { success in
            if success {
                onLoginSuccess()
                viewModel.consumeSuccess()
            }
        }
        .onAppear {
            if viewModel.state.isSuccess {
                viewModel.consumeSuccess()
            }
        }
    }
}

// MARK: - Preview Helper

private let containerPlaceholder: UserService = UserServiceMock()

#Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppContainer())
    }
}
