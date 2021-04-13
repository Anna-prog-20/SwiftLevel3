import UIKit

class GroupsCell: UITableViewCell {

    @IBOutlet weak var nameGroupGlobal: UILabel!
    
    @IBOutlet weak var faceImage: FaceImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
