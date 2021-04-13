import UIKit

class OnePhoto: UIView, UIGestureRecognizerDelegate {
   
    var photoUser: PhotoUser?
    var interactiveAnimator: UIViewPropertyAnimator!
    private var visibleImageView: UIImageView!
    private var invisibleImageView: UIImageView!
    
    private var xBegan:CGFloat = 0
    private var xChenged:CGFloat = 0
    private var xEnded:CGFloat = 0
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        return recognizer
    } ()
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        enum Route {
            case back
            case forth
            case none
        }
        
        let idPhoto = photoUser!.presentValueId
        let location = recognizer.location(in: self)
        var positionX:CGFloat = 0
        
        var route: Route = .none
        switch recognizer.state {
        case .began:
            xBegan = location.x
        case .ended:
            xEnded = location.x
        case .changed:
            xChenged = location.x
        default:
            return
        }
        if (xChenged - xBegan) > 0 {
            positionX = self.frame.origin.x + location.x
        } else if (xChenged - xBegan) < 0 {
            positionX = self.frame.origin.x - location.x
        }
        
        var xEndedForth: CGFloat = xEnded
        
        if (xEnded - xBegan) > 0 {
            positionX = self.frame.origin.x + self.frame.width
            if (xEnded != 0) {
                route = .back
                xEndedForth = xEnded
                xEnded = 0
            }
        } else if (xEndedForth - xBegan) < 0  && xEndedForth != 0 {
            positionX = self.frame.origin.x - self.frame.width
            if (xEnded != 0) {
                route = .forth
                xEnded = 0
            }
        }
        UIView.animate(withDuration: 1, animations: {
        self.visibleImageView.frame = CGRect(x: positionX, y: self.visibleImageView.frame.origin.y, width: self.frame.width, height: self.frame.height)
            if route == .forth {
                if idPhoto  != (self.photoUser!.arrayValue.count) - 1 {
                    self.insertInvisibleImage(idPhoto: idPhoto, index: 1)
                }
                else {
                    route = .none
                    self.visibleImageView.frame = CGRect(x: self.bounds.minX, y: self.visibleImageView.frame.origin.y, width: self.frame.width, height: self.frame.height)
                }
            } else if route == .back {
                        if idPhoto  > 0 {
                            self.insertInvisibleImage(idPhoto: idPhoto, index: -1)
                        }
                        else {
                            route = .none
                            self.visibleImageView.frame = CGRect(x: self.bounds.minX, y: self.visibleImageView.frame.origin.y, width: self.frame.width, height: self.frame.height)
                        }
            }
        }, completion: {[weak self] _ in
            guard let self = self else {return}
            if route != .none {
                if idPhoto  != (self.photoUser!.arrayValue.count) - 1 || idPhoto  > 0 {
                    let interView = self.invisibleImageView
                    self.invisibleImageView = self.visibleImageView
                    self.visibleImageView = interView
                    self.invisibleImageView.center.x = self.frame.width + self.visibleImageView.frame.width
                    self.invisibleImageView.frame = CGRect(x: self.center.x, y: self.center.y, width: 0, height: 0)
                    self.invisibleImageView.alpha = 0
                }
            }
        })
    }
    
    private func insertInvisibleImage(idPhoto: Int, index: Int) {
        self.photoUser?.presentValueId = idPhoto + index
        self.invisibleImageView.image = UIImage(named: (self.photoUser!.arrayValue[idPhoto + index]))
        self.invisibleImageView.alpha = 1
        self.invisibleImageView.frame = self.bounds
        self.invisibleImageView.center.x = self.frame.midX
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
        addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupImageView() {
        visibleImageView = UIImageView(frame: self.bounds)
        visibleImageView.alpha = 1
        visibleImageView.layer.borderWidth = 3
        visibleImageView.layer.borderColor = UIColor.blue.cgColor
        invisibleImageView = UIImageView(frame: CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0))
        invisibleImageView.layer.borderWidth = 3
        invisibleImageView.layer.borderColor = UIColor.black.cgColor
        invisibleImageView.alpha = 0
        visibleImageView.contentMode = self.contentMode
        invisibleImageView.contentMode = self.contentMode
        
        addSubview(invisibleImageView)
        addSubview(visibleImageView)
    }
    
    func setPhoto(named: String) {
        visibleImageView.image = UIImage(named: named)
    }
    
    override func draw(_ rect: CGRect) {
        visibleImageView.frame = rect
    }
    

}
