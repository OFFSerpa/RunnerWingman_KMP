//
//  ActionButton.swift
//  RunnerWingmanKMP
//

import SwiftUI

struct ActionButton: View {

    let viewData: ActionButton.ViewData
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(viewData.title)
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(viewData.color)
                        .shadow(radius: 3, y: 1)
                }
        }
        .buttonStyle(.plain)
    }
}

extension ActionButton {
    struct ViewData {
        let title: String
        let color: Color
    }
}

#Preview {
    ActionButton(
        viewData: ActionButton.ViewData(
            title: "Comecar",
            color: .green
        )) {
            print("Teste")
        }
}
