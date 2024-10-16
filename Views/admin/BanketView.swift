//
//  BanketView.swift
//  zephyr
//
//  Created by Sanzhar Shyngysuly on 12.10.2024.
//

import SwiftUI

struct BanketView: View {
    var loginResponse: LoginResponse
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    BanketView(loginResponse: LoginResponse(username: "Adlet", token: "123", role: "Boss"))
}
