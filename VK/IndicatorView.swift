import UIKit

class IndicatorView: UIView {

    private var indicator: Indicator
    
    override init(frame: CGRect) {
        self.indicator = Indicator(frame: frame)
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        self.indicator = Indicator(coder: aDecoder)
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(indicator)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
