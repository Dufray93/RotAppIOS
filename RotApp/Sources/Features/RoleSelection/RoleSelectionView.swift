//
//  RoleSelectionView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import SwiftUI

struct RoleSelectionView: View {
    var onBack: () -> Void = {}
    var onRoleConfirmed: (String) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 16) {
            Text("Selecciona un rol")
                .font(.title2.weight(.semibold))
            Button("Administrador") { onRoleConfirmed("admin") }
                .buttonStyle(.borderedProminent)
            Button("Colaborador") { onRoleConfirmed("collab") }
            Spacer()
            Button("Volver", action: onBack)
        }
        .padding()
    }
}
