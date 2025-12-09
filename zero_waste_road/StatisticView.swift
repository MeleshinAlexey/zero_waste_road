//
//  StatisticView.swift
//  zero_waste_road
//
//  Created by Alexey Meleshin on 12/5/25.
//

import SwiftUI

// MARK: - Period selector

enum StatsPeriod: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case year = "Year"

    var id: Self { self }
}

// MARK: - Slice model for chart

struct CategorySlice: Identifiable {
    let id = UUID()
    let category: ProductCategory
    let value: Double
}

// MARK: - Main Statistic View

struct StatisticView: View {
    @EnvironmentObject var wasteStore: WasteStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPeriod: StatsPeriod = .week

    // MARK: - Date ranges

    private var dateRange: (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()

        switch selectedPeriod {
        case .week:
            let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) ?? now
            return (start, now)
        case .month:
            let start = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return (start, now)
        case .year:
            let start = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return (start, now)
        }
    }

    private var entriesInRange: [WasteEntry] {
        wasteStore.entries(from: dateRange.start, to: dateRange.end)
    }

    private var slices: [CategorySlice] {
        var dict: [Int: Double] = [:]   // categoryID : totalKg

        for entry in entriesInRange {
            dict[entry.categoryID, default: 0] += entry.weightKg
        }

        return dict.compactMap { (id, value) in
            guard let category = ProductCategory.all.first(where: { $0.id == id }),
                  value > 0
            else { return nil }
            return CategorySlice(category: category, value: value)
        }
        .sorted { $0.value > $1.value }
    }

    private var totalWeightKg: Double {
        slices.map { $0.value }.reduce(0, +)
    }

    private var totalPrice: Double {
        entriesInRange.map { $0.totalPrice }.reduce(0, +)
    }

    var body: some View {
        ZStack {
            Image("main_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 10) {
                Spacer()
                // Переключатель Week / Month / Year
                periodSelector

                // Карточка с диаграммой
                chartCard

                // Две карточки: Total thrown away / Lost
                totalsRow

                Spacer()
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private var periodSelector: some View {
        HStack(spacing: 16) {
            ForEach(StatsPeriod.allCases) { period in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedPeriod = period
                    }
                } label: {
                    Text(period.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            selectedPeriod == period
                            ? Color(red: 247/255, green: 153/255, blue: 60/255)
                            : Color.clear
                        )
                        .foregroundColor(
                            selectedPeriod == period ? .white : Color(red: 247/255, green: 153/255, blue: 60/255)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 247/255, green: 153/255, blue: 60/255), lineWidth: 2)
                        )
                        .cornerRadius(10)
                }
//                .padding()
            }
        }
    }


    private var chartCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)

            if totalWeightKg <= 0 {
                Text("No data for selected period")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                DonutChartView(slices: slices)
            }
        }
        .frame(height: 360)
    }
    
    private var totalsRow: some View {
        HStack(spacing: 16) {
            totalCard(
                iconName: "trash_item",
                title: "Total thrown away",
                valueText: String(format: "%.1f", totalWeightKg),
                unitText: "kg"
            )

            totalCard(
                iconName: "coin_item",
                title: "Lost",
                valueText: String(format: "%.2f", totalPrice),
                unitText: "$"
            )
        }
        
    }

    private func totalCard(iconName: String,
                           title: String,
                           valueText: String,
                           unitText: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 252/255, green: 255/255, blue: 224/255),
                            Color(red: 238/255, green: 255/255, blue: 215/255)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack(spacing: 8) {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)

                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)

                Text(valueText)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(red: 244/255, green: 93/255, blue: 80/255))

                Text(unitText)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(16)
        }
        .frame(height: 170)
    }
}

// MARK: - Donut chart

struct DonutChartView: View {
    let slices: [CategorySlice]

    // для каждого сегмента храним: сам slice + углы
    private var segments: [(slice: CategorySlice, start: Angle, end: Angle)] {
        var result: [(CategorySlice, Angle, Angle)] = []
        let total = slices.map { $0.value }.reduce(0, +)
        guard total > 0 else { return result }

        var currentStart: Double = -90
        for slice in slices {
            let angleDelta = (slice.value / total) * 360
            let start = Angle(degrees: currentStart)
            let end = Angle(degrees: currentStart + angleDelta)
            result.append((slice, start, end))
            currentStart += angleDelta
        }
        return result
    }

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let radius = size / 2
            let thickness: CGFloat = radius * 0.45
            let center = CGPoint(x: size / 2, y: size / 2)
            let labelRadius = radius - thickness / 2   // текст примерно по центру сегмента

            ZStack {
                // Сами цветные сегменты
                ForEach(segments, id: \.slice.id) { segment in
                    DonutSegment(
                        startAngle: segment.start,
                        endAngle: segment.end,
                        thickness: thickness
                    )
                    .fill(segment.slice.category.color)
                }

                // Текст на каждом сегменте — только если сегмент достаточно большой
                ForEach(segments, id: \.slice.id) { segment in
                    let angle = segment.end.degrees - segment.start.degrees

                    // если сегмент меньше 12°, не показываем текст
                    if angle > 12 {
                        let midAngleDegrees = (segment.start.degrees + segment.end.degrees) / 2
                        let midAngle = Angle(degrees: midAngleDegrees)
                        let x = center.x + CGFloat(cos(midAngle.radians)) * labelRadius
                        let y = center.y + CGFloat(sin(midAngle.radians)) * labelRadius

                        Text(segment.slice.category.shortTitle)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: 40)
                            .position(x: x, y: y)
                    }
                }

                // Белый центр
                Circle()
                    .fill(Color.white)
                    .frame(width: radius * 1.0, height: radius * 1.0)

                // Общее значение в центре
                VStack(spacing: 4) {
                    Text(String(format: "%.1f", slices.map { $0.value }.reduce(0, +)))
                        .font(.system(size: 28, weight: .bold))
                    Text("kg")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            .frame(width: size, height: size)
        }
    }
}
struct DonutSegment: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let thickness: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius - thickness
        var path = Path()

        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)

        path.addArc(center: center,
                    radius: innerRadius,
                    startAngle: endAngle,
                    endAngle: startAngle,
                    clockwise: true)

        path.closeSubpath()
        return path
    }
}



// MARK: - Preview (можно подцепить мок)

#Preview {
    StatisticView()
        .environmentObject(WasteStore())   // WasteStore() or WasteStore.mock
        .dynamicTypeSize(.medium)
}
