import Foundation
import FloatingPanel

class FloatingPanelDelegate: NSObject, FloatingPanelControllerDelegate {
    
    var panelType: PanelCase!
    
    private let panelLayoutforHandler: (FloatingPanelController, UITraitCollection) -> Void
    
    private let panelaDidMoveHandler: (CGFloat) -> Void
    
    private let panelBeginDraggingHandler: ((FloatingPanelController) -> Void)?
    
    private let panelEndDraggingHandler: (FloatingPanelController, CGPoint, FloatingPanelPosition) -> Void
    
    init(panel type: PanelCase,
         panelLayoutforHandler: @escaping (FloatingPanelController, UITraitCollection) -> Void,
         panelaDidMoveHandler: @escaping (CGFloat) -> Void,
         panelBeginDraggingHandler: ((FloatingPanelController) -> Void)? = nil,
         panelEndDraggingHandler: @escaping (FloatingPanelController, CGPoint, FloatingPanelPosition) -> Void) {
        self.panelType = type
        self.panelLayoutforHandler = panelLayoutforHandler
        self.panelaDidMoveHandler = panelaDidMoveHandler
        self.panelBeginDraggingHandler = panelBeginDraggingHandler
        self.panelEndDraggingHandler = panelEndDraggingHandler
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        panelLayoutforHandler(vc, newCollection)
        return BasicPanelLayout(panel: panelType)
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        let y = vc.surfaceView.frame.origin.y
        let tipY = vc.originYOfSurface(for: .tip)
        if y > tipY - 44.0 {
            let progress = max(0.0, min((tipY - y) / 44.0, 1.0))
            panelaDidMoveHandler(progress)
        }
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        panelBeginDraggingHandler?(vc)
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        panelEndDraggingHandler(vc, velocity, targetPosition)
    }
}
