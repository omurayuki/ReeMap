import Foundation

protocol ObjectTransferDelegate: NSObject {
    
    func transferObjects<T>(object: [T]) where T: Model
}
