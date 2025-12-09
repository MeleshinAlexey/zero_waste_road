import SwiftUI

// MARK: - Main Add Waste Screen

struct AddWasteView: View {
    @Namespace private var categoryAnimation
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var wasteStore: WasteStore

    @State private var showCategoryPicker = false

    @State private var selectedCategory: ProductCategory? = nil
    @State private var weightGramsText: String = ""
    @State private var pricePerKgText: String = ""

    // проверяем, что все поля заполнены и числа валидные
    private var isFormValid: Bool {
        selectedCategory != nil &&
        parseLocalizedDouble(weightGramsText) != nil &&
        parseLocalizedDouble(pricePerKgText) != nil &&
        !weightGramsText.isEmpty &&
        !pricePerKgText.isEmpty
    }

    // вес в килограммах (внутреннее использование)
    private var weightKg: Double {
        (parseLocalizedDouble(weightGramsText) ?? 0) / 1000.0
    }
    
    // Парсим число, позволяя запятую и точку как разделитель
    private func parseLocalizedDouble(_ text: String) -> Double? {
        let cleaned = text
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }
    let screenBounds = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            Image("add_waste_background")
                .resizable()
                .scaledToFill()
                .frame(width: screenBounds.width, height: screenBounds.height)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                        // Product categories
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                showCategoryPicker = true
                            }
                        } label: {
                            Group {
                                if showCategoryPicker {
                                   
                                    CategoryFieldView(selectedCategory: selectedCategory)
                                        .opacity(0)
                                } else {
                                    CategoryFieldView(selectedCategory: selectedCategory)
                                        .matchedGeometryEffect(id: "CategoryHeader", in: categoryAnimation)
                                }
                            }
                        }
                        .buttonStyle(.plain)

                        // Weight (g)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Weight (g):")
                                .font(.system(size: 16, weight: .regular))
                            TextField("Text", text: $weightGramsText)
                                .keyboardType(.decimalPad)
                                .padding(.horizontal, 12)
                                .frame(height: 56)
                                .background(Color.gray.opacity(0.6))
                                .cornerRadius(8)
                        }

                        // Price per 1 kg ($)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Price per 1 kg ($):")
                                .font(.system(size: 16, weight: .regular))
                            TextField("Text", text: $pricePerKgText)
                                .keyboardType(.decimalPad)
                                .padding(.horizontal, 12)
                                .frame(height: 56)
                                .background(Color.gray.opacity(0.6))
                                .cornerRadius(8)
                        }

                        // Корзина
                        Image("trash_big")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 260)
                            .padding(.top, 16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                // Save button
                Button(action: save) {
                    Text("Save")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(
                            isFormValid
                            ? Color(red: 247/255, green: 205/255, blue: 118/255)
                            : Color(red: 247/255, green: 205/255, blue: 118/255).opacity(0.4)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .disabled(!isFormValid)
                .padding(.horizontal, 24)
                .padding(.top, 10)
                .padding(.bottom, 60)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            if showCategoryPicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            showCategoryPicker = false
                        }
                    }

                ProductCategoryPickerView(
                    selectedCategory: $selectedCategory,
                    onClose: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            showCategoryPicker = false
                        }
                    },
                    namespace: categoryAnimation
                )
                .transition(.opacity)
            }
        }
        .ignoresSafeArea(.keyboard)
        .hideKeyboardOnTap()
    }
    
    // MARK: - Save

    private func save() {
        guard
            let category = selectedCategory,
            let weightGrams = parseLocalizedDouble(weightGramsText),
            let pricePerKg = parseLocalizedDouble(pricePerKgText)
        else {
            return
        }

        // сохраняем вес в килограммах
        let weightKgValue = weightGrams / 1000.0

        wasteStore.addEntry(
            category: category,
            weightKg: weightKgValue,
            pricePerKg: pricePerKg
        )

        dismiss()
    }
}

// MARK: - Category Field (серое поле на основном экране)

struct CategoryFieldView: View {
    let selectedCategory: ProductCategory?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Product categories")
                .font(.system(size: 16, weight: .regular))
                .padding(.top, 30)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.6))

                HStack {
                    Text(selectedCategory?.title ?? "Product categories")
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                
            }
            .frame(height: 56)
        }
    }
}

// MARK: - Keyboard Dismiss Helper

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}

// MARK: - Preview

#Preview {
    AddWasteView()
        .environmentObject(WasteStore())
        .dynamicTypeSize(.medium)
}
