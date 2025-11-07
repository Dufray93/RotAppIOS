
import Foundation

struct Company: Identifiable, Equatable {
    let id: UUID
    var name: String
    var categoryId: String
    var employeesCount: Int
    var ownerId: UUID
}
