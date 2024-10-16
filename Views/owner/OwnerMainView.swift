import SwiftUI

struct OwnerMainView: View {
    var body: some View {
        TabView{
            NavigationView{
                OwnerMenuView()
                    .navigationTitle("Меню")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem{
                Image(systemName: "fork.knife")
                Text("Меню")
            }
            NavigationView{
                StatsView()
                    .navigationTitle("Отчеты")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem{
                Image(systemName: "chart.xyaxis.line")
                Text("Отчеты")
            }
            NavigationView{
                StockView()
                    .navigationTitle("Склад")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem{
                Image(systemName: "cart")
                Text("Склад")
            }
        }
    }
}

#Preview {
    OwnerMainView()
}

