//
//  NetworkManager.swift
//  VK
//
//  Created by Анна on 16.02.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private static let sessionAF: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        let session = Alamofire.Session(configuration: configuration)
        
        return session
    }()
    
    
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    static func loadGroups(token: String) {
        let baseURL = "https://api.vk.com"
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkManager.sessionAF.request(baseURL + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print("Groups")
            print(json)
        }
    }
    
    static func loadGroupsByName(token: String, searchName: String) {
        let baseURL = "https://api.vk.com"
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "q": searchName,
            "v": "5.92"
        ]
        
        NetworkManager.sessionAF.request(baseURL + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print("Groups by name")
            print(json)
        }
    }
    
    static func loadFriends(token: String) {
        let baseURL = "https://api.vk.com"
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkManager.sessionAF.request(baseURL + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print("Friends")
            print(json)
        }
    }
    
    static func loadFriendsByName(token: String, searchName: String) {
        let baseURL = "https://api.vk.com"
        let path = "/method/friends.search"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "q": searchName,
            "v": "5.92"
        ]
        
        NetworkManager.sessionAF.request(baseURL + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print("Friends by name")
            print(json)
        }
    }
    
    static func loadUsersByName(token: String, searchName: String) {
        let baseURL = "https://api.vk.com"
        let path = "/method/users.search"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "q": searchName,
            "v": "5.92"
        ]
        
        NetworkManager.sessionAF.request(baseURL + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print("Users by name")
            print(json)
        }
    }
    
    static func loadPhotos(token: String, idFriend: Int) {
        let baseURL = "https://api.vk.com"
        let path = "/method/photos.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "owner_id": idFriend,
            "album_id": "profile",
            "v": "5.92"
        ]
        
        NetworkManager.sessionAF.request(baseURL + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print("Photos")
            print(json)
        }
    }
}
