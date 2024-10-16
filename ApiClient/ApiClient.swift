import Foundation

class APIClient {
    
    static let shared = APIClient()
    private init(){}
    
    let api = "http:/localhost:8080"
    
    func login(_ username: String, _ password: String, completion: @escaping (LoginResponse?) -> Void) {
        let url = URL(string: api + "/login")!
        let data = ["username": username, "password": password]
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("HTTP Error: \(httpResponse.statusCode)")
                completion(nil)
                return
            }
            
            guard let responseData = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: responseData)
                completion(loginResponse)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchWaiters(token: String, completion: @escaping ([User]?) -> Void){
        let url = URL(string: api + "/admin/waiters")!
        var req = URLRequest(url : url)
        req.httpMethod = "GET"
        req.setValue("Salemasjdkasjdlas" , forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req){ data, response, error in
            do {
                if data != nil{
                    let waiters = try JSONDecoder().decode([User].self, from: data!)
                    completion(waiters) // Return the decoded response
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func deleteWaiter(token: String, id : Int, completion: @escaping (Bool) -> Void){
        let url = URL(string: api + "/admin/users/\(id)")!
        var req = URLRequest(url : url)
        req.httpMethod = "DELETE"
        req.setValue(token, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req){ data, response, error in
            if error != nil{
                completion(false)
            }else{
                completion(true)
            }
        }.resume()
    }
    
    func addWaiter(username: String, password: String, token: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: api + "/admin/users")!
        var req = URLRequest(url: url)
        
        let data = ["username": username, "password": password, "role": "waiter"]
        print(data)
        
        req.httpMethod = "POST"
        req.setValue(token, forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type") // Указываем тип контента
        req.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(false)
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                print("Failed to add waiter, status code: \(httpResponse.statusCode)")
                completion(false)
            }
        }.resume()
    }
    
    
    
    func fetchFoodCategories(completion: @escaping ([Category]?) -> Void) {
        let url = URL(string: api + "/food")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let foodCategories = try JSONDecoder().decode([Category].self, from: data)
                DispatchQueue.main.async {
                    completion(foodCategories)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func saveScheme(token: String, tables: [Table], completion: @escaping (Bool) -> Void){
        let url = URL(string: api + "/scheme")!
        var req = URLRequest(url: url)
        
        req.httpMethod = "POST"
        req.setValue(token, forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            req.httpBody = try encoder.encode(tables)
            if let jsonBody = String(data: req.httpBody!, encoding: .utf8) {
                print("JSON Body: \(jsonBody)")
            }
        } catch {
            print("Error encoding tables to JSON: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(false)
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                print("Failed to update scheme, status code: \(httpResponse.statusCode)")
                completion(false)
            }
        }.resume()
    }
    
    func fetchScheme(token: String, completion: @escaping ([Table]?) -> Void) {
        let url = URL(string: api + "/scheme")!
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var tables: [Table] = []
                    
                    
                    for jsonObject in jsonArray {
                        if let positionX = jsonObject["positionX"] as? Double,
                           let positionY = jsonObject["positionY"] as? Double,
                           let sizeWidth = jsonObject["sizeWidth"] as? Double,
                           let sizeHeight = jsonObject["sizeHeight"] as? Double,
                           let occupied = jsonObject["occupied"] as? Bool,
                           let number = jsonObject["number"] as? Int {
                            let table = Table(positionX: positionX, positionY: positionY, sizeWidth: sizeWidth, sizeHeight: sizeHeight, number: number, occupied: occupied)
                            tables.append(table)
                        } else {
                            print("Error parsing table object: \(jsonObject)")
                        }
                        
                    }
                    
                    completion(tables)
                } else {
                    print("Failed to cast JSON data to an array")
                    completion(nil)
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    
    
}
