//
//  ScreenCard.swift
//  sims (iOS)
//
//  Created by Mark Kinoshita on 1/11/21.
//

import SwiftUI

struct ScreenCard: View {
    var label: String
    var reversed: Bool
    var body: some View {
            Rectangle()
                .foregroundColor(reversed ? .red : .white)
                .cornerRadius(20)
                .frame(width: UIScreen.screenWidth - 20, height: UIScreen.screenHeight / 3)
                .overlay(
                    Text(label)
                        .font(Font.custom("nasalization", size: 40))
                        .foregroundColor(reversed ? .white : .red)
                )
    }
}

struct ScreenCard_Previews: PreviewProvider {
    static var previews: some View {
        ScreenCard(label: "Label", reversed: false)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
