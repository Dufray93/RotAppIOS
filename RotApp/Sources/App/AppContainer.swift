//
//  AppContainer.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//
import Foundation

final class AppContainer: ObservableObject {
    // MARK: - Services

    let userService: UserService
    let companyService: CompanyService

    init() {
        self.userService = UserServiceMock()
        self.companyService = CompanyServiceMock()
    }
}
