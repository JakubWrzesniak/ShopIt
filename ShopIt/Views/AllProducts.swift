//
//  AllProducts.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 30/01/2022.
//

import SwiftUI

struct AllProducts: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.name!)],
        animation: .default)
    private var products: FetchedResults<Product>
    
    @State var isgEditVisible = false
    
    var body: some View{
        NavigationView{
            List(){
                ForEach(products) {product in
                    NavigationLink(destination: EditProduct(product)){
                    VStack(alignment: .leading, spacing: 5){
                        HStack{
                            Text(product.name!)
                                .font(.headline)
                            Text(product.category!.name!)
                            Text(product.collection!.name!)
                        }
                        Text(product.desc!)
                            .lineLimit(2)
                    }
                    }
                }
                .onDelete(perform: deleteProduct)
            }
            .toolbar{
                    EditButton()
            }
        .navigationTitle("All Products")
    }
    }
    
    func deleteProduct(at offsets: IndexSet){
        for index in offsets {
            let product = products[index]
            viewContext.delete(product)
        }
    }
    
    struct AllProducts_Previews: PreviewProvider {
        static var previews: some View {
            AllProducts()
        }
    }
}
