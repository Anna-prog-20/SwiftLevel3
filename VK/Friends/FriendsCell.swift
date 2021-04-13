import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet weak var faceImage: FaceImageView!
    @IBOutlet weak var nameFriend: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //print("рисуем нажали")
        // Configure the view for the selected state
    }

}
