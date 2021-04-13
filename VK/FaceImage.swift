import UIKit
@IBDesignable
class FaceImage: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage(width: frame.height - 1, height: frame.height - 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImage(width: frame.height - 1, height: frame.height - 1)
    }
    
    private func setupImage(width: CGFloat, height: CGFloat) {
        
        self.backgroundColor = UIColor.white
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y:0, width: width - 1, height: height - 1))
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        
    }
 
    override func draw(_ rect: CGRect) {
        
    }

}
