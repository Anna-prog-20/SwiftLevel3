import UIKit

class OnePhotoController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var photo: OnePhoto!
    
    var photoUser: PhotoUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photo.isUserInteractionEnabled = true
        if let idPhoto = photoUser?.presentValueId {
            if let photoArray = photoUser?.arrayValue {
                photo.setPhoto(url: URL(string: photoArray[idPhoto])!)
                photo.photoUser = photoUser!
                photo.setNeedsDisplay()
            }
        }
    }
    
    
}
