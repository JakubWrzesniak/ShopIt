//
//  ColorSelectionView.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 08/12/2021.
//

import SwiftUI

struct ColorSelectionView: View{
    
    @Binding var colors: [ColorData]
    @Binding var selection: Int
    
    var body: some View {
        HStack{
            Spacer()
            ForEach(colors.indices) { idx in
                if(idx < self.colors.count ){
                    if let color = colors[idx].color{
                        Circle()
                            .fill(Color(uiColor: color))
                            .frame(width: 20, height: 20, alignment: .center)
                            .onTapGesture {
                                selection = idx
                            }.shadow(color: idx == selection ? Color.cyan : Color.gray, radius: 7, x: 0, y: 0)
                        Spacer()
                    }
                }
            }
        }
    }
    
    init(_ colors: Binding<[ColorData]>, selection: Binding<Int>){
        self._colors = colors
        _selection = selection
    }
}

//struct ColorSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorSelectionView()
//    }
//}
