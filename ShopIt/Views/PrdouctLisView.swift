//
//  PrdouctLisView.swift.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 15/12/2021.
//

import SwiftUI
import CoreData

struct PrdouctLisView: View {
    @Environment(\.managedObjectContext) var viewContext
    var fetchRequest: FetchRequest<Variant>
    var products: [[VariantNoSize]]
    
    var body: some View {
        let products = Array(Set(Array(fetchRequest.wrappedValue).map{
            VariantNoSize($0)
        })).chunked(into: 2)
        GeometryReader{ geomtry in
            ScrollView(.vertical){
                ForEach(products, id: \.self){ pair in
                    HStack{
                        ForEach(pair, id: \.self){ variant in
                            ProductCardView(variant: variant,  heigh: geomtry.size.height * 0.3, width: geomtry.size.width * 0.4)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    init(_ predicate: NSPredicate){
        fetchRequest = FetchRequest<Variant>(entity: Variant.entity(), sortDescriptors: [], predicate: predicate)
        self.products =
            Array(Set(Array(fetchRequest.wrappedValue).map{
                VariantNoSize($0)
            })).chunked(into: 2)
    }
    
    init(){
        fetchRequest = FetchRequest<Variant>(entity: Variant.entity(), sortDescriptors: [])
        self.products =
            Array(Set(Array(fetchRequest.wrappedValue).map{
                VariantNoSize($0)
            })).chunked(into: 2)
    }
}

struct PrdouctLisView_swift_Previews: PreviewProvider {
    static var previews: some View {
        PrdouctLisView(NSPredicate(format: "product.collection.name LIKE %@", "Street"))
    }
}
