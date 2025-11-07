//
//  RoleSelectionView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import SwiftUI

struct RoleSelectionView: View {
    @StateObject private var viewModel: RoleSelectionViewModel

    var onBack: () -> Void
    var onRoleConfirmed: (String) -> Void

    init(userService: UserService,
         onBack: @escaping () -> Void = {},
         onRoleConfirmed: @escaping (String) -> Void = { _ in }) {
        self.onBack = onBack
        self.onRoleConfirmed = onRoleConfirmed
        _viewModel = StateObject(wrappedValue: RoleSelectionViewModel(userService: userService))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                RoleSelectionHeader(onBack: onBack)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        RoleSelectionIntro()

                        ForEach(viewModel.state.options) { option in
                            RoleOptionCard(
                                option: option,
                                isSelected: option.id == viewModel.state.selectedRoleId,
                                action: { viewModel.selectRole(option.id) }
                            )
                        }

                        if let message = viewModel.state.errorMessage {
                            RoleSelectionError(message: message, onDismiss: viewModel.dismissError)
                        }

                        Spacer().frame(height: 96)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                }
            }

            ConfirmButton(
                isEnabled: viewModel.state.selectedRoleId != nil && !viewModel.state.isProcessing,
                isLoading: viewModel.state.isProcessing,
                action: viewModel.confirmSelection
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .foregroundColor(.primary)
        .onChange(of: viewModel.state.pendingNavigationRoleId) { roleId in
            guard let roleId else { return }
            onRoleConfirmed(roleId)
            viewModel.consumePendingNavigation()
        }
    }
}

// MARK: - Subviews

private struct RoleSelectionHeader: View {
    var onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(10)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }

            Text("Selecciona tu rol")
                .font(.system(size: 22, weight: .bold))

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
    }
}

private struct RoleSelectionIntro: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Como quieres usar RotApp?")
                .font(.system(size: 24, weight: .bold))

            Text("Elige el rol que mejor refleje tu dia a dia para personalizar la experiencia.")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
    }
}

private struct RoleOptionCard: View {
    var option: RoleOption
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Text(option.title)
                    .font(.system(size: 18, weight: .semibold))

                Text(option.description)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)

                if isSelected {
                    SelectedBadge()
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 22)
            .background(cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: isSelected ? Color.black.opacity(0.08) : .clear, radius: 8, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(isSelected ? Color.accentColor.opacity(0.12) : Color(.systemBackground))
    }

    private var borderColor: Color {
        isSelected ? Color.accentColor : Color(.separator).opacity(0.4)
    }
}

private struct SelectedBadge: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16, weight: .semibold))
            Text("Seleccionado")
                .font(.system(size: 13, weight: .medium))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.accentColor)
        .clipShape(Capsule())
    }
}

private struct RoleSelectionError: View {
    var message: String
    var onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(Color(uiColor: .systemRed))

            HStack {
                Spacer()
                Button("Entendido", action: onDismiss)
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemRed).opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(uiColor: .systemRed), lineWidth: 1)
                )
        )
    }
}

private struct ConfirmButton: View {
    var isEnabled: Bool
    var isLoading: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            } else {
                Text("Continuar")
                    .font(.system(size: 17, weight: .semibold))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 56)
        .background((isEnabled || isLoading) ? Color.accentColor : Color(.systemGray5))
        .foregroundColor((isEnabled || isLoading) ? .white : .secondary)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .disabled(!isEnabled)
    }
}

// MARK: - Preview

#Preview {
    let container = AppContainer()
    return RoleSelectionView(userService: container.userService)
}
