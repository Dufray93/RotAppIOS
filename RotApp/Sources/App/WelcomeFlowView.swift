import SwiftUI

struct WelcomeFlowView: View {
    @EnvironmentObject private var container: AppContainer
    @State private var path = NavigationPath()

    private enum Route: Hashable {
        case login
        case register
        case about
        case roleSelection
        case createCompany
    }

    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView(
                onLoginTap: { path.append(Route.login) },
                onRegisterTap: { path.append(Route.register) },
                onAboutTap: { path.append(Route.about) }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .login:
                    LoginView(
                        userService: container.userService,
                        onBack: { popIfNeeded() },
                        onLoginSuccess: {
                            popIfNeeded()
                            path.append(Route.roleSelection)
                        }
                    )

                case .register:
                    RegisterView(
                        userService: container.userService,
                        onBack: { popIfNeeded() },
                        onNavigateToRole: {
                            popIfNeeded()
                            path.append(Route.roleSelection)
                        }
                    )

                case .about:
                    AboutView(onBack: { popIfNeeded() })

                case .roleSelection:
                    RoleSelectionView(
                        userService: container.userService,
                        onBack: { popIfNeeded() },
                        onRoleConfirmed: { _ in
                            popIfNeeded()
                            path.append(Route.createCompany)
                        }
                    )

                case .createCompany:
                    CreateCompanyView(
                        userService: container.userService,
                        companyService: container.companyService,
                        onBack: { popIfNeeded() },
                        onCompanyCreated: { _ in
                            path = NavigationPath()
                        }
                    )
                }
            }
        }
    }

    private func popIfNeeded() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
