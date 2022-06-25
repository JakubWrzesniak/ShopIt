//
//  CartModel.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 29/01/2022.
//

import Foundation

class CartItem: Identifiable, ObservableObject {
    let id: UUID
    let variant: Variant
    var quantity: Int64
    
    init(_ variant: Variant, _ quantity: Int64){
        self.id = UUID()
        self.variant = variant
        self.quantity = quantity
    }
    
    func setQuantity(newQuantity: Int64) -> Void {
        self.quantity = newQuantity
    }
    
    func addToQuantity(value: Int64) -> Void {
        setQuantity(newQuantity: self.quantity + value)
    }
}

