//
//  TableSchemeView.swift
//  zephyr
//
//  Created by Sanzhar Shyngysuly on 13.10.2024.
//

import SwiftUI

struct DraggableRectangle: View {
    @Binding var table: Table
    var isDraggable: Bool  // Новый параметр для управления перемещением
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(table.occupied ? Color.red : Color.blue)
                .frame(width: table.sizeWidth, height: table.sizeHeight)
                .position(CGPoint(x: table.positionX, y: table.positionY))
                .gesture(
                    isDraggable ? DragGesture()
                        .onChanged { gesture in
                            table.positionX = gesture.location.x
                            table.positionY = gesture.location.y
                        } : nil
                )
            
            Text("\(table.number)")
                .foregroundColor(.white)
                .font(.headline)
                .bold()
                .position(x: table.positionX, y: table.positionY)
        }
    }
}




struct TableSchemeView: View {
    var loginResponse: LoginResponse
    @State private var tables: [Table] = []
    @State private var showSheet : Bool = false
    @State private var inputWidth: String = ""
    @State private var inputHeight: String = ""
    @State private var inputNumber: String = ""
    @State private var showAlert: Bool = false
    @State private var tableToDelete: Table? = nil
    @State private var textMessage: String = ""
    
    var body: some View {
        VStack(spacing: 0){
            ZStack {
                Spacer()
                ForEach($tables) { $table in
                    DraggableRectangle(table: $table, isDraggable: true)
                        .onLongPressGesture {
                            tableToDelete = table
                            showAlert = true
                        }
                }
            }.background(Color(.green).opacity(0.3))
            HStack{
                Spacer().background(Color(.green).opacity(0.3))
                Text("\(textMessage)")
                Spacer()
            }.background(Color(.green).opacity(0.3))
            HStack{
                Spacer()
                Spacer()
                Button(action:{
                    APIClient.shared.fetchScheme(token: "token"){scheme in
                        if scheme == nil{
                            
                        }else{
                            tables = scheme!
                        }
                    }
                }){
                    Image(systemName: "arrow.2.circlepath").padding(7).background(.green).cornerRadius(30)
                }
                Spacer()
                Spacer()
                Spacer()
                Button(action: {
                    showSheet = true
                }){
                    Image(systemName: "plus.circle.fill").padding(7).background(.green).cornerRadius(30)
                }
                Spacer()
                Spacer()
                Button(action: {
                    APIClient.shared.saveScheme(token: "token", tables: tables){ added in
                        if added{
                            textMessage = "Сохранено"
                        }else{
                            textMessage = "Ошибка, проверьте номера столов на уникальность"
                        }
                    }
                }){
                    Text("Сохранить").padding(7).background(.green).cornerRadius(30)
                }
                Spacer()
            }.background(Color(.yellow).opacity(0.3))
        }.padding(.bottom)
            .sheet(isPresented: $showSheet){
                VStack{
                    TextField("Ширина", text: $inputWidth)
                        .keyboardType(.numberPad)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    TextField("Высота", text: $inputHeight)
                        .keyboardType(.numberPad)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    TextField("Номер стола", text: $inputNumber)
                        .keyboardType(.numberPad)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                    
                        .cornerRadius(10)
                    Button(action:{
                        if let width = Double(inputWidth), let height = Double(inputHeight), let number = Int(inputNumber) {
                            tables.append(Table(positionX: 100, positionY: 100, sizeWidth: width, sizeHeight: height, number: number, occupied: false))
                            showSheet = false
                        }
                    }){
                        Text("Добавить стол")
                        
                    }.padding().background(Color.green).cornerRadius(30).padding()
                }.padding()
            }.alert(isPresented: $showAlert){
                Alert(
                    title: Text("Удаление стола"),
                    message: Text("Вы уверены что хотите удалить данный стол?"),
                    primaryButton: .destructive(Text("Удалить")) {
                        if let table = tableToDelete, let index = tables.firstIndex(where: { $0.id == table.id }) {
                            tables.remove(at: index)
                        }
                    },
                    secondaryButton: .cancel()
                )
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
    TableSchemeView(loginResponse: LoginResponse(username: "Adlet", token: "123", role: "Boss"))
}
