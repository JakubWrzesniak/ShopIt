//
//  CardView.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 08/12/2021.
//

import SwiftUI

struct CardView: View {
    var img: String
    var title: String?
    var description: String?
    var width: CGFloat = 350.0
    var height: CGFloat = 200.0
    
    var body: some View {
        BaseCardView(width, height){
            ZStack(alignment: .bottomLeading){
                getImage(named: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                HStack(alignment: .center){
                    VStack(alignment: .leading){
                        if let title = title {
                            Text(title)
                                .font(.system(size: 20, weight: .bold, design: .default))
                        }
                        if let description = description {
                            Text(description)
                                .font(.system(size: 15, weight: .bold, design: .default))
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.white)
                .background(Color(white: 0, opacity: 0.7).blur(radius: 10))
                .padding([.leading, .bottom, .trailing])
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(img: "streetWear", title: "Letnia Wyprzedaż", description: "Wybrane produkty do -50%")
        
    }
}
