import Foundation
import UIKit

extension UITableView {
    
    class Builder {
        
        private var backgroundImage: UIImage?
        private var contentMode: ContentMode?
        private var backGroundViewContentMode: ContentMode?
        private var estimatedRowHeight: CGFloat?
        
        private var clipToBounds: Bool = true
        private var backgroundColor: UIColor = .appMainColor
        private var separatorColor: UIColor = .appCoolGrey
        private var separatorInsets: UIEdgeInsets = .zero
        private var rowHeight: CGFloat = UITableView.automaticDimension
        private var backgroundAlpha: CGFloat = 1
        private var tableFooterView = UIView()
        private var isUserInteractionEnabled: Bool = true
        private var backgroundViewClipsToBounds: Bool = true
        
        func backgroundImage(_ backgroundImage: UIImage) -> Builder {
            self.backgroundImage = backgroundImage
            return self
        }
        
        func clipToBounds(_ clipToBounds: Bool) -> Builder {
            self.clipToBounds = clipToBounds
            return self
        }
        
        func contentMode(_ contentMode: ContentMode) -> Builder {
            self.contentMode = contentMode
            return self
        }
        
        func backgroundColor(_ backgroundColor: UIColor) -> Builder {
            self.backgroundColor = backgroundColor
            return self
        }
        
        func separatorColor(_ separatorColor: UIColor) -> Builder {
            self.separatorColor = separatorColor
            return self
        }
        
        func separatorInsets(_ separatorInsets: UIEdgeInsets) -> Builder {
            self.separatorInsets = separatorInsets
            return self
        }
        
        func estimatedRowHeight(_ estimatedRowHeight: CGFloat) -> Builder {
            self.estimatedRowHeight = estimatedRowHeight
            return self
        }
        
        func rowHeight(_ rowHeight: CGFloat) -> Builder {
            self.rowHeight = rowHeight
            return self
        }
        
        func backgroundAlpha(_ backgroundAlpha: CGFloat) -> Builder {
            self.backgroundAlpha = backgroundAlpha
            return self
        }
        
        func tableFooterView(_ tableFooterView: UIView) -> Builder {
            self.tableFooterView = tableFooterView
            return self
        }
        
        func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Builder {
            self.isUserInteractionEnabled = isUserInteractionEnabled
            return self
        }
        
        func backgroundViewClipsToBounds(_ backgroundViewClipsToBounds: Bool) -> Builder {
            self.backgroundViewClipsToBounds = backgroundViewClipsToBounds
            return self
        }
        
        func backGroundViewContentMode(_ backGroundViewContentMode: ContentMode) -> Builder {
            self.backGroundViewContentMode = backGroundViewContentMode
            return self
        }
        
        func build() -> UITableView {
            let table = UITableView()
            table.backgroundView = UIImageView(image: backgroundImage)
            table.backgroundView?.alpha = backgroundAlpha
            table.clipsToBounds = clipToBounds
            table.contentMode = contentMode ?? .scaleAspectFit
            table.backgroundColor = backgroundColor
            table.separatorColor = separatorColor
            table.separatorInset = separatorInsets
            table.tableFooterView = tableFooterView
            table.estimatedRowHeight = estimatedRowHeight ?? 400
            table.rowHeight = rowHeight
            table.isUserInteractionEnabled = isUserInteractionEnabled
            table.backgroundView?.clipsToBounds = backgroundViewClipsToBounds
            table.backgroundView?.contentMode = backGroundViewContentMode ?? .scaleAspectFit
            return table
        }
    }
    
    func scroll(to: Position, animated: Bool) {
        let sections = numberOfSections
        let rows = numberOfRows(inSection: numberOfSections - 1)
        switch to {
        case .top:
            if rows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
        case .bottom:
            if rows > 0 {
                let indexPath = IndexPath(row: rows - 1, section: sections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    enum Position {
        case top
        case bottom
    }
}
