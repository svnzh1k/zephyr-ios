//
//  RegisterView.swift
//  zephyr
//
//  Created by Sanzhar Shyngysuly on 15.10.2024.
//

import SwiftUI

struct RegisterView: View {
    @State var username: String = ""
    @State var password: String = ""
    var loginResponse: LoginResponse
    @Binding var waiters: [User]
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 30){
            Spacer()
            Text("Добавить нового официанта").font(.title2).frame(width: 400)
            Spacer()
            TextField("Username", text: $username)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            TextField("Password", text: $password)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: { addWaiter() }) {
                Text("Добавить")
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Ошибка"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            Spacer()
            Spacer()
            Spacer()
        }
        .padding(40)
    }

    func addWaiter() {
        print("Attempting to add waiter: \(username)")
        APIClient.shared.addWaiter(username: username, password: password, token: loginResponse.token) { added in
            print("Add waiter response: \(added)")
            DispatchQueue.main.async {
                if added {
                    APIClient.shared.fetchWaiters(token: loginResponse.token) { users in
                        if let users = users {
                            waiters = users
                            print(waiters)
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                    print("Waiter added successfully.")
                } else {
                    errorMessage = "Не удалось добавить официанта"
                    showAlert = true
                    print("Failed to add waiter.")
                }
            }
        }
    }

}

#Preview {
    RegisterView(
        loginResponse: LoginResponse(username: "Adlet", token: "123", role: "Boss"),
        waiters: .constant([User(username: "Waiter1"), User(username: "Waiter2")])
    )
}

