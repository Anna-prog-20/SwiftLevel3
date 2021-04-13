import UIKit

class OnePhotoController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var photo: OnePhoto!
    
    var photoUser: PhotoUser?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        photo.isUserInteractionEnabled = true
        if let idPhoto = photoUser?.presentValueId {
            if let photoArray = photoUser?.arrayValue {
                photo.setPhoto(named: "\(photoArray[idPhoto])")
                photo.photoUser = photoUser!
            }
        }
        
    }
    

}
