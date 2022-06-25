//
//  ProductFunctions.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 13/12/2021.
//

import Foundation
import CoreData
import SwiftUI

func getProductColors(product: Product) -> [ColorData] {
    if let variants = product.variants?.allObjects as? [Variant]{
        let colors = variants.compactMap{$0.color}
        return Array(Set(colors))
    }
    return []
}

func getProductSizes(product: Product) -> [Size] {
    if let variants = product.variants?.allObjects as? [Variant]{
        let filteredVaraiants = variants.filter{ v in
            v.quantity > 0
        }
        let sizeList = filteredVaraiants.compactMap{$0.size}
        return Array(Set(sizeList))
    }
    return []
}

func getAngularBackgroundGradient(colorData: [ColorData]) -> AngularGradient {
    var colors: [Color] = colorData.compactMap{ color in
        if let color = color.color {
            return Color(uiColor: color)
        } else {
            return nil
        }
    }
    if let firstColor: Color = colors.first{
       colors.append(firstColor)
    }
    return AngularGradient(colors: colors, center: .center, startAngle: .zero, endAngle: .degrees(360))
}

func getLinearBackgroundGradient(colorData: [ColorData]) -> LinearGradient {
    var colors: [Color] = colorData.compactMap{ color in
        if let color = color.color {
            return Color(uiColor: color)
        } else {
            return nil
        }
    }
    if let firstColor: Color = colors.first{
       colors.append(firstColor)
    }
    return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
}

func saveImage(image: UIImage, name: String) -> Bool {
    guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
        return false
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return false
    }
    do {
        try data.write(to: directory.appendingPathComponent("\(name).png")!)
        return true
    } catch {
        print(error.localizedDescription)
        return false
    }
}

func getImage(named: String) -> Image {
    if let uiImage = UIImage(named: named) {
        return Image(uiImage: uiImage)
    }
    if let uiImage = UIImage(fromDocuments: named) {
        return Image(uiImage: uiImage)
    } else {
        return Image("DefaultImage")
    }
}
