
import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    var email: String
    var password: String
    var roleId: String?
}

