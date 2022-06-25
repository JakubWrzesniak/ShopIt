//
//  ProductCardView.swift.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 08/12/2021.
//

import SwiftUI
import AVFoundation

struct ProductCardView: View {
    private var product: Product
    private var colors: [ProductColorsVariants]
    @State private var uniqueColors: [ColorData]
    private var heigh: CGFloat
    private var width: CGFloat
    @State private var selectedVariant: Int = 0
    
    var body: some View {
        NavigationLink(destination: {ProductDetailsView(product: product)}){
            BaseCardView(width, heigh) {
                VStack(alignment: .center){
                    if !colors.isEmpty{
                    if let img = colors[selectedVariant].img {
                        getImage(named: img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.8, height: heigh * 0.7, alignment: .center)
                    }
                    if colors.count > 1{
                        Spacer()
                        ColorSelectionView($uniqueColors, selection: $selectedVariant)
                            .frame(width: width * 0.8, alignment: .center)
                    }
                    }
                    Spacer()
                    Text(product.name!)
                    Spacer()
                }
            }
        }
    }
    
    init(product: Product, heigh: CGFloat = 350, width: CGFloat = 250){
        self.product = product
        if let variants = product.variants?.allObjects as? [Variant]{
            let vari = variants.map{ProductColorsVariants(img: $0.img, color: $0.color)}
            self.colors =  Array(Set(vari)).sorted{v1, v2 in
                if let id1 = v1.color?.name
                    , let id2 = v2.color?.name {
                    return id1 > id2
                }
                return false
            }
        } else{
            self.colors = []
        }
        self.width = width
        self.heigh = heigh
        self._uniqueColors = State(initialValue: self.colors.compactMap{$0.color})
    }
    
    init(variant: Variant, heigh: CGFloat = 350, width: CGFloat = 250){
        self.product = variant.product!
        self.width = width
        self.heigh = heigh
        self.colors = []
        self._uniqueColors = State(initialValue: self.colors.compactMap{$0.color})
    }
    
    init(variant: VariantNoSize, heigh: CGFloat = 350, width: CGFloat = 250){
        self.product = variant.product!
        self.width = width
        self.heigh = heigh
        self.colors = [ProductColorsVariants(img: variant.img, color: variant.color)]
        self._uniqueColors = State(initialValue: self.colors.compactMap{$0.color})
    }
}


//struct ProductCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCardView(product: newProduct)
//    }
//}
