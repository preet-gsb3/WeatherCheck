import UIKit

struct GPAlert {
    let title: String!
    let message: String!
}

extension UIAlertController {
    
    func present() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            // topController should now be your topmost view controller
            
            DispatchQueue.main.async {
                topController.present(self, animated: true, completion: nil)
            }
        }
    }
    
}

class AlertManager: NSObject, UIAlertViewDelegate {
    static let shared = AlertManager()
    private override init() {}

    var completionBlock: ((_ selectedIndex: Int) -> Void)? = nil
    
    func show(_ alert: GPAlert
        , buttonsArray : [Any] = ["Ok"]
        , completionBlock : ((_ : Int) -> ())? = nil) {

        self.completionBlock = completionBlock
        
        let alertView = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        for i in 0..<buttonsArray.count {
            let buttonTitle: String = buttonsArray[i] as! String
            let btnAction = UIAlertAction(title: buttonTitle, style: .default) { (alertAction) in
                if self.completionBlock != nil {
                    self.completionBlock!(i)
                }
            }
            alertView.addAction(btnAction)
        }
        
        alertView.present()
        
    }
    
    func showWithoutLocalize(_ alert: GPAlert
        , buttonsArray : [Any] = ["Ok"]
        , completionBlock : ((_ : Int) -> ())? = nil) {
        
        self.completionBlock = completionBlock
        
        let alertView = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        for i in 0..<buttonsArray.count {
            let buttonTitle: String = buttonsArray[i] as! String
            let btnAction = UIAlertAction(title: buttonTitle, style: .default) { (alertAction) in
                if self.completionBlock != nil {
                    self.completionBlock!(i)
                }
            }
            alertView.addAction(btnAction)
        }
        
        alertView.present()
    }
    
    func showPopup(_ alert : GPAlert
        , forTime time : Double
        , completionBlock : ((_ : Int) -> ())? = nil) {
    
        self.completionBlock = completionBlock
        
        let alertView = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertView.present()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((ino64_t)(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            alertView.dismiss(animated: true)
            if completionBlock != nil {
                completionBlock!(0)
            }
        })
        
    }
    
    func showActionSheet(_ sender: UIView, alert: GPAlert, buttonsArray : [Any] = ["Ok"], completionBlock : ((_ : Int) -> ())? = nil) {
        
        self.completionBlock = completionBlock
        
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        for i in 0..<buttonsArray.count {
            let buttonTitle: String = buttonsArray[i] as! String
            let btnAction = UIAlertAction(title: buttonTitle, style: .default) { (alertAction) in
                if self.completionBlock != nil {
                    self.completionBlock!(i)
                }
            }
            alert.addAction(btnAction)
        }
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        alert.present()
    }
    
    
}
