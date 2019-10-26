import UIKit
import Photos
import WeScan

class ImagePickerService: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    var completionBlock: CompletionObject<Result<UIImage, Error>>?
    
    func pickImage(from vc: UIViewController,
                   allowEditing: Bool = true,
                   source: UIImagePickerController.SourceType? = nil,
                   completion: CompletionObject<Result<UIImage, Error>>?) {
        completionBlock = completion
        picker.allowsEditing = allowEditing
        guard let source = source else {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: R.string.localizable.camera(), style: .default) { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.picker.sourceType = .camera
                vc.present(weakSelf.picker, animated: true)
            }
            let photoAction = UIAlertAction(title: R.string.localizable.library(), style: .default) { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.picker.sourceType = .photoLibrary
                vc.present(weakSelf.picker, animated: true)
            }
            let scanAction = UIAlertAction(title: R.string.localizable.document(), style: .default) { _ in
                let scannerVC = ImageScannerController(delegate: self)
                scannerVC.modalPresentationStyle = .fullScreen
                vc.present(scannerVC, animated: true)
            }
            let cancelAction = UIAlertAction(title: R.string.localizable.cance(), style: .cancel)
            sheet.addAction(cameraAction)
            sheet.addAction(photoAction)
            sheet.addAction(scanAction)
            sheet.addAction(cancelAction)
            vc.present(sheet, animated: true)
            return
        }
        picker.sourceType = source
        vc.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) { [unowned self] in
            if let image = info[.originalImage] as? UIImage {
                self.completionBlock?(.success(image.fixOrientation()))
            }
        }
    }
}

extension ImagePickerService: ImageScannerControllerDelegate {
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        completionBlock?(.failure(error))
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true) { [unowned self] in
            self.completionBlock?(.success(results.scannedImage.fixOrientation()))
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
}
