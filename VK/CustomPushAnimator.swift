import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        destinaton.view.frame = source.view.frame
        destinaton.view.center.x = source.view.frame.maxX + source.view.frame.height/2
        destinaton.view.center.y = source.view.frame.minY
        let frameSource = source.view.frame
        destinaton.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75, animations: {
                                        let translation = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                                        source.view.center.x = -frameSource.midY
                                        source.view.center.y = frameSource.midX
                                        source.view.transform = translation
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.75, animations: {
                                        destinaton.view.center.x = frameSource.midX
                                        destinaton.view.center.y = frameSource.midY
                                        destinaton.view.transform = .identity
                                    })
                                })
        {fished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
            
    }
    

}
