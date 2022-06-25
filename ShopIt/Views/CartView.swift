//
//  CartView.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 03/01/2022.
//

import SwiftUI

struct CartView: View {
   @StateObject var cart = ShopCart.shared
    
    var body: some View {
        let productsInCart = cart.cartItems
        if (!productsInCart.isEmpty){
            VStack{
                List{
                        ForEach(productsInCart) { item in
                                ProductInCartRow(item)
                        }
                    .onDelete(perform: removeProductFromCart)
                }.environment(\.defaultMinListRowHeight, 120)
                Spacer()
                Button(action: {
                }){
                    Text("Przejdź do kasy")
                }
                .tint(.indigo)
                .buttonStyle(BorderedButtonStyle())
            }
            
        } else {
            Text("Twój koszyk jest pusty")
                .font(.title)
        }
    }
    
    func removeProductFromCart(st offsets: IndexSet) {
        cart.cartItems.remove(atOffsets: offsets)
    }
}

struct ProductInCartRow: View{
    @ObservedObject var product: CartItem
    @State var selectedQuantity: Int64
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center){
                getImage(named: product.variant.img ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.2)
                VStack{
                    Text(String(format: "%.2f zł", product.variant.price))
                        .fontWeight(.bold)
                    Text(product.variant.product?.name ?? "")
                    Spacer()
                    HStack{
                        Stepper("Ilość", value: $selectedQuantity, in: 0...product.variant.quantity)
                            .labelsHidden()
                            .frame(width: geometry.size.width * 0.3 )
                        Text("\(selectedQuantity)")
                    }
                    Spacer()
                }
                Spacer()
                VStack{
                    Text(String(format: "%.2f zł", (product.variant.price * Double(selectedQuantity))))
                }
            }
        }
    }
    
    init(_ product: CartItem){
        self.product = product
        _selectedQuantity = State(initialValue: product.quantity)
    }
    
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
