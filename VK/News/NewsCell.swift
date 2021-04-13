import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var faceImage: FaceImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var textNew: UITextView!
    @IBOutlet weak var photoNew: UIImageView!
    @IBOutlet weak var like: CheckLikeControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoNew.translatesAutoresizingMaskIntoConstraints = false
        photoNew.heightAnchor.constraint(equalToConstant: self.frame.width).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
