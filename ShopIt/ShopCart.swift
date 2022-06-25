//
//  ShopCart.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 03/01/2022.
//

import Foundation
import CoreData

class ShopCart : ObservableObject{
    @Published var cartItems: [CartItem]
    static let shared: ShopCart = ShopCart()
    
    private init(){
        self.cartItems = []
    }
    
    func addToCart(variant: Variant, quantity: Int64){
        let cartVariants = cartItems.map { $0.variant }
        if (cartVariants.contains(variant)){
            let vari = cartItems.first() {
                $0.variant.isEqual(variant)
            }
            vari!.addToQuantity(value: quantity)
        } else {
            let productInCart = CartItem(variant, quantity)
            cartItems.append(productInCart)
        }
        objectWillChange.send()
    }
}
