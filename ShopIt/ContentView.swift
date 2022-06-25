//
//  ContentView.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 01/12/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "collection.name == 'Street'"),
        animation: .default)
    private var products: FetchedResults<Product>
    @State var isMenuActive: Bool = false
    @State private var draggedOffsey = CGSize.zero
    let productsRoom = ["TV" : 97, "Shelf": 117 ,"Hanging Cupboard" : 143, "Rack": 184, "Dresser" : 219 ]
    
    init(){
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        NavigationView {
            let drag = DragGesture().onEnded{
                if $0.translation.width > 100 {
                    withAnimation{
                        self.isMenuActive = false
                    }
                }
            }
            GeometryReader{ geometry in
                //  Image(systemName: "person.circle")
                ZStack(alignment: .trailing) {
                    TabView{
                        HomeView(products: products)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: self.isMenuActive ? geometry.size.width * -0.5 : 0)
                            .disabled(self.isMenuActive ? true : false)
                            .tabItem{
                                Label("home", systemImage: "house")
                            }
                        AllProducts()
                            .tabItem{
                                Label("products", systemImage: "text.badge.checkmark")
                            }
                        CartView()
                            .tabItem{
                                Label("cart", systemImage: "cart")
                            }
                        RoomPresentationView(images: createArrayOfImages(), products: productsRoom)
                            .tabItem{
                                Label("room", systemImage: "tv.and.mediabox")
                            }
                        
                    }
                    if(self.isMenuActive){
                        MainNav()
                            .frame(width: geometry.size.width * 0.5)
                            .transition(.move(edge: .trailing))
                    }
                }
                .gesture(drag)
            }
            .navigationTitle("ShopIt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation{
                            self.isMenuActive.toggle()
                        }
                    }) {
                        Image(systemName: "person.circle")
                    }
                }
            }
        }
    }
}



struct CollectionsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.name!)],
        animation: .default)
    private var collections: FetchedResults<ProductLine>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 30){
                ForEach(collections){ collection in
                    NavigationLink(
                        destination: {
                            PrdouctLisView(NSPredicate(format: "product.collection == %@", collection))
                                .background(getLinearBackgroundGradient(colorData: collection.colors?.allObjects as! [ColorData]))
                                .navigationTitle(Text(collection.name ?? ""))
                            //                            .toolbar(){
                            //                                Text("Click")
                            //                            }
                        }){
                            CardView(img: collection.img!, title: collection.name!, width: 180, height: 180)
                        }
                }
            }
            .padding()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

private func createArrayOfImages() -> [UIImage]{
    var images: [UIImage] = []
    let basePath = "/Users/jakubwrzesniak/Documents/maya/projects/default/images/myCamera/Pokoj_1_"
    for i in 1...240 {
        let numberOfZeros = 4 - String(i).count
        let zeros: String = {
            var z = ""
            for _ in 1...numberOfZeros {
                z += "0"
            }
            return z
        }()
        let path = "\(basePath)\(zeros)\(i).png"
        print(path)
        let image = UIImage(contentsOfFile: path)
        if let image = image {
            images.append(image)
        }
    }
    print(images.count)
    return images
}
