import FloatingPanel

// -TODO: factory method

class BasicPanelLayout: FloatingPanelLayout {
    
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

class HiddenPanelLayout: FloatingPanelLayout {
    
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
