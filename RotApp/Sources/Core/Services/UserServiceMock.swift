//
//  UserServiceMock.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

final class UserServiceMock: UserService {
    private var users: [User]
    private var activeUser: User? {
        didSet { streamContinuation?.yield(activeUser) }
    }

    private var activeUserStreamInternal: AsyncStream<User?>!
    private var streamContinuation: AsyncStream<User?>.Continuation?

    init() {
        let demo = User(
            id: UUID(),
            fullName: "Usuario Demo",
            email: "demo@rotapp.com",
            password: "123456",
            roleId: "admin",
            isActive: true
        )
        self.users = [demo]
        self.activeUser = nil
        setupStream()
    }

    private func setupStream() {
        activeUserStreamInternal = AsyncStream { continuation in
            streamContinuation = continuation
            continuation.yield(activeUser)
        }
    }

    func validateCredentials(email: String, password: String) async -> Bool {
        guard let index = users.firstIndex(where: { $0.email == email && $0.password == password }) else {
            return false
        }

        for i in users.indices {
            users[i].isActive = false
        }
        users[index].isActive = true
        await setActiveUser(users[index])
        return true
    }

    func activeUserStream() -> AsyncStream<User?> {
        activeUserStreamInternal
    }

    func setActiveUser(_ user: User?) async {
        activeUser = user
    }

    func registerUser(fullName: String, email: String, password: String) async -> User {
        if let existingIndex = users.firstIndex(where: { $0.email == email }) {
            users[existingIndex].fullName = fullName
            users[existingIndex].password = password
            users[existingIndex].isActive = true
            await setActiveUser(users[existingIndex])
            return users[existingIndex]
        }

        let user = User(
            id: UUID(),
            fullName: fullName,
            email: email,
            password: password,
            roleId: nil,
            isActive: true
        )
        for i in users.indices {
            users[i].isActive = false
        }
        users.append(user)
        await setActiveUser(user)
        return user
    }

    func updateRole(for userId: UUID, roleId: String) async {
        guard let index = users.firstIndex(where: { $0.id == userId }) else { return }
        users[index].roleId = roleId
        if users[index].id == activeUser?.id {
            activeUser?.roleId = roleId
            streamContinuation?.yield(activeUser)
        }
    }

    func getActiveUser() async -> User? {
        activeUser
    }
}
