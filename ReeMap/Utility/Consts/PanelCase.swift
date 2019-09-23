import Foundation
import FloatingPanel

enum PanelCase {
    case hiddenPanel
    case tipPanel
    case halfPanel
    case fullPanel
    
    var type: FloatingPanelPosition {
        switch self {
        case .hiddenPanel: return .hidden
        case .tipPanel:    return .tip
        case .halfPanel:   return .half
        case .fullPanel:   return .full
        }
    }
}
