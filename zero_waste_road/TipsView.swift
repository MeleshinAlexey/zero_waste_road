//
//  TipsView.swift
//  zero_waste_road
//
//  Created by Alexey Meleshin on 12/5/25.
//

import SwiftUI

// MARK: - Model

struct TipItem: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let text: String
}

// MARK: - Static data

let tipsData: [TipItem] = [
    TipItem(
        iconName: "tips_item1",
        title: "Store Herbs Like Flowers",
        text: "Trim stems of parsley, cilantro, or basil, place in a glass of water (like a bouquet), and loosely cover with a plastic bag. Keep on the counter (except basil) or in the fridge. This can double their life."
    ),
    TipItem(
        iconName: "tips_item2",
        title: "Keep Potatoes And Onions Separate",
        text: "Store in cool, dark, dry places—but never together. Onions emit gases that cause potatoes to sprout faster. Use breathable baskets or paper bags, not plastic."
    ),
    TipItem(
        iconName: "tips_item3",
        title: "Freeze Ripe Bananas",
        text: "Peel and slice overripe bananas, then freeze in a sealed bag. Perfect for smoothies, oatmeal, or banana bread—prevents browning and waste."
    ),
    TipItem(
        iconName: "tips_item4",
        title: "Revive Wilted Greens",
        text: "Soak limp lettuce, kale, or spinach in ice-cold water for 10–15 minutes. They’ll crisp right up! Pat dry and store with a dry paper towel in an airtight container."
    ),
    TipItem(
        iconName: "tips_item5",
        title: "Store Bread In The Freezer",
        text: "Bread stales fastest at room temperature. Slice before freezing, then toast directly from frozen. Avoid the fridge—it dries bread out faster."
    ),
    TipItem(
        iconName: "tips_item6",
        title: "Use The “First In, First Out” Rule",
        text: "When unpacking groceries, move older items to the front of the fridge/pantry and new ones to the back. This ensures nothing gets forgotten and spoiled."
    ),
    TipItem(
        iconName: "tips_item7",
        title: "Store Mushrooms In Paper Bags",
        text: "Plastic traps moisture and speeds up sliminess. A paper bag absorbs excess humidity and keeps mushrooms fresh 3–5 days longer."
    ),
    TipItem(
        iconName: "tips_item8",
        title: "Keep Tomatoes Out Of The Fridge",
        text: "Cold temperatures destroy their flavor and texture. Store tomatoes on the counter, stem-side down, and use within 1–2 days after fully ripening."
    ),
    TipItem(
        iconName: "tips_item9",
        title: "Preserve Citrus Zest Before Juicing",
        text: "Before squeezing lemons or oranges, grate the zest and freeze it in small portions. It adds bright flavor to dishes long after the fruit is gone."
    ),
    TipItem(
        iconName: "tips_item1",
        title: "Blanch And Freeze Vegetables",
        text: "Carrots, broccoli, green beans, and peas last months when blanched (briefly boiled, then ice-bathed) and frozen. Stops enzyme activity that causes spoilage."
    ),
    TipItem(
        iconName: "tips_item2",
        title: "Store Cheese Properly",
        text: "Wrap hard cheeses in parchment or wax paper, then place in a loose plastic bag. This prevents drying while allowing them to breathe."
    ),
    TipItem(
        iconName: "tips_item3",
        title: "Use Overripe Fruit Creatively",
        text: "Spotty bananas, soft berries, or mealy apples are great for smoothies, baking, compotes, or sauces. “Ugly” fruit is still nutritious and tasty."
    ),
    TipItem(
        iconName: "tips_item4",
        title: "Keep Celery Upright In Water",
        text: "Stand stalks in a jar with a little water, like cut flowers. Cover loosely with a bag and refrigerate. This keeps them crisp for up to two weeks."
    ),
    TipItem(
        iconName: "tips_item5",
        title: "Store Nuts And Seeds In The Freezer",
        text: "Their oils go rancid quickly at room temperature. Freezing preserves freshness and flavor for months without affecting texture."
    ),
    TipItem(
        iconName: "tips_item6",
        title: "Make “Clean-Out-The-Fridge” Meals",
        text: "Once a week, use leftover veggies, herbs, and cooked grains to make a quick soup, stir-fry, or frittata. Reduces waste and sparks creativity."
    ),
    TipItem(
        iconName: "tips_item7",
        title: "Don’t Wash Berries Until Ready To Eat",
        text: "Moisture speeds up mold. Store unwashed berries in a breathable container and rinse only just before eating."
    ),
    TipItem(
        iconName: "tips_item8",
        title: "Store Eggs In Their Original Carton",
        text: "The carton protects them from absorbing strong fridge odors and helps track expiration dates. Don’t store eggs on the door—it’s too warm."
    ),
    TipItem(
        iconName: "tips_item9",
        title: "Plan “Leftover Nights” Weekly",
        text: "Designate one dinner per week to eat leftovers. Label containers with dates and store them front and center so they’re seen and used."
    )
]

// MARK: - Views

struct TipsView: View {
    var body: some View {
        ZStack {
            Image("main_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(tipsData) { tip in
                        TipRow(tip: tip)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 90)
                .padding(.bottom, 90)
            }
        }
    }
}

struct TipRow: View {
    let tip: TipItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Spacer()
            Image(tip.iconName)
                
            VStack(alignment: .leading, spacing: 4) {
                Text(tip.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 5/255, green: 92/255, blue: 168/255))

                Text(tip.text)
                    .font(.system(size: 13))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(10)
        .background(Color.white.opacity(0.95))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview

#Preview {
    TipsView()
}
