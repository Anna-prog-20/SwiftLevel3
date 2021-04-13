import UIKit

class ShareControl: UIControl {
    private var share: Share
    
    override init(frame: CGRect) {
        self.share = Share(frame: frame)
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        self.share = Share(coder: aDecoder)
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(share)
    }

    
}
