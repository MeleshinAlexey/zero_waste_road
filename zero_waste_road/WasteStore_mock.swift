//
//  WasteStore+Mock.swift
//  zero_waste_road
//
//  Created by Alexey Meleshin on 12/5/25.
//

import Foundation

extension WasteStore {
    /// Моковый store с заранее забитыми данными для диаграмм/превью
    static let mock: WasteStore = {
        let store = WasteStore()
        let calendar = Calendar.current
        let now = Date()

        func add(daysAgo: Int,
                 categoryIndex: Int,
                 weightKg: Double,
                 pricePerKg: Double) {
            guard ProductCategory.all.indices.contains(categoryIndex) else { return }
            let category = ProductCategory.all[categoryIndex]
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: now) ?? now

            // добавляем запись через специальный метод без сохранения в UserDefaults
            let entry = WasteEntry(
                id: UUID(),
                date: date,
                categoryID: category.id,
                weightKg: weightKg,
                pricePerKg: pricePerKg
            )
            store.addEntryWithoutSaving(entry)
        }
        
        // Последняя неделя (0–6 дней назад)
        add(daysAgo: 0, categoryIndex: 0, weightKg: 0.35, pricePerKg: 3.5)   // Bread and baked goods
        add(daysAgo: 0, categoryIndex: 1, weightKg: 0.50, pricePerKg: 2.0)   // Vegetables
        add(daysAgo: 2, categoryIndex: 2, weightKg: 0.25, pricePerKg: 4.0)   // Fruits
        add(daysAgo: 3, categoryIndex: 3, weightKg: 0.10, pricePerKg: 6.0)   // Nuts and dried fruits
        add(daysAgo: 5, categoryIndex: 4, weightKg: 0.70, pricePerKg: 5.2)   // Dairy products

        // Последний месяц (7–30 дней назад, не учитывая уже добавленную неделю)
        add(daysAgo: 10, categoryIndex: 5, weightKg: 0.20, pricePerKg: 3.0)  // Eggs
        add(daysAgo: 14, categoryIndex: 6, weightKg: 0.60, pricePerKg: 7.5)  // Meat
        add(daysAgo: 18, categoryIndex: 7, weightKg: 0.30, pricePerKg: 2.8)  // Sauces and seasonings
        add(daysAgo: 22, categoryIndex: 8, weightKg: 0.40, pricePerKg: 9.0)  // Fish and seafood
        add(daysAgo: 27, categoryIndex: 9, weightKg: 0.80, pricePerKg: 8.5)  // Ready meals/fast food

        // Остальной год (старше 30 дней назад) — попадут только в годовую статистику
        add(daysAgo: 40,  categoryIndex: 10, weightKg: 1.00, pricePerKg: 2.5) // Cereals and pasta
        add(daysAgo: 70,  categoryIndex: 11, weightKg: 0.45, pricePerKg: 6.5) // Frozen foods
        add(daysAgo: 120, categoryIndex: 12, weightKg: 0.55, pricePerKg: 3.3) // Canned goods
        add(daysAgo: 200, categoryIndex: 13, weightKg: 0.30, pricePerKg: 4.2) // Drinks
        add(daysAgo: 280, categoryIndex: 14, weightKg: 0.65, pricePerKg: 1.9) // Greens
        add(daysAgo: 330, categoryIndex: 15, weightKg: 0.25, pricePerKg: 10.0) // Other

        return store
    }()
}
