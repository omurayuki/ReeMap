import Foundation

protocol ObjectTransferDelegate: NSObject {
    
    func transferObjects<T>(object: [T]) where T: Model
}

protocol TappedSearchBarDelegate: NSObject {
    
    func tappedSearchBar()
}

protocol TappedCellDelegate: NSObject {
    
    func didselectCell(place: Place)
}
