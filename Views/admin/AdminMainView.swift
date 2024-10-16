import SwiftUI

struct AdminMainView: View {
    var loginResponse: LoginResponse
    @State var waiters: [User] = []
    @State var showRegisterView: Bool = false

    var body: some View {
        TabView {
            NavigationView {
                TableSchemeView(loginResponse: loginResponse)
                    .navigationTitle("Схема зала")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "rectangle.3.offgrid")
                Text("Схема зала")
            }

            NavigationView {
                BanketView(loginResponse: loginResponse)
                    .navigationTitle("Банкеты")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Банкеты")
            }

            NavigationView {
                VStack {
                    List {
                        ForEach(waiters) { waiter in
                            Text("\(waiter.username) - \(waiter.id)")
                        }
                        .onDelete(perform: deleteWaiter)
                    }
                    .navigationTitle("Официанты")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: Button(action: {
                        showRegisterView = true
                    }) {
                        Image(systemName: "plus")
                    })
                    
                    NavigationLink(destination: RegisterView(loginResponse: loginResponse, waiters: $waiters), isActive: $showRegisterView) {
                        EmptyView()
                    }
                }
            }
            .tabItem {
                Image(systemName: "person.3")
                Text("Официанты")
            }
        }
        .onAppear {
            APIClient.shared.fetchWaiters(token: loginResponse.token) { users in
                if let users = users {
                    waiters = users
                    print(waiters)
                }
            }
        }
    }

    func deleteWaiter(at offsets: IndexSet) {
        for index in offsets {
            let waiterToDelete = waiters[index]
            APIClient.shared.deleteWaiter(token: loginResponse.token, id: Int(waiterToDelete.id)) { success in
                if success {
                    waiters.remove(at: index)
                } else {
                    print("Failed to delete waiter with ID: \(waiterToDelete.id)")
                }
            }
        }
    }
}

#Preview {
    AdminMainView(loginResponse: LoginResponse(username: "Adlet", token: "123", role: "Boss"))
}

