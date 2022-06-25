//
//  EditProduct.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 31/01/2022.
//

import SwiftUI
import CoreData

struct EditProduct: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var product: Product
    @State var name: String
    @State var desc: String
    
    init(_ product: Product){
        self.product = product
        self._name = State(initialValue: product.name!)
        self._desc = State(initialValue: product.desc!)
    }
    
    var body: some View {
        Form{
            Section(header: Text("Product Details")){
                TextField("Name", text: $name)
            }
            
            Section(header: Text("Product sepcification")){
                Text("Category: \(product.category!.name!)")
                Text("Collection: \(product.collection!.name!)")
            }
            
            Section(header: Text("Description")){
                TextEditor(text: $desc)
            }
            Section{
                Spacer()
                Button(action: {
                    updateProducst()
                }){
                    Text("Save changes")
                }
                .tint(.green)
                .buttonStyle(BorderedButtonStyle())
                Spacer()
            }
        }
    }
    
    func updateProducst(){
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id = %@", product.id! as CVarArg)
        do {
            let test = try viewContext.fetch(fetchRequest)
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(product.name, forKey: "name")
            objectUpdate.setValue(product.desc, forKey: "desc")
            do {
                try viewContext.save()
            }
            catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

//struct EditProduct_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProduct()
//    }
//}
