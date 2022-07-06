//
//  Extension++UIViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit

extension UIViewController{
    // https://stackoverflow.com/questions/38144019/how-to-create-uialertcontroller-in-global-swift
    // Define Your number of buttons, styles and completion
    public func openAlert(title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated()  {
            let action = UIAlertAction(
                title: indexTitle,
                style: actionStyles[index],
                handler: actions[index])
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true)
    }
    
    func notifyReloadAndDismiss() {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "reload"),
            object: nil,
            userInfo: nil)
        
        dismiss(animated: true)
    }
}
