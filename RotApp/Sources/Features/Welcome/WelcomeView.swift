//
//  WelcomeView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import SwiftUI

struct WelcomeView: View {
    var onLoginTap: () -> Void = {}
    var onRegisterTap: () -> Void = {}
    var onAboutTap: () -> Void = {}

    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()
                Image("rotapp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)
                Spacer()
                VStack(spacing: 16) {
                    Button("Iniciar sesión", action: onLoginTap)
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity, minHeight: 56)
                    HStack(spacing: 4) {
                        Text("¿No tienes cuenta?")
                        Button("Regístrate", action: onRegisterTap)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    Button("Acerca de RotApp", action: onAboutTap)
                        .foregroundColor(.white.opacity(0.8))
                        .font(.footnote)
                }
                .padding(.horizontal, 32)
                Spacer()
            }
        }
    }
}

#Preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(AppContainer())
    }
}
