import UIKit

extension UIView {
    
    class Animator {
        
        // swiftlint:disable all
        typealias Animations = () -> Void
        typealias Completion = (Bool) -> Void
        
        private var animations: Animations
        private var completion: Completion?
        private let duration: TimeInterval
        private let delay: TimeInterval?
        private let options: UIView.AnimationOptions?
        
        init(duration: TimeInterval, delay: TimeInterval? = 0.0, options: UIView.AnimationOptions? = .curveEaseInOut) {
            self.animations = {}
            self.completion = nil
            self.duration = duration
            self.delay = delay
            self.options = options
        }
        
        func animations(_ animations: @escaping Animations) -> Self {
            self.animations = animations
            return self
        }
        
        func completion(_ completion: @escaping Completion) -> Self {
            self.completion = completion
            return self
        }
        
        func animate() {
            UIView.animate(withDuration: duration,
                           delay: delay ?? 0.0,
                           options: options ?? .curveEaseInOut,
                           animations: animations,
                           completion: completion)
        }
    }
    
    class SpringAnimator {
        
        typealias Animations = () -> Void
        typealias Completion = (Bool) -> Void
        
        private var animations: Animations
        private var completion: Completion?
        private let duration: TimeInterval
        private let delay: TimeInterval?
        private var damping: CGFloat
        private var velocity: CGFloat
        private let options: UIView.AnimationOptions?
        
        init(duration: TimeInterval,
             delay: TimeInterval? = 0.0,
             damping: CGFloat,
             velocity: CGFloat,
             options: UIView.AnimationOptions? = .curveEaseInOut) {
            self.animations = {}
            self.completion = nil
            self.duration = duration
            self.delay = delay
            self.damping = damping
            self.velocity = velocity
            self.options = options
        }
        
        func animations(_ animations: @escaping Animations) -> Self {
            self.animations = animations
            return self
        }
        
        func completion(_ completion: @escaping Completion) -> Self {
            self.completion = completion
            return self
        }
        
        func animate() {
            UIView.animate(withDuration: duration,
                           delay: delay ?? 0.0,
                           usingSpringWithDamping: damping,
                           initialSpringVelocity: velocity,
                           options: options ?? .curveEaseInOut,
                           animations: animations,
                           completion: completion)
        }
    }
}
