
import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    var fullName: String
    var email: String
    var password: String
    var roleId: String?
    var isActive: Bool
}

