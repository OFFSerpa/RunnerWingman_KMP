//
//  FixedButton.swift
//  RunnerWingmanKMP
//

import SwiftUI

struct FixedButton: View {

    let viewData: ViewData

    var body: some View {
        Text(viewData.title)
            .font(.system(size: 26))
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.yellow)
                    .shadow(radius: 3, y: 1)
            }
    }
}

extension FixedButton  {
    struct ViewData {
        let title: String
    }
}

#Preview {
    FixedButton(viewData: .init(title: "Nova Rota"))
}
