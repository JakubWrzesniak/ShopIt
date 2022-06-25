//
//  SizeSelectionView.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 14/12/2021.
//

import SwiftUI

struct SizeSelectionView: View {
    @State private var showList: Bool = false
    @Binding var selectedSize: Int
    var sizeList: [Size]
    
    
    var body: some View {
        Picker(selection: $selectedSize, label: Text("Size")) {
            ForEach(sizeList.indices){ idx in
                Text(sizeList[idx].value!).tag(idx)
            }
        }
        .pickerStyle(.menu)
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .frame(alignment: .center)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color(white: 0, opacity: 0.3), radius: 7, x: 0, y: 1)
        .padding()
    }
    
    init(_ sizeList: [Size], selection: Binding<Int>){
        self.sizeList = sizeList.sorted{$0.value! > $1.value!}
        _selectedSize = selection
    }
}

//struct SizeSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SizeSelectionView()
//    }
//}
