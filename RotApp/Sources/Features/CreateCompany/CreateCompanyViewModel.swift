//
//  CreateCompanyViewModel.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

@MainActor
final class CreateCompanyViewModel: ObservableObject {
    @Published private(set) var state = CreateCompanyViewState()

    private let userService: UserService
    private let companyService: CompanyService
    private var activeUser: User?
    private var companyObservationTask: Task<Void, Never>?

    init(userService: UserService, companyService: CompanyService) {
        self.userService = userService
        self.companyService = companyService
        observeActiveUser()
    }

    deinit {
        companyObservationTask?.cancel()
    }

    private func observeActiveUser() {
        Task {
            for await user in userService.activeUserStream() {
                activeUser = user
                companyObservationTask?.cancel()

                guard let user else { continue }

                companyObservationTask = Task { @MainActor [weak self] in
                    guard let self else { return }
                    await self.observeCompanies(for: user.id)
                }
            }
        }
    }

    private func observeCompanies(for userId: UUID) async {
        for await companies in companyService.observeCompanies(for: userId) {
            if Task.isCancelled { break }
            guard let company = companies.first else { continue }

            state.name = company.name
            state.category = CompanyCategory.defaults.first(where: { $0.id == company.categoryId }) ?? .all
            state.employeesCount = max(1, min(company.employeesCount, 500))
        }
    }

    func updateName(_ value: String) {
        state.name = value
        resetFeedback()
    }

    func updateCategory(_ category: CompanyCategory) {
        state.category = category
        resetFeedback()
    }

    func updateEmployeesCount(_ value: Int) {
        let sanitized = max(1, min(value, 500))
        state.employeesCount = sanitized
        resetFeedback()
    }

    func createCompany() {
        let trimmedName = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            state.errorMessage = "Ingresa el nombre de tu empresa"
            state.isSuccess = false
            return
        }

        state.isLoading = true
        state.errorMessage = nil
        state.isSuccess = false

        Task { @MainActor in
            let user = activeUser ?? await userService.getActiveUser()

            guard let user else {
                state.isLoading = false
                state.errorMessage = "No encontramos tu usuario activo. Repite el inicio de sesion."
                return
            }

            let company = await companyService.createCompanyForUser(
                userId: user.id,
                name: trimmedName,
                categoryId: state.category.id,
                employeesCount: state.employeesCount,
                roleId: user.roleId ?? "admin"
            )

            state.isLoading = false
            state.isSuccess = true
            state.generatedCompanyId = company.id
        }
    }

    func consumeMessages() {
        state.errorMessage = nil
        state.isSuccess = false
        state.generatedCompanyId = nil
    }

    private func resetFeedback() {
        state.errorMessage = nil
        state.isSuccess = false
    }
}
