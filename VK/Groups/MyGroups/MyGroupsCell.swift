import UIKit

class MyGroupsCell: UITableViewCell {

    @IBOutlet weak var faceImage: FaceImageView!
    @IBOutlet weak var nameGroup: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
