import UIKit

class ViewingControl: UIControl {

    private var viewing: Viewing
    
    override init(frame: CGRect) {
        self.viewing = Viewing(frame: frame)
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        self.viewing = Viewing(coder: aDecoder)
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(viewing)
    }


}
