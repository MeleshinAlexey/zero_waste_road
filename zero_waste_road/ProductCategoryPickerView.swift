//
//  ProductCategoryPickerView.swift
//  zero_waste_road
//
//  Created by Alexey Meleshin on 12/5/25.
//

import SwiftUI

// MARK: - Category Picker Sheet

struct ProductCategoryPickerView: View {
    @Binding var selectedCategory: ProductCategory?
    let onClose: () -> Void
    let namespace: Namespace.ID

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // верхняя жёлтая плашка
                HStack {
                    Text("Product categories")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(red: 247/255, green: 205/255, blue: 118/255))
                .matchedGeometryEffect(id: "CategoryHeader", in: namespace)
                .onTapGesture { onClose() }
                

                ZStack {
                    Color(red: 73/255, green: 68/255, blue: 87/255)

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(ProductCategory.all) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: category == selectedCategory
                                ) {
                                    selectedCategory = category
                                    onClose()
                                }
                            }
                        }
                        .padding(12)
                    }
                }
                .frame(maxHeight: 360)
            }
            .cornerRadius(24)
            .padding(.horizontal, 16)
        }
    }
}

struct CategoryButton: View {
    let category: ProductCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Image(category.frameAssetName)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                isSelected
                                ? Color(red: 247/255, green: 205/255, blue: 118/255).opacity(0.6)
                                : Color.clear
                            )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(spacing: 8) {
                    Image(category.itemAssetName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)

                    Text(category.title)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                }
                .padding(6)
            }
            .frame(height: 80)
        }
    }
}
