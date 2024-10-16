//
//  WaiterMainPage.swift
//  zephyr
//
//  Created by Sanzhar Shyngysuly on 05.10.2024.
//

import SwiftUI

struct WaiterMainView: View {
    var body: some View {
        TabView{
            NavigationView{
                CreateTableView()
                    .navigationTitle("Создать заказ")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem(){
                Image(systemName: "cart")
                Text("Новый стол")
            }
            NavigationView{
                
            }.tabItem(){
                Image(systemName: "cart")
                Text("Текущие заказы")
            }
            NavigationView{
                
            }.tabItem(){
                Image(systemName: "cart")
                Text("Текущие заказы")
            }
        }
    }
}

#Preview {
    WaiterMainView()
}
