//
//  RegisterView.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import SwiftUI

struct RegisterView: View {
    var onBack: () -> Void = {}
    var onNavigateToRole: () -> Void = {}

    var body: some View {
        VStack(spacing: 24) {
            Text("Pantalla de registro (pendiente)")
            Button("Volver", action: onBack)
            Button("Elegir rol", action: onNavigateToRole)
            Spacer()
        }
        .padding()
    }
}
