//
//  RoomPresentationView.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 30/01/2022.
//

import SwiftUI

struct RoomPresentationView: View {
    var images: [UIImage]
    var products: Dictionary<String, Int>
    var productsPositions: [Int]
    let timer = Timer.publish(every: 0.041, on: .current, in: .common).autoconnect()
    @State var currentImagePos: Int = 0
    @State var play: Play = .Stop
    @State var currentProduct: String?
    @State var isTimmerRunning: Bool = false
    @State var nextPos: Int = 0
    
    init(images: [UIImage], products: Dictionary<String, Int>){
        self.images = images
        self.products = products
        self.productsPositions = products.values.sorted()
    }

    var body: some View {
        VStack(alignment: .center){
                TabView(selection: $currentImagePos){
                    ForEach(0..<images.count){ num in
                        ZStack(alignment: .topLeading){
                            Image(uiImage: images[num])
                                .resizable()
                                .scaledToFit()
                            if let currentProduct = currentProduct {
                                Text(currentProduct)
                                    .padding(10)
                                    .font(.title2)
                                    .background(Color.white)
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                                    .padding()
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .onReceive(timer, perform: { _ in
                    switch play{
                        case .Next:
                            if(currentImagePos == images.count - 1){
                                play = .Stop
                            } else {
                                isTimmerRunning = true
                                currentImagePos = currentImagePos + 1
                                if(currentImagePos == nextPos || currentImagePos == 0){
                                    play = .Stop
                                }
                            }
                        case .Previous:
                            if(currentImagePos == 0){
                                play = .Stop
                            } else {
                                isTimmerRunning = true
                                currentImagePos = currentImagePos - 1
                                if(currentImagePos == nextPos || currentImagePos == 0){
                                    play = .Stop
                                }
                            }
                        case .Stop:
                           isTimmerRunning = false
                    }
                })
            List(){
                ForEach(Array(products.keys), id: \.self){ elem in
                    HStack{
                        Text(elem)
                        Spacer()
                        if let currentProduct = currentProduct {
                            if currentProduct.elementsEqual(elem){
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(Color.green)
                            }
                        }
                    }
                    .font(.headline)
                }
            }
            controls
            Spacer()
        }
    }
    
//    func aniamteToView(pos: Int?){
//        if let pos = pos{
//                direction = pos
//                isTimmerRunning = true;
//        }
//    }
//
//    func navigateToNext(from: String?){
//        if let from = from {
//            let productsList = Array(products.keys)
//            let currentIndex = productsList.firstIndex(of: from)
//            if let currentIndex = currentIndex {
//                if currentIndex == Array(products.values)[productsList.count - 1] {
//                    return
//                }
//                else {
//                    navigateToNext(to: products[productsList[currentIndex+1]]!)
//                }
//            }
//        } else {
//            if currentPos
//        }
//    }
//
//    func navigateToPrevious(from: String){
//        let productsList = Array(products.keys)
//        let currentIndex = productsList.firstIndex(of: from)
//        if let currentIndex = currentIndex {
//            if currentIndex == 0{
//                return
//            }
//            else {
//                navigateToPrevious(to: products[productsList[currentIndex-1]]!)
//            }
//        }
//    }
//
//    func navigateToNext(to: Int){
//
//    }
//
    func navigateToPrevious(to: Int){
        while isTimmerRunning {
            currentImagePos -= 1
            if(currentImagePos == to){
                play = .Stop
            }
        }
    }
//
//    func navigateTo(to: String){
//        if let prodPos = products[to] {
//            if currentImagePos == prodPos{
//                return
//            }
//
//            if(currentImagePos > prodPos){
//                navigateToNext(from: to)
//            }
//            else {
//                navigateToPrevious(from: to)
//            }
//        }
//    }
//
    
    func setNextPos() {
        let keys = Array(products.sorted{
            return $0.value < $1.value
        }.map{$0.key})
        if currentImagePos < products[keys.first!]! {
            let n = products[keys.first!]!
            nextPos = n
            withAnimation{
                currentProduct = keys.first
            }
            return
        }
        else {
            for idx in 1 ..< keys.count {
                let prev = products[keys[idx - 1]]!
                let cur = products[keys[idx]]!
                if currentImagePos >= prev && currentImagePos < cur {
                    withAnimation{
                        currentProduct = keys[idx]
                    }
                    nextPos = products[keys[idx]]!
                    return
                }
            }
        }
        nextPos = images.count - 1
        withAnimation{
            currentProduct = nil
        }
    }
    
    func setPrevPos(){
        let keys = Array(products.sorted{
            return $0.value > $1.value
        }.map{$0.key})
        if currentImagePos > products[keys.first!]! {
            nextPos = products[keys.first!]!
            withAnimation{
                currentProduct = keys.first
            }
            return
        }
        else {
            for idx in 1 ..< keys.count {
                let prev = products[keys[idx - 1]]!
                let cur = products[keys[idx]]!
                if currentImagePos <= prev && currentImagePos > cur {
                    withAnimation{
                        currentProduct = keys[idx]
                    }
                    let n = products[keys[idx]]!
                    nextPos = n
                    return
                }
            }
        }
        nextPos = 0
        withAnimation{
            currentProduct = nil
        }
    }
    
    func navigatePrevious(){
        let keys = Array(products.sorted{
            return $0.value > $1.value
        }.map{$0.key})
        if currentImagePos > products[keys.first!]! {
            navigateToPrevious(to: products[keys.first!]!)
            currentProduct = keys.first
        }
        else {
            for idx in 1 ..< keys.count {
                if currentImagePos < products[keys[idx - 1]]! && currentImagePos >= products[keys[idx]]! {
                  navigateToPrevious(to: products[keys[idx]]!)
                  currentProduct = keys[idx]
                  return
                }
            }
        }
    }
    
    
    var controls: some View {
        HStack{
            Button(action: {
                setPrevPos()
                play = .Previous
            }){
                Image(systemName: "chevron.left")
            }
            .tint(.teal)
            .buttonStyle(BorderedButtonStyle())
            Button(action: {
                if(isTimmerRunning){
                    isTimmerRunning.toggle()
                }
                else{
                    isTimmerRunning.toggle()
                }
                
            }){
                Image(systemName: isTimmerRunning ? "pause" : "play")
            }
            Button(action: {
                setNextPos()
                play = .Next
            }){
                Image(systemName: "chevron.right")
            }
            .tint(.teal)
            .buttonStyle(BorderedButtonStyle())
        }
    }
}


struct RoomPresentationView_Previews: PreviewProvider {
    static var previews: some View {
        let producst = ["TV" : 97, "Shelf": 117 ,"Hanging Cupboard" : 143, "Rack": 184, "Dresser" : 219 ]
        RoomPresentationView(images: createArrayOfImages(), products: producst)
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

enum Play {
    case Previous, Next, Stop
}
