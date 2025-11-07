//
//  CompanyService.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

protocol CompanyService {
    func observeCompanies(for userId: UUID) -> AsyncStream<[Company]>
    func createCompanyForUser(userId: UUID,
                              name: String,
                              categoryId: String,
                              employeesCount: Int,
                              roleId: String) async -> Company
}
