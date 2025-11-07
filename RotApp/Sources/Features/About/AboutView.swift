//
//  AboutView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//
import SwiftUI

struct AboutView: View {
    var onBack: () -> Void = {}

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                TopBar(onBack: onBack)

                ScrollView {
                    VStack(alignment: .center, spacing: 24) {
                        Image("rotapp")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 160)

                        VStack(alignment: .center, spacing: 8) {
                            Text("RotApp")
                                .font(.system(size: 28, weight: .bold))

                            Text("RotApp ayuda a equipos con turnos rotativos a planificar y comunicar horarios de forma eficiente.")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Desarrollado por")
                                .font(.system(size: 15, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Dufray Manquillo")
                                .font(.system(size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Text("Versión 1.0.0")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                }
            }
        }
    }
}

private struct TopBar: View {
    var onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(10)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }

            Text("Acerca de")
                .font(.system(size: 22, weight: .bold))

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
    }
}

#Preview {
    AboutView()
}
