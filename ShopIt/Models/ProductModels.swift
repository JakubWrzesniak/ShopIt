//
//  ProductModels.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 13/12/2021.
//

import Foundation
import SwiftUI
import CoreData

struct ProductColorsVariants: Hashable{
    var img: String?
    var color: ColorData?
    
    init(img: String?, color: ColorData?){
        self.img = img
        self.color = color
    }
}

struct VariantNoSize: Identifiable, Hashable {
    var img: String?
    var color: ColorData?
    var product: Product?
    var id: String
    
    init(_ variant: Variant){
        self.img = variant.img
        self.color = variant.color
        self.product = variant.product
        self.id = String(color?.name!.hashValue ?? 0) + String(product!.id!.hashValue)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(product)
        hasher.combine(color)
    }
}


