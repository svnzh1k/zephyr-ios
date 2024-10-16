//
//  OwnerMenuView.swift
//  zephyr
//
//  Created by Sanzhar Shyngysuly on 15.10.2024.
//
//
import SwiftUI


struct CategoryView: View{
    @State var categoriesOptional: [Category]?
    @State var foodOptional: [Food]?
    var parentCategory: Int
    
    var body: some View{
        if let categories = categoriesOptional{
            List(categories){category in
                NavigationLink(destination:
                                CategoryView(categoriesOptional: category.children, foodOptional: category.foods, parentCategory: 0)){
                    Text("\(category.name)")
                }
            }
        }else{
            if let food = foodOptional{
                List(food){food in
                    Text(food.name)
                }
            }
        }
    }
}

struct OwnerMenuView: View {
    @State private var categories: [Category] = []
    @State private var allFood: [Food] = []
    @State private var searchString = ""
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Искать...", text: $searchString)
                }
                
                Section {
                    List(categories) { category in
                        NavigationLink(destination: CategoryView(categoriesOptional: category.children, foodOptional: category.foods, parentCategory: 0)) {
                            Text("\(category.name)")
                        }
                    }
                }
            }
            .navigationTitle("Categories")
        }
        .onAppear() {
            APIClient.shared.fetchFoodCategories { data in
                if let fetchedData = data {
                    categories = fetchedData
                    for category in categories {
                        if let children = category.children {
                            fillFoodArray(children)
                        }
                    }
                }
            }
        }
    }
    
    func fillFoodArray(_ categories: [Category]) {
        for category in categories {
            if let children = category.children, !children.isEmpty {
                fillFoodArray(children)
            } else if let foods = category.foods, !foods.isEmpty {
                allFood.append(contentsOf: foods)
            }
        }
    }
}

#Preview {
    OwnerMenuView()
}





