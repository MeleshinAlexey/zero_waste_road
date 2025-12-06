//
//   ProductCategory.swift
//  zero_waste_road
//
//  Created by Alexey Meleshin on 12/5/25.
//

import SwiftUI

// MARK: - Product Category Model

struct ProductCategory: Identifiable, Equatable {
    let id: Int
    let title: String
    let itemAssetName: String   // product_item1...16
    let frameAssetName: String  // product_frame1...16
}

extension ProductCategory {
    static let all: [ProductCategory] = [
        .init(id: 1,  title: "Bread and baked goods", itemAssetName: "product_item1",  frameAssetName: "product_frame1"),
        .init(id: 2,  title: "Vegetables",            itemAssetName: "product_item2",  frameAssetName: "product_frame2"),
        .init(id: 3,  title: "Fruits",                itemAssetName: "product_item3",  frameAssetName: "product_frame3"),
        .init(id: 4,  title: "Nuts and dried fruits", itemAssetName: "product_item4",  frameAssetName: "product_frame4"),
        .init(id: 5,  title: "Dairy products",        itemAssetName: "product_item5",  frameAssetName: "product_frame5"),
        .init(id: 6,  title: "Eggs",                  itemAssetName: "product_item6",  frameAssetName: "product_frame6"),
        .init(id: 7,  title: "Meat",                  itemAssetName: "product_item7",  frameAssetName: "product_frame7"),
        .init(id: 8,  title: "Sauces and seasonings", itemAssetName: "product_item8",  frameAssetName: "product_frame8"),
        .init(id: 9,  title: "Fish and seafood",      itemAssetName: "product_item9",  frameAssetName: "product_frame9"),
        .init(id: 10, title: "Ready meals/ fast food", itemAssetName: "product_item10", frameAssetName: "product_frame10"),
        .init(id: 11, title: "Cereals and pasta",     itemAssetName: "product_item11", frameAssetName: "product_frame11"),
        .init(id: 12, title: "Frozen foods",          itemAssetName: "product_item12", frameAssetName: "product_frame12"),
        .init(id: 13, title: "Canned goods",          itemAssetName: "product_item13", frameAssetName: "product_frame13"),
        .init(id: 14, title: "Drinks",                itemAssetName: "product_item14", frameAssetName: "product_frame14"),
        .init(id: 15, title: "Greens",                itemAssetName: "product_item15", frameAssetName: "product_frame15"),
        .init(id: 16, title: "Other",                 itemAssetName: "product_item16", frameAssetName: "product_frame16")
    ]
    
    var color: Color {
        switch id {
        case 1: return Color(red: 249/255, green: 221/255, blue: 160/255)
        case 2: return Color(red: 240/255, green: 151/255, blue: 65/255)
        case 3: return Color(red: 238/255, green: 131/255, blue: 130/255)
        case 4: return Color(red: 136/255, green: 93/255, blue: 60/255)
        case 5: return Color(red: 254/255, green: 252/255, blue: 215/255)
        case 6: return Color(red: 244/255, green: 228/255, blue: 191/255)
        case 7: return Color(red: 241/255, green: 160/255, blue: 112/255)
        case 8: return Color(red: 170/255, green: 188/255, blue: 240/255)
        case 9: return Color(red: 171/255, green: 223/255, blue: 252/255)
        case 10: return Color(red: 201/255, green: 74/255, blue: 68/255)
        case 11: return Color(red: 251/255, green: 230/255, blue: 84/255)
        case 12: return Color(red: 202/255, green: 54/255, blue: 202/255)
        case 13: return Color(red: 199/255, green: 244/255, blue: 186/255)
        case 14: return Color(red: 242/255, green: 172/255, blue: 245/255)
        case 15: return Color(red: 137/255, green: 185/255, blue: 71/255)
        case 16: return Color(red: 186/255, green: 252/255, blue: 129/255)
        default: return Color(red: 123/255, green: 125/255, blue: 122/255)
        }
    }
    
    var shortTitle: String {
        switch id {
        case 1:  return "Bread"
        case 2:  return "Veg"
        case 3:  return "Fruit"
        case 4:  return "Nuts"
        case 5:  return "Dairy"
        case 6:  return "Eggs"
        case 7:  return "Meat"
        case 8:  return "Sauces"
        case 9:  return "Fish"
        case 10: return "Fast food"
        case 11: return "Grains"
        case 12: return "Frozen"
        case 13: return "Canned"
        case 14: return "Drinks"
        case 15: return "Greens"
        case 16: return "Other"
        default: return "Other"
        }
    }
}
