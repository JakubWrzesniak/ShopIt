//
//  AddProduct.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 30/01/2022.
//

import SwiftUI

struct AddProduct: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.name!)],
        animation: .default)
    private var categories: FetchedResults<ProductCategory>
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.name!)],
        animation: .default)
    private var lines: FetchedResults<ProductLine>
    
    @Binding var newProduct: Product?
    @Binding var addingVariant: Bool
    @State var name: String = ""
    @State var desc: String = ""
    @State var category  = 0
    @State var line = 0
    
    @Binding var isBannerShow: Bool
    @Binding var bannerData: BannerModifier.BannerData
    
    var body: some View {
        Form{
            Section(header: Text("Product Details")){
                TextField("Name", text: $name)
            }
            
            Section(header: Text("Product sepcification")){
                Picker(selection: $category, label: Text("Category")){
                    ForEach(0 ..< categories.count){
                        Text(self.categories[$0].name!)
                    }
                }
                VStack{
                    Picker("Collection", selection: $line){
                        ForEach(0 ..< lines.count){
                            Text(self.lines[$0].name!)
                        }
                    }
                }
            }
            
            Section(header: Text("Description")){
                TextEditor(text: $desc)
            }
            
            Section(){
                if let _ = newProduct{
                    
                } else {
                    Button(action: {
                            AddNewProduct()
                    }){
                        Text("Add variants")
                    }
                }
                
            }
        }
        .navigationTitle(Text("Nowy Produkt"))
    }
    
    func AddNewProduct(){
        
        if self.name.isEmpty {
            bannerData = BannerModifier.BannerData(title: "Nie poprawne dane", detail: "Prosze podać nazwę produktu" , type: .Warning)
        } else {
            let newProduct = Product(context: viewContext)
            newProduct.id = UUID()
            newProduct.name = name
            newProduct.category = categories[category]
            newProduct.collection = lines[line]
            newProduct.desc = desc
            
            do {
                try viewContext.save()
                bannerData = BannerModifier.BannerData(title: "Dodano nowy produkt", detail: "\(newProduct.name!) - \(newProduct.category!.name!) - \(newProduct.collection!.name!)" , type: .Success)
                self.newProduct = newProduct
                withAnimation{
                    addingVariant = true
                }
                name = ""
                desc = ""
                category = 0
                line = 0
            } catch {
                bannerData = BannerModifier.BannerData(title: "Nie udało się dodać nowego produktu", detail: "Skontaktuj się z administratorem" , type: .Error)
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        isBannerShow = true;
    }
}

//struct AddProduct_Previews: PreviewProvider {
//    @State var x = false
//    static var previews: some View {
//        AddProduct(rootIsActive: $x)
//    }
//}
