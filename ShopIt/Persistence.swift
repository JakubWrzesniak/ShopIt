//
//  Persistence.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 01/12/2021.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let categoriesNames = ["T-Shirt", "Shoes", "Accessories"]
        let sizeListDef = [
            categoriesNames[0] : ["S", "M", "L" ,"XL", "XXL"],
            categoriesNames[1] : ["37", "38", "39", "40", "41", "42", "43"]
        ]
        let linesNames = ["Street": ["Navy", "Dark Green", "White", "Black"], "Rainbow": ["Pink", "Yellow", "Light Blue", "Light Green"], "Stylish": ["Gold", "Black", "Brown", "White"]]
        let colorsNames = [
            "Navy" : UIColor(hex: "22276f"),
            "Dark Green" : UIColor(hex: "2b5337"),
            "White": UIColor(hex: "f2f2f2"),
            "Pink": UIColor(hex: "e5acff"),
            "Yellow": UIColor(hex: "adf756"),
            "Light Green": UIColor(hex: "74d385"),
            "Light Blue" : UIColor(hex: "77d2ff"),
            "Brown": UIColor(hex: "382b24"),
            "Gold": UIColor(hex: "d7be78"),
            "Black" : UIColor(hex: "0c0c0c")
        ]
        
        let productsListDef = [
            ["T-Shirt 1", "T-Shirt", "Street"],
            ["T-Shirt 2", "T-Shirt", "Rainbow"],
            ["T-Shirt 3", "T-Shirt", "Stylish"],
            ["Shoes 1", "Shoes", "Street"],
            ["Shoes 2", "Shoes", "Street"],
            ["Shoes 3", "Shoes", "Street"],
            ["Shoes 4", "Shoes", "Rainbow"],
            ["Shoes 5", "Shoes", "Rainbow"],
            ["Shoes 6", "Shoes", "Rainbow"],
            ["Shoes 7", "Shoes", "Rainbow"],
            ["Shoes 8", "Shoes", "Stylish"],
            ["Shoes 9", "Shoes", "Stylish"],
            ["Shoes 10", "Shoes", "Stylish"],
            ["Cap 1", "Accessories", "Street"],
            ["Cap 2", "Accessories", "Rainbow"],
            ["Cap 3", "Accessories", "Stylish"]
        ]
        
        let varianstList = [
            ["T-Shirt 1", ["S", "M", "L" ,"XL", "XXL"], ["Navy", "Dark Green", "White", "Black"]],
            ["T-Shirt 2", ["S", "M", "L" ,"XL", "XXL"], ["Pink", "Yellow", "Light Blue", "Light Green"]],
            ["T-Shirt 3", ["S", "M", "L" ,"XL", "XXL"], ["Gold", "Black", "Brown", "White"]],
            ["Shoes 1", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Shoes 2", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Shoes 3", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Shoes 4", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Shoes 5", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Shoes 6", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Shoes 7", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Shoes 8", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Shoes 9", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Shoes 10", ["37", "38", "39", "40", "41", "42", "43"], []],
            ["Cap 1", [], ["Navy", "Dark Green", "White", "Black"]],
            ["Cap 2", [], ["Pink", "Yellow", "Light Blue", "Light Green"]],
            ["Cap 3", [], ["Gold", "Brown"]],
        ]
        
        
        let categories = categoriesNames.map { (name) -> ProductCategory in
                let newCategory = ProductCategory(context: viewContext)
                newCategory.id = UUID()
                newCategory.name = name
                return newCategory
        }
        
        let sizeList = sizeListDef.flatMap{ (k,v) -> [Size] in
            let curCat = categories.first { cat in
                cat.name!.elementsEqual(k)
            }
            return v.map{ (size) -> Size in
                let newSize = Size(context: viewContext)
                newSize.id = UUID()
                newSize.value = size
                newSize.addToCategories(curCat!)
                return newSize
            }
        }
        
        let colors = colorsNames.map { (color) -> ColorData in
            let newColor = ColorData(context: viewContext)
            newColor.id = UUID()
            newColor.name = color.key
            newColor.color = color.value
            return newColor
        }
        
        let lines = linesNames.map{ (name, col) -> ProductLine in
            let newLine = ProductLine(context: viewContext)
            newLine.id = UUID()
            newLine.name = name
            newLine.img = name
            newLine.addToColors(NSSet(array: colors.filter{ color in
                col.contains(color.name!)
            }))
            return newLine
        }
        
        let products = productsListDef.map { (product) -> Product in
            let newProduct = Product(context: viewContext)
            newProduct.id = UUID()
            newProduct.name = product[0]
            newProduct.category = categories.first{ cat in
                cat.name!.contains(product[1])
            }
            newProduct.collection = lines.first{ line in
                line.name!.contains(product[2])
            }
            newProduct.desc =
            """
            Dołożymy wszelkich starań, abyś
            otrzymał/a swój egzemplarz na dzień
            premiery
            Nieopłacone zamówienia będzie
            anulowane po 3 dniach

            Data premiery: 22.10.2021 r.

            Materiał: 100% bawełna
            Gramatura: 180g
            Wyprodukowano: w Polsce

            Cechy produktu:

            Koszulka kolaboracyjna dropu Cartel
            Panda x Patriotic.
            Klasyczną czerń zdobi umieszczony z
            przodu nadruk z pandą w efektownym,
            królewskim image’u.
            Wzór został sporządzony z najwyższą
            starannością, a złote akcenty dodają mu
            szyku.
            Haft “Panda”, nad którym widnieje logo
            Patriotic, stworzony został
            gruboszytymi, złotymi nićmi.
            Koszulka wykonana jest z
            wysokogatunkowej dzianiny.
            Produkt zwieńczony unikalnymi
            metkami, sygnowanymi logo brandu.
            """
            return newProduct
        }
        
        let variants = varianstList.compactMap { (varDef) -> [Variant] in
            let sizes: [String] = varDef[1] as! [String]
            let colos: [String] = varDef[2] as! [String]
            if sizes.count > 0 {
                if colos.count > 0 {
                    return sizes.flatMap { (siz) -> [Variant] in
                        colos.map { (col) -> Variant in
                            let newVariant = Variant(context: viewContext)
                            newVariant.id = UUID()
                            newVariant.product = products.first{ prod in
                                prod.name!.contains(varDef[0] as! String)
                            }
                            newVariant.color = colors.first { c in
                                c.name! == col
                            }
                            newVariant.size = sizeList.first { s in
                                s.value! == siz
                            }
                            newVariant.img = "\(newVariant.product!.name!) \(newVariant.color!.name!)"
                            newVariant.price = Double.random(in: 50...250)
                            newVariant.quantity = Int64.random(in: 0...10)
                            return newVariant
                        }
                    }
                } else {
                    return sizes.map { (siz) -> Variant in
                            let newVariant = Variant(context: viewContext)
                            newVariant.id = UUID()
                            newVariant.product = products.first{ prod in
                                prod.name!.contains(varDef[0] as! String)
                            }
                            newVariant.size = sizeList.first { s in
                                s.value! == siz
                            }
                            newVariant.img = "\(newVariant.product!.name!)"
                            newVariant.price = Double.random(in: 50...250)
                            newVariant.quantity = Int64.random(in: 0...10)
                            return newVariant
                    }
                }
            } else if colos.count > 0 {
                return colos.map { (col) -> Variant in
                    let newVariant = Variant(context: viewContext)
                    newVariant.id = UUID()
                    newVariant.product = products.first{ prod in
                        prod.name!.contains(varDef[0] as! String)
                    }
                    newVariant.color = colors.first { c in
                        c.name! == col
                    }
                    newVariant.img = "\(newVariant.product!.name!) \(newVariant.color!.name!)"
                    newVariant.price = Double.random(in: 50...250)
                    newVariant.quantity = Int64.random(in: 0...10)
                    return newVariant
                }
            } else {
                let newVariant = Variant(context: viewContext)
                newVariant.id = UUID()
                newVariant.product = products.first{ prod in
                    prod.name!.contains(varDef[0] as! String)
                }
                newVariant.img = "\(newVariant.product!.name!)"
                newVariant.price = Double.random(in: 50...250)
                newVariant.quantity = Int64.random(in: 0...10)
                return [newVariant]
            }
        }
        let newUser = User(context: viewContext)
        newUser.email = "example@mail.com"
        newUser.password = "123qwe"
        newUser.cart = Cart(context: viewContext)
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Products")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
