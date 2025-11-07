//
//  CreateCompanyView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import SwiftUI

struct CreateCompanyView: View {
    @StateObject private var viewModel: CreateCompanyViewModel

    var onBack: () -> Void
    var onCompanyCreated: (UUID) -> Void

    init(userService: UserService,
         companyService: CompanyService,
         onBack: @escaping () -> Void = {},
         onCompanyCreated: @escaping (UUID) -> Void = { _ in }) {
        self.onBack = onBack
        self.onCompanyCreated = onCompanyCreated
        _viewModel = StateObject(
            wrappedValue: CreateCompanyViewModel(
                userService: userService,
                companyService: companyService
            )
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                TopBar(onBack: onBack)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        HeaderSection()
                        NameField(name: viewModel.state.name, onChange: viewModel.updateName)
                        CategorySelector(selected: viewModel.state.category, onSelect: viewModel.updateCategory)
                        EmployeesSelector(count: viewModel.state.employeesCount, onChange: viewModel.updateEmployeesCount)

                        if let error = viewModel.state.errorMessage {
                            FeedbackCard(
                                message: error,
                                accentColor: Color(uiColor: .systemRed),
                                actionLabel: "Entendido",
                                action: viewModel.consumeMessages
                            )
                        }

                        if viewModel.state.isSuccess {
                            FeedbackCard(
                                message: "Empresa creada correctamente. Ya puedes comenzar a crear turnos.",
                                accentColor: Color(uiColor: .systemGreen),
                                actionLabel: "Continuar",
                                action: viewModel.consumeMessages
                            )
                        }

                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
            }

            PrimaryButton(
                title: viewModel.state.isLoading ? "" : "Crear empresa",
                isLoading: viewModel.state.isLoading,
                action: viewModel.createCompany
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .onChange(of: viewModel.state.generatedCompanyId) { companyId in
            guard let companyId else { return }
            onCompanyCreated(companyId)
            viewModel.consumeMessages()
        }
    }
}

// MARK: - Subviews

private struct TopBar: View {
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

            Text("Registrar empresa")
                .font(.system(size: 22, weight: .bold))

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
    }
}

private struct HeaderSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Configura tu empresa")
                .font(.system(size: 24, weight: .bold))

            Text("Usaremos estos datos para darte recomendaciones y distribuir mejor los turnos.")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
    }
}

private struct NameField: View {
    var name: String
    var onChange: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nombre de la empresa")
                .font(.system(size: 15, weight: .semibold))

            TextField("Ej. RotApp Operaciones", text: Binding(
                get: { name },
                set: onChange
            ))
            .textInputAutocapitalization(.words)
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

private struct CategorySelector: View {
    var selected: CompanyCategory
    var onSelect: (CompanyCategory) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("¿A qué se dedica?")
                .font(.system(size: 15, weight: .semibold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(CompanyCategory.defaults) { category in
                        let isActive = category == selected
                        Button(action: { onSelect(category) }) {
                            Text(category.title)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(isActive ? Color.accentColor.opacity(0.18) : Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(isActive ? Color.accentColor : Color(.separator).opacity(0.4), lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .buttonStyle(.plain)
                        .animation(.easeInOut(duration: 0.15), value: isActive)
                    }
                }
            }
        }
    }
}

private struct EmployeesSelector: View {
    var count: Int
    var onChange: (Int) -> Void

    @State private var internalValue: Double = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Número de colaboradores")
                        .font(.system(size: 17, weight: .semibold))

                    Text("Puedes ajustarlo más adelante en ajustes.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("\(count)")
                    .font(.system(size: 16, weight: .bold))
            }

            Slider(value: Binding(
                get: {
                    internalValue = Double(count)
                    return internalValue
                },
                set: { newValue in
                    internalValue = newValue
                    onChange(Int(newValue.rounded()))
                }
            ), in: 1...500, step: 1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

private struct FeedbackCard: View {
    var message: String
    var accentColor: Color
    var actionLabel: String
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(message)
                .foregroundColor(accentColor)
                .font(.system(size: 14))

            HStack {
                Spacer()
                Button(actionLabel, action: action)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(accentColor)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(accentColor.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(accentColor.opacity(0.4), lineWidth: 1)
                )
        )
    }
}

private struct PrimaryButton: View {
    var title: String
    var isLoading: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            } else {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(Color.accentColor)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .opacity(isLoading ? 0.6 : 1)
        .disabled(isLoading)
    }
}

// MARK: - Preview

#Preview {
    let container = AppContainer()
    return CreateCompanyView(
        userService: container.userService,
        companyService: container.companyService
    )
}
