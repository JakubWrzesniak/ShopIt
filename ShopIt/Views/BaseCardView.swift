//
//  BaseCardView.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 15/12/2021.
//

import SwiftUI

struct BaseCardView<Content: View>: View {
    let content: Content
    let width: CGFloat?
    let heigh: CGFloat?
    
    init(_ width: CGFloat? = nil, _ heigh: CGFloat? = nil, @ViewBuilder content: () -> Content){
        self.width = width
        self.heigh = heigh
        self.content = content()
    }
    
    var body: some View {
            content
            .frame(width: width, height: heigh, alignment: .center)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: Color(white: 0, opacity: 0.3), radius: 7, x: 0, y: 1)
            .padding()
    }
}

struct BaseCardView_Previews: PreviewProvider {
    static var previews: some View {
        BaseCardView(){
            Text("Ala ma Kota")
        }
    }
}
