//
//  ProductCreation.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 30/01/2022.
//

import SwiftUI

struct ProductCreation: View {
    @State var addingVariant: Bool = false
    @State var product: Product?
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Warning)
    @State var isBannerShow: Bool = false
    
    var body: some View {
            if(!addingVariant){
                AddProduct(newProduct: $product, addingVariant: $addingVariant, isBannerShow: $isBannerShow, bannerData: $bannerData)
                    .banner(data: $bannerData, show: $isBannerShow)
            }
            else{
                AddVariants(product: $product, isBannerShow: $isBannerShow, bannerData: $bannerData)
                    .banner(data: $bannerData, show: $isBannerShow)
            }
    }
}

//struct ProductCreation_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCreation()
//    }
//}
