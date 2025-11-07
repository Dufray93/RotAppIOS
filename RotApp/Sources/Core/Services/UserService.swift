//
//  UserService.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

protocol UserService {
    func validateCredentials(email: String, password: String) async -> Bool
    func activeUserStream() -> AsyncStream<User?>
    func setActiveUser(_ user: User?) async
    func registerUser(fullName: String, email: String, password: String) async -> User
    func updateRole(for userId: UUID, roleId: String) async
    func getActiveUser() async -> User?
}
