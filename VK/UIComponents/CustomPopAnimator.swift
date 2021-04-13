import UIKit

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard  let source = transitionContext.viewController(forKey: .from) else {
            return
        }
        guard let destinaton = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        transitionContext.containerView.addSubview(destinaton.view)
        transitionContext.containerView.sendSubviewToBack(destinaton.view)
        destinaton.view.frame = CGRect(x: 0, y: 0, width: source.view.frame.height, height: source.view.frame.width)
        let translation = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        let centerX = source.view.center.x
        let centerY = source.view.center.y
        destinaton.view.center.x = source.view.frame.minX - centerX + destinaton.view.bounds.minY
        destinaton.view.center.y = source.view.frame.minY - source.view.frame.height/2
        destinaton.view.transform = translation
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75, animations: {
                                        let translation = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                                        source.view.center.x = source.view.frame.maxX + source.view.frame.height/2
                                        source.view.center.y = centerY
                                        source.view.transform = translation
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.75, animations: {
                                        destinaton.view.center.x = centerX
                                        destinaton.view.center.y = centerY
                                        destinaton.view.transform = .identity
                                    })
                                })
        {fished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
