import FloatingPanel

protocol PanelLayout where Self: FloatingPanelLayout {
    
    var panelType: PanelCase! { get set }
}

protocol PanelFactoryProtocol {
    
    static func createBasicPanelLayout() -> PanelLayout
    static func createHiddenPanelLayout() -> PanelLayout
}

final class PanelFactory: PanelFactoryProtocol {
    
    static func createBasicPanelLayout() -> PanelLayout {
        return BasicPanelLayout(panel: .tipPanel)
    }
    
    static func createHiddenPanelLayout() -> PanelLayout {
        return HiddenPanelLayout(panel: .hiddenPanel)
    }
}

class BasicPanelLayout: FloatingPanelLayout, PanelLayout {
    
    var panelType: PanelCase!
    
    init(panel type: PanelCase) {
        self.panelType = type
    }
    
    var initialPosition: FloatingPanelPosition {
        return panelType.type
    }
    
    var bottomInteractionBuffer: CGFloat {
        return 0.0
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0
        case .half: return 262.0
        case .tip: return 69.0
        default: return nil
        }
    }
}

class HiddenPanelLayout: FloatingPanelLayout, PanelLayout {
    
    var panelType: PanelCase!
    
    init(panel type: PanelCase) {
        self.panelType = type
    }
    
    var initialPosition: FloatingPanelPosition {
        return panelType.type
    }
    
    var bottomInteractionBuffer: CGFloat {
        return 0.0
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0
        case .half: return 262.0
        case .hidden: return 0.0
        default: return nil
        }
    }
}
