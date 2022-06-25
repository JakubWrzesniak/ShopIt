//
//  ProductDetails.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 13/12/2021.
//

import SwiftUI
import CoreData

struct ProductDetailsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @StateObject private var product: Product
    @State private var colors: [ColorData]
    @State private var sizes: [Size]
    @State private var description: String
    @State private var variants: [Variant]
    @State private var selectedVariant: Variant?
    @State private var selectedColor: Int = 0
    @State private var selectedSize: Int = 0
    @State private var selectedQuantity: Int = 1
    @State var showBanner: Bool = false
    @State var bannerData: BannerModifier.BannerData
    
    var body: some View {
        if let selectedVariant = selectedVariant{
            ScrollView{
                BaseCardView{
                    VStack(alignment: .leading){
                        if let img = selectedVariant.img {
                            getImage(named: img)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                        if colors.count > 0{
                            Spacer()
                            ColorSelectionView($colors, selection: $selectedColor.onChange(onChangeColor))
                        }
                        Spacer()
                        HStack{
                            VStack{
                                Text(product.name!)
                                    .padding([.leading])
                                    .padding(.bottom, 5)
                                    .font(.system(size: 25, weight: .bold, design: .default))
                                if let price = selectedVariant.price{
                                    Text(String(format: "%.2f zł", price))
                                        .padding([.leading])
                                        .padding(.bottom, 5)
                                        .font(.system(size: 20, weight: .bold, design: .default))
                                }
                            }
                            if sizes.count > 0{
                                Spacer()
                                SizeSelectionView(sizes, selection: $selectedSize.onChange(onChangeSize))
                                    .zIndex(999)
                            }
                        }
                        HStack{
                            Text("\(selectedQuantity)")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color(white: 0, opacity: 0.3), radius: 7, x: 0, y: 1)
                            Spacer()
                            Stepper("Ilość", value: $selectedQuantity, in: 0...Int(selectedVariant.quantity))
                                .labelsHidden()
                            Spacer()
                            Section{
                            Button(action: {
                                ShopCart.shared.addToCart(variant: selectedVariant, quantity: Int64(selectedQuantity))
                                withAnimation{
                                    showBanner = true
                                }
                            } ){
                                Image(systemName: "cart.fill.badge.plus")}
                            }
                            .tint(.mint)

                            .disabled(selectedVariant.quantity < selectedQuantity)
                            .font(.system(size: 25))
                        }
                        .padding()
                        Spacer()
                    }
                    .padding()
                }
                BaseCardView{
                    VStack(alignment: .center){
                        Text("Opis produktu")
                            .font(.system(size: 30, weight: .heavy, design: .default))
                            .padding()
                        Text(product.desc ?? "Ten produkt jeszcze nie ma opisu")
                    }
                    .padding()
                }
            }
            .banner(data: $bannerData, show: $showBanner)
            .background(getAngularBackgroundGradient(colorData: product.collection?.colors?.allObjects as! [ColorData]))
    }
    }
    
    init(product: Product){
        _product = StateObject(wrappedValue:  product)
        _variants = State(initialValue: product.variants?.allObjects as! [Variant])
        _colors = State(initialValue:  getProductColors(product: product))
        _sizes = State(initialValue: getProductSizes(product: product))
        _description = State(initialValue:  product.desc ?? "")
        _bannerData = State(initialValue:  getBanner(product: product))
        _selectedVariant = State(initialValue: product.variants?.allObjects.first as? Variant)
    }

    
    init(variant: Variant){
        _product = StateObject(wrappedValue: variant.product!)
        _variants = State(initialValue: variant.product!.variants?.allObjects as! [Variant])
        _colors = State(initialValue: getProductColors(product: variant.product!))
        _sizes = State(initialValue: getProductSizes(product: variant.product!))
        _description = State(initialValue: variant.product!.desc ?? "")
        _bannerData = State(initialValue: getBanner(product: variant.product!))
        _selectedVariant = State(initialValue: variant)
    }
    
    func onChangeColor(to val: Int){
        selectedVariant = variants.first{ v in
            if sizes.count > 0 {
                return v.color!.isEqual(colors[val]) && v.size!.isEqual(sizes[selectedSize])
            } else {
                return v.color!.isEqual(colors[val])
            }
        }!
    }
    
    func onChangeSize(to val: Int){
        selectedVariant = variants.first{ v in
            if colors.count > 0 {
                return v.color!.isEqual(colors[selectedColor]) && v.size!.isEqual(sizes[val])
            } else {
                return v.size!.isEqual(sizes[selectedSize])
            }
        }!
    }
}

func getBanner(product: Product) -> BannerModifier.BannerData{
    return  BannerModifier.BannerData(title: "Dodano produkt do koszyka", detail: product.name ?? "" , type: .Success)
}

//struct ProductDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductDetails()
//    }
//}
