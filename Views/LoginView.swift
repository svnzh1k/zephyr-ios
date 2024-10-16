//
//  ContentView.swift
//  zephyr
//
//  Created by Sanzhar Shyngysuly on 04.10.2024.


import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var alert = false
    @State private var message = ""
    @State private var success: Bool = false
    @StateObject var loginResponse = LoginResponse(username: "", token: "", role: "")
    
    
    
    
    var body: some View {
        VStack{
            Spacer()
            VStack(spacing: 20){
                Text("Login").font(.largeTitle).offset(y: -60)
                TextField("Username", text: $username)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                SecureField("Password", text: $password)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }.padding(30)
            
            
            Spacer()
            Button(action: {
                if self.username.isEmpty || self.password.isEmpty {
                    self.alert = true
                    self.message = "Username or password is empty"
                }
                
                APIClient.shared.login(self.username, self.password){ response in
                    if response?.token != nil {
                        loginResponse.username = response!.username
                        loginResponse.role = response!.role
                        loginResponse.token = response!.token
                        success = true
                    }else{
                        self.alert = true
                        self.message = "Username or password is incorrect"
                    }
                }
            }) {
                Image(systemName: "arrow.right.circle").font(.title)
                    .frame(width: 120, height: 50)
                    .background(Color.green)
                    .cornerRadius(20)
            }
            Spacer()
            Spacer()
            
            
            
        }.padding()
            .alert(isPresented: $alert){
                Alert(title: Text("Error"), message: Text("\(message)"))
            }
            .fullScreenCover(isPresented: $success){
                if loginResponse.role == "admin" {
                    AdminMainView(loginResponse: loginResponse)
                } else if loginResponse.role == "waiter" {
                    WaiterMainView()
                } else if loginResponse.role == "owner"{
                    OwnerMainView()
                }else{
                    Text("not found")
                }
            }
    }
    
}



#Preview {
    LoginView()
}
