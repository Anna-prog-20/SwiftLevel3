import UIKit

class Comments: UIStackView {

    private var buttonComments = UIButton()
    private var lableCountComments = UILabel()
    var countComments = 0
    
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
    
    @objc func buttonCommentsTapped(button: UIButton) {
        print("Тут наверное открывается окно для комментарием")
    }

    private func setupButton(width: CGFloat, height: CGFloat) {
        
        let imageComments = UIImage(named: "imageComments")
        buttonComments.setImage(imageComments, for: .normal)
        
        buttonComments.translatesAutoresizingMaskIntoConstraints = false
        buttonComments.heightAnchor.constraint(equalToConstant: height).isActive = true
        buttonComments.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        buttonComments.addTarget(self, action: #selector(buttonCommentsTapped(button:)), for: .touchUpInside)
        
        addArrangedSubview(buttonComments)
    }
    
    private func setupLable(width: CGFloat, height: CGFloat) {
        
        lableCountComments.textColor = .gray
        
        lableCountComments.translatesAutoresizingMaskIntoConstraints = false
        lableCountComments.heightAnchor.constraint(equalToConstant: height).isActive = true
        lableCountComments.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        lableCountComments.text = "\(countComments)"
        
        addArrangedSubview(lableCountComments)
    }

}
