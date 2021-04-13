import UIKit

class CommentsControl: UIControl {

    private var comments: Comments
    
    override init(frame: CGRect) {
        self.comments = Comments(frame: frame)
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        self.comments = Comments(coder: aDecoder)
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(comments)
    }

}
