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
        VStack(alignment: .leading, spacing: 16) {
            Text("Acerca de RotApp")
                .font(.title.weight(.bold))
            Text("Versión iOS en construcción. Aquí irá la descripción y el equipo.")
            Spacer()
            Button("Volver", action: onBack)
        }
        .padding()
    }
}

#Preview {
    AboutView()
}
