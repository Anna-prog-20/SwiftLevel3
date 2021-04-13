import UIKit

class Indicator: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.spacing = 3
        self.distribution = .fillEqually
        self.axis = .horizontal
        setupDots(width: frame.height, height: frame.height)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        spacing = 3
        self.distribution = .fillEqually
        self.axis = .horizontal
        setupDots(width: frame.height, height: frame.height)
    }

    private func setupDots(width: CGFloat, height: CGFloat) {
        let imageDot = UIImage(named: "dot")
        let tintedImage = imageDot?.withRenderingMode(.alwaysTemplate)

        backgroundColor = UIColor.clear
        var dots: [UIImageView] = []
        var delay = 0.0
        let withDuration = 1.0
        var alphaDot = CGFloat(1)
        let alphaDel = CGFloat(0.5)
        for i in 0...2 {
            dots.append(UIImageView(image: imageDot))
            dots[i].image = tintedImage
            dots[i].tintColor = UIColor.gray
            dots[i].frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
            dots[i].tintColor = UIColor.gray
            dots[i].translatesAutoresizingMaskIntoConstraints = false
            dots[i].heightAnchor.constraint(equalToConstant: height).isActive = true
            dots[i].widthAnchor.constraint(equalToConstant: width).isActive = true
            self.addArrangedSubview(dots[i])
            UIImageView.animate(withDuration: withDuration, delay: delay, options: [.repeat, .autoreverse], animations: {
                            dots[i].alpha = 0
                       })
            delay += withDuration - withDuration/2
            alphaDot -= alphaDel
        }
    }
}
