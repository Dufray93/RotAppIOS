//
//  UserServiceMock.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

final class UserServiceMock: UserService {
    private var users: [User]
    private var activeUser: User?
    private let streamContinuation: AsyncStream<User?>.Continuation

    init() {
        let demo = User(id: UUID(), email: "demo@rotapp.com", password: "123456", roleId: "admin")
        self.users = [demo]
        var continuation: AsyncStream<User?>.Continuation!
        let stream = AsyncStream<User?> { cont in
            continuation = cont
        }
        self.streamContinuation = continuation
        self.streamContinuation.yield(nil)
        self.activeUserStreamInternal = stream
    }

    private let activeUserStreamInternal: AsyncStream<User?>

    func validateCredentials(email: String, password: String) async -> Bool {
        guard let user = users.first(where: { $0.email == email && $0.password == password }) else {
            return false
        }
        await setActiveUser(user)
        return true
    }

    func activeUserStream() -> AsyncStream<User?> {
        activeUserStreamInternal
    }

    func setActiveUser(_ user: User?) async {
        activeUser = user
        streamContinuation.yield(user)
    }
}
