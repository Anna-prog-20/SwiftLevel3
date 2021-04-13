import UIKit

class HeaderSection: UITableViewHeaderFooterView {

    @IBOutlet weak var textHeader: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func draw(_ rect: CGRect) {
   }
    
    func setBackgroundColor(color: UIColor, alpha: CGFloat) {
        tintColor = color.withAlphaComponent(alpha)
    }
}
