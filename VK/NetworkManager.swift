//
//  NetworkManager.swift
//  VK
//
//  Created by Анна on 16.02.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    private let baseURL = "https://api.vk.com"
    private let token: String
    
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
    
    public func loadGroups(allGroups: Int = 0, completion: @escaping (Result<[Group], Error>) -> Void) {
        let path = "/method/groups.get"
        
        let params = baseParams
        
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
    
    public func loadFriends(completion: @escaping (Result<[User], Error>) -> Void) {
        let path = "/method/friends.get"
        
        var params = baseParams
        params["fields"] = ["nickname","photo_100"]
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                guard let json = response.value.map(JSON.init) else { return }
                let data = try! json["response"]["items"].rawData()
                let dataResult = try! JSONDecoder().decode([User].self, from: data)
                completion(.success(dataResult))
            }
        }
    }
    
    public func loadFriendsByName(searchName: String, completion: @escaping (Result<[User], Error>) -> Void) {
        let path = "/method/friends.search"
        
        var params = baseParams
        params["q"] = searchName
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                guard let json = response.value.map(JSON.init) else { return }
                let data = try! json["response"]["items"].rawData()
                let dataResult = try! JSONDecoder().decode([User].self, from: data)
                completion(.success(dataResult))
            }
        }
    }
    
    public func loadUsersByName(searchName: String, completion: @escaping (Result<[User], Error>) -> Void) {
        let path = "/method/users.search"
        
        var params = baseParams
        params["q"] = searchName
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                guard let json = response.value.map(JSON.init) else { return }
                let data = try! json["response"]["items"].rawData()
                let dataResult = try! JSONDecoder().decode([User].self, from: data)
                completion(.success(dataResult))
            }
        }
    }
    
    public func loadPhotos(idFriend: Int,  completion: @escaping (Result<[Photo], Error>) -> Void) {
        let path = "/method/photos.get"
        
        var params = baseParams
        params["owner_id"] = idFriend
        params["album_id"] = "profile"
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                guard let json = response.value.map(JSON.init) else { return }
                let data = try! json["response"]["items"].rawData()
                let dataResult = try! JSONDecoder().decode([Photo].self, from: data)
                completion(.success(dataResult))
            }
            
        }
    }
    
    public func loadAllPhotos(idFriend: Int,  completion: @escaping (Result<[Photo], Error>) -> Void) {
        let path = "/method/photos.getAll"
        
        var params = baseParams
        params["owner_id"] = idFriend
        params["no_service_albums"] = 1
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                guard let json = response.value.map(JSON.init) else { return }
                let data = try! json["response"]["items"].rawData()
                let dataResult = try! JSONDecoder().decode([Photo].self, from: data)
                completion(.success(dataResult))
            }
            
        }
    }
    
    public func loadPhotosByAlbum(idFriend: Int, idAlbum: Int,  completion: @escaping (Result<[Photo], Error>) -> Void) {
        let path = "/method/photos.get"
        
        var params = baseParams
        params["owner_id"] = idFriend
        params["album_id"] = idAlbum
        params["no_service_albums"] = 1
        
        if idAlbum != -9000 {
            AF.request(baseURL + path, method: .get, parameters: params).responseData { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(error))
                case .success( _):
                    guard let json = response.value.map(JSON.init) else { return }
                    let data = try! json["response"]["items"].rawData()
                    let dataResult = try! JSONDecoder().decode([Photo].self, from: data)
                    completion(.success(dataResult))
                }
                
            }
        }
    }
    
    public func loadAlbums(idFriend: Int,  completion: @escaping (Result<[Album], Error>) -> Void) {
        let path = "/method/photos.getAlbums"
        
        var params = baseParams
        params["owner_id"] = idFriend
        params["need_covers"] = 1
        params["need_system"] = 1
        
        AF.request(baseURL + path, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                guard let json = response.value.map(JSON.init) else { return }
                let data = try! json["response"]["items"].rawData()
                let dataResult = try! JSONDecoder().decode([Album].self, from: data)
                completion(.success(dataResult))
            }
            
        }
    }
}

