//
//  AddVariants.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 30/01/2022.
//

import SwiftUI

struct AddVariants: View {
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var product: Product?
    @Binding var isBannerShow: Bool
    @Binding var bannerData: BannerModifier.BannerData
    @State var color: Int = 0
    @State var size: [Int] = []
    @State var colors: [ColorData]
    @State var sizes: [Size: Int]
    @State var prices: [Size: String]
    @State var price = "100.0"
    @State var qunatity = 0;
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    
    var body: some View {
        Form{
            Section{
                Text(product!.name!)
                if let desc = product!.desc{
                    Text(desc)
                }
                Text(product!.collection!.name!)
                Text(product!.category!.name!)
                ZStack{
                    Rectangle()
                        .fill(image == nil ? .secondary : .primary)
                    if image == nil{
                    Text("Tap to select image")
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture{
                    showingImagePicker = true
                }
            }
            
            Section(header: Text("Variant details")){
                if (!colors.isEmpty){
                    ColorSelectionView($colors, selection: $color)
                }
                if(sizes.isEmpty){
                    HStack{
                        VStack{
                            Text("Ilość: \(qunatity)")
                            Stepper("ilość",value: $qunatity, in: 0 ... 1000)
                                .labelsHidden()
                        }
                        Spacer()
                        VStack{
                            Text("Price")
                            TextField("Price", text: $price)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                } else {
                    ForEach(Array(sizes.keys).sorted{$0.value ?? "A" < $1.value ?? "B"}, id: \.self){ (key) in
                        HStack{
                            VStack{
                                Text("Size")
                                Spacer()
                                Text(key.value!)
                            }
                            VStack{
                                Text("Ilość: \(sizes[key]!)")
                                Stepper("ilość") {
                                    sizes[key] = sizes[key]! + 1
                                } onDecrement: {
                                    if(sizes[key] ?? 1 > 0){
                                        sizes[key] = sizes[key]! - 1
                                    }
                                }
                                .labelsHidden()
                            }
                            Spacer()
                            VStack{
                                Text("Price")
                                TextField("Price", text: binding(for: key))
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Complete")) {
                HStack{
                    if(!colors.isEmpty){
                        Button(action:{presentation.wrappedValue.dismiss()}){
                            Text("Finish")
                        }
                        .tint(.red)
                        .buttonStyle(BorderedButtonStyle())
                        Button(action: {
                            saveVariant()
                            presentation.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                        }
                        .tint(.green)
                        .buttonStyle(BorderedProminentButtonStyle())
                        Button(action: {addNextVariant()}){
                            Text("Save and add next")
                        }
                        .tint(.green)
                        .buttonStyle(BorderedButtonStyle())
                    }
                }
            }
        }
        .environment(\.defaultMinListRowHeight, 70)
        .onChange(of: inputImage) { _ in loadImage()}
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    init(product: Binding<Product?>, isBannerShow: Binding<Bool>, bannerData: Binding<BannerModifier.BannerData>){
        self._product = product
        let sizeList = product.wrappedValue!.category!.sizeList!.allObjects as! [Size]
        var sizes: [Size : Int] = [:]
        var prices: [Size: String] = [:]
        if(!sizeList.isEmpty){
            sizeList.forEach{ size in
                sizes[size] = 0
                prices[size] = "100.0"
            }
        }
        _colors = State(initialValue: product.wrappedValue!.collection!.colors!.allObjects as! [ColorData])
        _sizes = State(initialValue: sizes)
        _prices = State(initialValue: prices)
        _isBannerShow = isBannerShow
        _bannerData = bannerData
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    private func binding(for key: Size) -> Binding<String> {
        return Binding(get: {
            return self.prices[key] ?? "0.00"
        }, set: {
            self.prices[key] = $0
        })
    }
    
    func saveVariant(){
        var imageName: String? = nil
        if let image = inputImage {
            imageName = "\(product!.name!) \(colors[color].name!)"
            guard saveImage(image: image, name: imageName!) == true else{
                return
            }
        }
        if(sizes.isEmpty){
            let newVariant = Variant(context: viewContext)
            newVariant.product = self.product
            newVariant.id = UUID()
            newVariant.quantity = Int64(self.qunatity)
            if !colors.isEmpty{
                newVariant.color = colors[color]
            }
            if let imageName = imageName{
                newVariant.img = imageName
            }
            guard let price = Double(self.price) else{
                return
            }
            newVariant.price = price
        } else {
            Array(sizes.keys).forEach{ key in
                let newVariant = Variant(context: viewContext)
                newVariant.product = self.product
                newVariant.id = UUID()
                newVariant.size = key
                newVariant.quantity = Int64(sizes[key]!)
                if !colors.isEmpty{
                    newVariant.color = colors[color]
                }
                if let imageName = imageName{
                    newVariant.img = imageName
                }
                guard let price = Double(prices[key]!) else{
                    return
                }
                newVariant.price = price
            }
        }
        do {
            try viewContext.save()
            bannerData = BannerModifier.BannerData(title: "Add new varinats! ", detail: "For color: \(colors[color].name!)" , type: .Success)
        } catch {
            bannerData = BannerModifier.BannerData(title: "Nie udało się dodać nowych variantow", detail: "Skontaktuj się z administratorem" , type: .Error)
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addNextVariant(){
        saveVariant()
        colors.remove(at: color)
        color = 0
        inputImage = nil
        image = nil
    }
}

//struct AddVariants_Previews: PreviewProvider {
//    static var previews: some View {
//        AddVariants(product: createProduct())
//    }
//}
