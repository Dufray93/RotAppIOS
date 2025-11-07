//
//  RegisterView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel

    var onBack: () -> Void
    var onNavigateToRole: () -> Void

    init(userService: UserService,
         onBack: @escaping () -> Void = {},
         onNavigateToRole: @escaping () -> Void = {}) {
        self.onBack = onBack
        self.onNavigateToRole = onNavigateToRole
        _viewModel = StateObject(wrappedValue: RegisterViewModel(userService: userService))
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                RegisterHeader(onBack: onBack)
                Spacer()
            }

            RegisterCard(
                fullName: Binding(
                    get: { viewModel.state.fullName },
                    set: viewModel.updateFullName
                ),
                email: Binding(
                    get: { viewModel.state.email },
                    set: viewModel.updateEmail
                ),
                password: Binding(
                    get: { viewModel.state.password },
                    set: viewModel.updatePassword
                ),
                confirmPassword: Binding(
                    get: { viewModel.state.confirmPassword },
                    set: viewModel.updateConfirmPassword
                ),
                isLoading: viewModel.state.isLoading,
                errorMessage: viewModel.state.errorMessage,
                isSuccess: viewModel.state.isSuccess,
                onRegisterTap: viewModel.handleRegisterTap,
                onDismissError: viewModel.dismissError,
                onContinue: {
                    viewModel.consumeSuccess()
                    onNavigateToRole()
                }
            )
            .padding(.horizontal, 24)
            .padding(.top, 120)
        }
    }
}

// MARK: - Subviews

private struct RegisterHeader: View {
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
                    .padding(.top, 4)

                Spacer()
            }
        }
    }
}

private struct RegisterCard: View {
    @Binding var fullName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String

    var isLoading: Bool
    var errorMessage: String?
    var isSuccess: Bool

    var onRegisterTap: () -> Void
    var onDismissError: () -> Void
    var onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Crear cuenta en RotApp")
                    .font(.system(size: 22, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(spacing: 16) {
                    StyledTextField(title: "Nombre completo", text: $fullName)
                    StyledTextField(title: "Correo", text: $email, keyboardType: .emailAddress)
                    StyledSecureField(title: "Contraseña", text: $password)
                    StyledSecureField(title: "Confirmar contraseña", text: $confirmPassword)
                }

                Button(action: onRegisterTap) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Text("Crear cuenta")
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 52)
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)

                if let message = errorMessage {
                    ErrorCard(message: message, onDismiss: onDismissError)
                }

                if isSuccess {
                    SuccessCard(onContinue: onContinue)
                }
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 8)
        )
    }
}

private struct SuccessCard: View {
    var onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cuenta creada exitosamente")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(uiColor: .systemGreen))

            Text("Continúa para seleccionar tu rol y completar el proceso.")
                .font(.system(size: 14))

            Button("Continuar", action: onContinue)
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .systemGreen).opacity(0.1))
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
    return RegisterView(
        userService: container.userService,
        onBack: {},
        onNavigateToRole: {}
    )
}
