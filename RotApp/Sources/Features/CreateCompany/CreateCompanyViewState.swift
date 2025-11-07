import Foundation

enum CompanyCategory: String, CaseIterable, Identifiable {
    case all
    case health
    case retail
    case services
    case manufacturing

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "Todas las industrias"
        case .health: return "Salud"
        case .retail: return "Retail"
        case .services: return "Servicios"
        case .manufacturing: return "Manufactura"
        }
    }

    static var defaults: [CompanyCategory] { Array(allCases) }
}

struct CreateCompanyViewState {
    var name: String = ""
    var category: CompanyCategory = .all
    var employeesCount: Int = 10
    var isLoading: Bool = false
    var errorMessage: String?
    var isSuccess: Bool = false
    var generatedCompanyId: UUID?
}
