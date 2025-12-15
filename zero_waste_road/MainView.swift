//
//  MainView.swift
//  zero_waste_road
//
//  Created by Alexey Meleshin on 12/5/25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @StateObject private var wasteStore = WasteStore()

    var body: some View {
        TabView(selection: $selectedTab) {
            StatisticView()
                .environmentObject(WasteStore.mock)
                .tabItem {
                    Image("statistic_item")

                    Text("Statistic")
                }
                .tag(0)

            NavigationStack {
                MainScreenView()
            }
            .tabItem {
                Image("main_item")
                    .renderingMode(.template)
                    .foregroundColor(selectedTab == 1
                                ? Color(red: 101/255, green: 196/255, blue: 102/255)
                                : .gray)
            }
            .tag(1)

            TipsView()
                .tabItem {
                    Image("tips_item")
 
                    Text("Tips")
                }
                .tag(2)
        }
        .onAppear {
            selectedTab = 1
        }
        .environmentObject(wasteStore)
    }
}

struct MainScreenView: View {
    @EnvironmentObject private var wasteStore: WasteStore

    // Записи только за сегодня
    private var todayEntries: [WasteEntry] {
        let calendar = Calendar.current
        return wasteStore.entries.filter { calendar.isDateInToday($0.date) }
    }

    // Общий вес (кг) за сегодня
    private var totalWeightToday: Double {
        todayEntries.map { $0.weightKg }.reduce(0, +)
    }

    // Общая стоимость за сегодня
    private var totalPriceToday: Double {
        todayEntries.map { $0.totalPrice }.reduce(0, +)
    }

    var body: some View {
        ZStack {
            
            Image("main_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                
                Image("main_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .padding(.top, 40)

                
                VStack(spacing: 4) {
                    Text("THROWN AWAY")
                        .foregroundColor(.red)
                        .font(.system(size: 32, weight: .bold))

                    Text("TODAY")
                        .foregroundColor(.red)
                        .font(.system(size: 32, weight: .bold))
                }
                .padding(.top, 8)

                HStack(spacing: 20) {
                    StatBoxView(
                        icon: "trash_item",
                        value: String(format: "%.1f", totalWeightToday),
                        unit: "kg"
                    )

                    StatBoxView(
                        icon: "coin_item",
                        value: String(format: "%.2f", totalPriceToday),
                        unit: "$"
                    )
                }
                .padding(.top, 10)

                Spacer()

                // Add waste button
                NavigationLink {
                    AddWasteView()
                } label: {
                    ZStack {
                        Image("add_button")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .clipShape(Capsule())

                        Text("+ Add waste")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 140)
            }
        }
    }
}

// MARK: - Stat Box Component
struct StatBoxView: View {
    let icon: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 6) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40)

            Text(value)
                .foregroundColor(.red)
                .font(.system(size: 28, weight: .bold))

            Text(unit)
                .foregroundColor(.gray)
                .font(.system(size: 16))
        }
        .frame(width: 140, height: 120)
        .background(Color.white.opacity(1))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow.opacity(0.8), lineWidth: 7)
        )
        .cornerRadius(12)
    }
}

#Preview {
    MainView()
}
