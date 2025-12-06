//
//  WasteStore.swift
//  zero_waste_road
//
//  Created by Alexey Meleshin on 12/5/25.
//

import Foundation
import Combine

// MARK: - One waste entry

struct WasteEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let categoryID: Int        // ссылка на ProductCategory.id
    let weightKg: Double       // вес ХРАНИМ в килограммах
    let pricePerKg: Double     // цена за 1 кг

    // вычисляемая категория по id
    var category: ProductCategory {
        ProductCategory.all.first(where: { $0.id == categoryID }) ?? ProductCategory.all[0]
    }

    // итоговая стоимость (используется для диаграмм/статистики)
    var totalPrice: Double {
        weightKg * pricePerKg
    }
}

// MARK: - Store

final class WasteStore: ObservableObject {
    @Published private(set) var entries: [WasteEntry] = []

    private let storageKey = "waste_entries_storage"

    init() {
        loadFromDisk()
    }

    // Добавление новой записи
    func addEntry(category: ProductCategory,
                  weightKg: Double,
                  pricePerKg: Double,
                  date: Date = Date()) {
        let entry = WasteEntry(
            id: UUID(),
            date: date,
            categoryID: category.id,
            weightKg: weightKg,
            pricePerKg: pricePerKg
        )
        entries.append(entry)
        saveToDisk()
    }

    /// Добавление записи БЕЗ сохранения в UserDefaults (используется для mock)
    func addEntryWithoutSaving(_ entry: WasteEntry) {
        entries.append(entry) // не вызываем saveToDisk()
    }

    // MARK: - Aggregation helpers (на будущее)

    /// Все записи за интервал дат
    func entries(from start: Date, to end: Date) -> [WasteEntry] {
        entries.filter { $0.date >= start && $0.date <= end }
    }

    /// Суммарный вес (кг) за период, опционально по категории
    func totalWeightKg(from start: Date, to end: Date, category: ProductCategory? = nil) -> Double {
        entries(from: start, to: end)
            .filter { category == nil || $0.categoryID == category?.id }
            .map { $0.weightKg }
            .reduce(0, +)
    }

    /// Суммарная стоимость за период, опционально по категории
    func totalPrice(from start: Date, to end: Date, category: ProductCategory? = nil) -> Double {
        entries(from: start, to: end)
            .filter { category == nil || $0.categoryID == category?.id }
            .map { $0.totalPrice }
            .reduce(0, +)
    }

    // MARK: - Persistence

    private func saveToDisk() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadFromDisk() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([WasteEntry].self, from: data) {
            self.entries = decoded
        }
    }
}
