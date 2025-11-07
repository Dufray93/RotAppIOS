//
//  LoginView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    var onBack: () -> Void
    var onLoginSuccess: () -> Void

    init(userService: UserService,
         onBack: @escaping () -> Void = {},
         onLoginSuccess: @escaping () -> Void = {}) {
        self.onBack = onBack
        self.onLoginSuccess = onLoginSuccess
        _viewModel = StateObject(wrappedValue: LoginViewModel(userService: userService))
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                LoginHeader(onBack: onBack)
                Spacer()
            }

            LoginCard(
                email: Binding(
                    get: { viewModel.state.email },
                    set: viewModel.updateEmail
                ),
                password: Binding(
                    get: { viewModel.state.password },
                    set: viewModel.updatePassword
                ),
                isLoading: viewModel.state.isLoading,
                errorMessage: viewModel.state.errorMessage,
                onLoginTap: viewModel.handleLoginTap,
                onDismissError: viewModel.dismissError,
                onForgotPassword: viewModel.handleForgotPasswordTap
            )
            .padding(.horizontal, 24)
            .padding(.top, 140)
        }
        .onChange(of: viewModel.state.isSuccess) { success in
            guard success else { return }
            onLoginSuccess()
            viewModel.consumeSuccess()
        }
    }
}

// MARK: - Subviews

private struct LoginHeader: View {
    var onBack: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Color.accentColor
                .frame(height: 360)
                .overlay(
                    Image("bg")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 360)
                        .clipped()
                        .opacity(0.45)
                )
                .clipped()

            VStack(spacing: 12) {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                            .padding(12)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                Image("rotapp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .shadow(radius: 10)
                    .padding(.top, 8)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct LoginCard: View {
    @Binding var email: String
    @Binding var password: String
    var isLoading: Bool
    var errorMessage: String?
    var onLoginTap: () -> Void
    var onDismissError: () -> Void
    var onForgotPassword: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Bienvenido a RotApp")
                .font(.system(size: 22, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(spacing: 12) {
                StyledTextField(
                    title: "Correo",
                    text: $email,
                    keyboardType: .emailAddress
                )
                StyledSecureField(title: "Contraseña", text: $password)
            }

            Button(action: onLoginTap) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text("Login")
                        .font(.system(size: 18, weight: .medium))
                }
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)

            if let message = errorMessage {
                ErrorCard(message: message, onDismiss: onDismissError)
            }

            Button(action: onForgotPassword) {
                Text("¿Olvidaste tu contraseña?")
                    .font(.system(size: 14))
                    .underline()
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 8)
        )
    }
}

private struct StyledTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("", text: $text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(keyboardType)
                .padding(.vertical, 8)
                .background(Color.clear)
            Rectangle()
                .fill(Color.secondary.opacity(0.3))
                .frame(height: 1)
        }
    }
}

private struct StyledSecureField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)

            SecureField("", text: $text)
                .padding(.vertical, 8)
            Rectangle()
                .fill(Color.secondary.opacity(0.3))
                .frame(height: 1)
        }
    }
}

private struct ErrorCard: View {
    var message: String
    var onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(Color(uiColor: .systemRed))

            HStack {
                Spacer()
                Button("Cerrar", action: onDismiss)
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .systemRed).opacity(0.1))
        )
    }
}

// MARK: - Preview

#Preview {
    let container = AppContainer()
    return LoginView(
        userService: container.userService,
        onBack: {},
        onLoginSuccess: {}
    )
}
