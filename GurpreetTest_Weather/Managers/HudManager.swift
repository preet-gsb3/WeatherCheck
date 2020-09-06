import Foundation
import NVActivityIndicatorView

class HudManager: NSObject  {
    static let shared = HudManager()
    private override init() {}
    
    var indicatorView   : UIActivityIndicatorView = UIActivityIndicatorView()
    var activityLoader = ActivityData(size: CGSize(width: 45, height: 45)
        , messageFont: UIFont.systemFont(ofSize: 14)
        , type: NVActivityIndicatorType.ballPulse
        , color: UIColor.lightGray
        , textColor: UIColor.lightGray)
    
    //MARK:- Loader Method
    
    func addLoader(_ message : String?) {
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityLoader, nil)
            if let _ = message {
                NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
            }
        }
    }
    
    func changeLoaderMessage(_ message : String) {
        NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
    }
    
    func removeLoader() {
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }
    
    //MARK: - UIACtivityIndicator
    
    func addActivityIndicator(view : UIView) {
        
        removeActivityIndicator()
        
        indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = UIColor.white
        view.addSubview(indicatorView)
        
        let horizontalConstraint = NSLayoutConstraint(item: indicatorView,
                                                      attribute: .centerX,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .centerX,
                                                      multiplier: 1,
                                                      constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: indicatorView,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .centerY,
                                                    multiplier: 1,
                                                    constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
    func removeActivityIndicator() {
        indicatorView.isHidden = true
        indicatorView.stopAnimating()
        indicatorView .removeFromSuperview()
    }
    
}
