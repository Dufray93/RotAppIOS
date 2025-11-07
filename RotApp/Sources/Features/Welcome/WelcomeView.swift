import SwiftUI

struct WelcomeView: View {
    var onLoginTap: () -> Void = {}
    var onRegisterTap: () -> Void = {}
    var onAboutTap: () -> Void = {}

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [Color.black.opacity(0.25), Color.black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer(minLength: 40)

                Image("rotapp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)
                    .shadow(radius: 12)

                Spacer()

                VStack(spacing: 20) {
                    Button("Iniciar sesión", action: onLoginTap)
                        .buttonStyle(.borderedProminent)
                        .tint(.accentColor)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity, minHeight: 56)

                    HStack(spacing: 6) {
                        Text("¿No tienes cuenta?")
                            .foregroundColor(.white.opacity(0.85))
                        Button("Regístrate", action: onRegisterTap)
                            .font(.system(size: 16, weight: .bold))
                    }

                    Button("Acerca de RotApp", action: onAboutTap)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppContainer())
}
