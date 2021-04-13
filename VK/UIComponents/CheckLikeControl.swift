import UIKit

class CheckLikeControl: UIControl {
    private var checkLike: CheckILike
    
    override init(frame: CGRect) {
        self.checkLike = CheckILike(frame: frame)
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        self.checkLike = CheckILike(coder: aDecoder)
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(checkLike)
    }
    
}
