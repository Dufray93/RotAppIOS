//
//  CreateCompanyView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import SwiftUI

struct CreateCompanyView: View {
    var onBack: () -> Void = {}
    var onCompanyCreated: (UUID) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 16) {
            Text("Crear Empresa (pendiente)")
            Button("Guardar") {
                onCompanyCreated(UUID())
            }
            Button("Volver", action: onBack)
            Spacer()
        }
        .padding()
    }
}
