//
//  CreateTableView.swift
//  zephyr
//
//  Created by Sanzhar Shyngysuly on 12.10.2024.
//

import SwiftUI

struct CreateTableView: View {
    @State private var tables: [Table] = []
    var body: some View {
        VStack{
            ZStack {
                ForEach($tables) { $table in
                    DraggableRectangle(table: $table, isDraggable: false)
                    
                }
            }
            Spacer()
        }.onAppear(){
            APIClient.shared.fetchScheme(token: "token"){scheme in
                if scheme == nil{
                    
                }else{
                    tables = scheme!
                }
            }
        }
    }
}

#Preview {
    CreateTableView()
}
