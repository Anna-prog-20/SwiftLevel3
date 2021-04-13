import UIKit

class CheckILike: UIStackView {

    enum Liked {
        case like
        case dislike
    }
    
    private var buttonLike = UIButton()
    private var lableCountLike = UILabel()
    var liked: Liked = .dislike
    var countLike = 0
    
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
    
    private func changeImageLike (nameImage: String){
        let imageLike = UIImage(named: nameImage)
        buttonLike.setImage(imageLike, for: .normal)
    }
    
    @objc func buttonLikeTapped(button: UIButton) {
        if (liked == .dislike) {
            changeImageLike(nameImage: "imageLike")
            countLike = countLike + 1
            lableCountLike.textColor = .red
            liked = .like
        }
        else {
            changeImageLike(nameImage: "imageNotLike")
            countLike = countLike - 1
            lableCountLike.textColor = .gray
            liked = .dislike
        }
        UIView.transition(with: lableCountLike,
                          duration: 0.25,
                          options: .transitionFlipFromTop,
                          animations: {
                          self.lableCountLike.text = "\(self.countLike)"
        })
    }

    private func setupButton(width: CGFloat, height: CGFloat) {
        
        let imageLike = UIImage(named: "imageNotLike")
        buttonLike.setImage(imageLike, for: .normal)
        
        buttonLike.translatesAutoresizingMaskIntoConstraints = false
        buttonLike.heightAnchor.constraint(equalToConstant: height).isActive = true
        buttonLike.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        buttonLike.addTarget(self, action: #selector(buttonLikeTapped(button:)), for: .touchUpInside)
        
        addArrangedSubview(buttonLike)
    }
    
    private func setupLable(width: CGFloat, height: CGFloat) {
        
        lableCountLike.textColor = .gray
        
        lableCountLike.translatesAutoresizingMaskIntoConstraints = false
        lableCountLike.heightAnchor.constraint(equalToConstant: height).isActive = true
        lableCountLike.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        lableCountLike.text = "\(countLike)"
        
        addArrangedSubview(lableCountLike)
    }
}
