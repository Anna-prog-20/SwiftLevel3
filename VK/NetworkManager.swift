//
//  NetworkManager.swift
//  VK
//
//  Created by Анна on 16.02.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class NetworkManager {
    
    private let baseURL = "https://api.vk.com"
    private let token: String
    private var realm: Realm {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        return try! Realm(configuration: config)
    }
    
    private var baseParams: Parameters {
        [
            "access_token": token,
            "extended": 1,
            "v": "5.130"
        ]
    }
    
    public init(token: String) {
        self.token = token
    }
    
    private func saveData(_ data: [RealmSwift.Object]) {
        do {
            try realm.write {
                realm.add(data, update: .all)
            }
            print(realm.configuration.fileURL)
        } catch  {
            print(error)
        }
    }
    
    public func loadGroups(allGroups: Int = 0, completion: @escaping () -> Void) {
        let path = "/method/groups.get"
        
        let params = baseParams
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { [weak self] response in
            guard let json = response.value.map(JSON.init) else { return }
            let data = try! json["response"]["items"].rawData()
            let dataResult = try! JSONDecoder().decode([Group].self, from: data)
            self?.saveData(dataResult)
            completion()
            
        }
    }
    
    public func loadGroupsByName(searchName: String,  completion: @escaping (Result<[Group], Error>) -> Void) {
        let path = "/method/groups.search"
        
        var params = baseParams
        params["q"] = searchName
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                guard let json = response.value.map(JSON.init) else { return }
                let data = try! json["response"]["items"].rawData()
                let dataResult = try! JSONDecoder().decode([Group].self, from: data)
                completion(.success(dataResult))
            }
        }
    }
    
    public func loadFriends(completion: @escaping () -> Void) {
        let path = "/method/friends.get"
        
        var params = baseParams
        params["fields"] = ["nickname","photo_100"]
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { [weak self] response in
            guard let json = response.value.map(JSON.init) else { return }
            let data = try! json["response"]["items"].rawData()
            let dataResult = try! JSONDecoder().decode([User].self, from: data)
            self?.saveData(dataResult)
            completion()
        }
    }
    
    public func loadFriendsByName(searchName: String, completion: @escaping () -> Void) {
        let path = "/method/friends.search"
        
        var params = baseParams
        params["q"] = searchName
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { [weak self] response in
            guard let json = response.value.map(JSON.init) else { return }
            let data = try! json["response"]["items"].rawData()
            let dataResult = try! JSONDecoder().decode([User].self, from: data)
            self?.saveData(dataResult)
            completion()
            
        }
    }
    
    public func loadPhotos(idFriend: Int,  completion: @escaping () -> Void) {
        let path = "/method/photos.get"
        
        var params = baseParams
        params["owner_id"] = idFriend
        params["album_id"] = "profile"
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { [weak self] response in
            guard let json = response.value.map(JSON.init) else { return }
            let data = try! json["response"]["items"].rawData()
            let dataResult = try! JSONDecoder().decode([Photo].self, from: data)
            self?.saveData(dataResult)
            completion()
        }
    }
    
    public func loadPhotosByAlbum(idFriend: Int, idAlbum: Int,  completion: @escaping () -> Void) {
        let path = "/method/photos.get"
        
        var params = baseParams
        params["owner_id"] = idFriend
        params["count"] = 200
        params["album_id"] = String(idAlbum)
        params["rev"] = 0
        
        if idAlbum != -9000 {
            AF.request(baseURL + path, method: .get, parameters: params).responseData {
                [weak self] response in
                guard let json = response.value.map(JSON.init) else { return }
                let data = try! json["response"]["items"].rawData()
                let dataResult = try! JSONDecoder().decode([Photo].self, from: data)
                self?.saveData(dataResult)
                completion()
            }
        }
    }
    
    public func loadAlbums(idFriend: Int,  completion: @escaping () -> Void) {
        let baseURL = "https://api.vk.com"
        let path = "/method/photos.getAlbums"
        
        var params = baseParams
        params["owner_id"] = idFriend
        params["need_covers"] = 1
        params["need_system"] = 1
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { [weak self] response in
            guard let json = response.value.map(JSON.init) else { return }
            let data = try! json["response"]["items"].rawData()
            let dataResult = try! JSONDecoder().decode([Album].self, from: data)
            self?.saveData(dataResult)
            completion()
        }
    }
}

