//
//  Session.swift
//  VK
//
//  Created by Анна on 09.02.2021.
//

import Foundation

class Session {
    static let inctance = Session()
    
    private init() {
        
    }
    
    var token: String = ""
    var userId: Int = 0
    
    func loginWithServer(token: String, userId: Int) {
        self.token = token
        self.userId = userId
        print("Токен: \(token) Пользователь с id \(userId) вошел в приложение успешно")
    }
    
    func getData() {
        print("Получаем данные - Токен: \(token) Пользователь с id \(userId) вошел в приложение успешно")
    }
    
}
