//
//  EZAlertView.swift
//  EZAlertView
//
//  Created by Furkan Yilmaz on 11/11/15.
//  Copyright © 2015 Furkan Yilmaz. All rights reserved.
//
import UIKit

@objc open class EZAlertController: NSObject {
    //==========================================================================================================

    // MARK: - Singleton

    //==========================================================================================================
    class var instance: EZAlertController {
        enum Static {
            static let inst = EZAlertController()
        }
        return Static.inst
    }

    //==========================================================================================================

    // MARK: - Private Functions

    //==========================================================================================================
    fileprivate func topMostController() -> UIViewController? {
        // var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        var presentedVC = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }

        if presentedVC == nil {
            print("EZAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }

    //==========================================================================================================

    // MARK: - Class Functions

    //==========================================================================================================
    @discardableResult
    open class func alert(_ title: String) -> UIAlertController {
        return alert(title, message: "")
    }

    @discardableResult
    open class func alert(_ title: String, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK", acceptBlock: {
            // Do nothing
        })
    }

    @discardableResult
    open class func alert(_ title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (_: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)

        instance.topMostController()?.present(alert, animated: true)
        return alert
    }

    @discardableResult
    open class func alert(_ title: String, message: String, buttons: [String], tapBlock: ((UIAlertAction, Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController()?.present(alert, animated: true)
        return alert
    }

    @discardableResult
    open class func alert(_ title: String, message: String, buttons: [String], buttonsPreferredStyle: [UIAlertAction.Style], tapBlock: ((UIAlertAction, Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, buttonsPreferredStyle: buttonsPreferredStyle, tapBlock: tapBlock)
        instance.topMostController()?.present(alert, animated: true)
        return alert
    }

    @discardableResult
    open class func alert(_ title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        actions.forEach(alert.addAction)
        instance.topMostController()?.present(alert, animated: true)
        return alert
    }

    @discardableResult
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        actions.forEach(alert.addAction)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.present(alert, animated: true)
        return alert
    }

    @discardableResult
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, buttons: [String], tapBlock: ((UIAlertAction, Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.present(alert, animated: true)
        return alert
    }
}

private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons: [String], tapBlock: ((UIAlertAction, Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            addAction(action)
        }
    }

    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons: [String], buttonsPreferredStyle: [UIAlertAction.Style], tapBlock: ((UIAlertAction, Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: buttonsPreferredStyle[buttonIndex], buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style = .default, buttonIndex: Int, tapBlock: ((UIAlertAction, Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) {
            (action: UIAlertAction) in
            tapBlock?(action, buttonIndex)
        }
    }
}
