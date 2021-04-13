import UIKit

class Viewing: UIStackView {

    private var button = UIButton()
    private var lable = UILabel()
    var count = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spacing = 2
        setupButton(width: frame.height, height: frame.height)
        setupLable(width: frame.height, height: frame.height)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        spacing = 2
        setupButton(width: frame.height, height: frame.height)
        setupLable(width: frame.height, height: frame.height)
    }
    
    @objc func buttonTapped(button: UIButton) {
        print("Тут наверное ничего не должно быть :)")
    }

    private func setupButton(width: CGFloat, height: CGFloat) {
        
        let image = UIImage(named: "imageViewing")
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
        
        addArrangedSubview(button)
    }
    
    private func setupLable(width: CGFloat, height: CGFloat) {
        
        lable.textColor = .gray
        
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.heightAnchor.constraint(equalToConstant: height).isActive = true
        lable.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        lable.text = "\(count)"
        
        addArrangedSubview(lable)
    }


}
