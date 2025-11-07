//
//  CompanyServiceMock.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

final class CompanyServiceMock: CompanyService {
    private var storage: [UUID: [Company]] = [:]

    func observeCompanies(for userId: UUID) -> AsyncStream<[Company]> {
        AsyncStream { continuation in
            let current = storage[userId] ?? []
            continuation.yield(current)
            continuation.onTermination = { _ in }
        }
    }

    func createCompanyForUser(userId: UUID,
                              name: String,
                              categoryId: String,
                              employeesCount: Int,
                              roleId: String) async -> Company {
        let company = Company(
            id: UUID(),
            name: name,
            categoryId: categoryId,
            employeesCount: employeesCount,
            ownerId: userId
        )
        var companies = storage[userId] ?? []
        companies = companies.filter { $0.ownerId == userId }
        companies.append(company)
        storage[userId] = companies
        return company
    }
}
