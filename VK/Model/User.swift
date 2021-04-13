import Foundation

struct User {
    var id: Int
    var name: String
    var login: String = ""
    var password: String = ""
    var photo: [Photo] = []
}
