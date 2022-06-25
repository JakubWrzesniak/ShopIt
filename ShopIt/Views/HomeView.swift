//
//  HomeView.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 15/12/2021.
//

import SwiftUI
import CoreData

struct HomeView: View {
    var products: FetchedResults<Product>
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false){
                VStack(){
                    CardView(img: "streetWear", title: "Letnia Wyprzedaż", description: "Wybrane produkty do -50%")
                        .frame(alignment: .center)
                    Text("Collections")
                        .frame(alignment: .leading)
                    CollectionsListView()
                    Text("Street")
                    Text("Autum/Summer")
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(products){ product in
                                ProductCardView(product: product, heigh: 300, width: 200)
                            }
                        }
                    }
                }
        }
        .background(Color(uiColor: UIColor(hex: "bcd8d5") ?? UIColor(.white)))
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
