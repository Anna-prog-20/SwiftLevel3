import Foundation

struct News {
    var id: Int
    var user: User!
    var title: String = ""
    var text: String = ""
    var photo: [Photo] = []
}
