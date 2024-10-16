//
//  Models.swift
//  zephyr
//
//  Created by Sanzhar Shyngysuly on 05.10.2024.
//

import SwiftUI

class LoginResponse: Codable, ObservableObject {
    var token : String = ""
    var username : String = ""
    var role : String = ""
    
    init(username : String, token: String, role: String){
        self.username = username
        self.token = token
        self.role = role
    }
}


class User: Codable, Identifiable, ObservableObject {
    var id: Int64 = 0
    var username: String
    var role: String = "waiter"
    
    init(username: String, role: String) {
        self.username = username
        self.role = role
    }
    
    convenience init (username: String){
        self.init(username: username, role: "waiter")
    }
}

struct Food: Identifiable, Decodable {
    let id: Int
    let category_id: Int
    let name: String
    let price: Int
    let max_quantity: Int
}

struct Category: Identifiable, Decodable {
    let id: Int
    var name: String
    var parent_id: Int?
    var children: [Category]?
    var foods: [Food]?
}


struct Table: Identifiable, Codable {
    var id = UUID()
    var positionX: Double = 100
    var positionY: Double = 100
    var sizeWidth: Double = 50
    var sizeHeight: Double = 50
    var number : Int
    var occupied: Bool
    
    init(positionX: Double, positionY: Double, sizeWidth: Double, sizeHeight: Double, number: Int, occupied: Bool) {
        self.positionX = positionX
        self.positionY = positionY
        self.sizeWidth = sizeWidth
        self.sizeHeight = sizeHeight
        self.number = number
        self.occupied = occupied
    }
}
