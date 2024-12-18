//
//  AlertPresenter.swift
//  TaskList
//
//  Created by Artem H on 12/18/24.
//

import UIKit

struct AlertPresenter {
    
    static func showAlert(
        on viewController: UIViewController,
        withTitle title: String,
        andMessage message: String,
        placeHolder: String? = nil,
        completion: ((String?) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let inputText = alert.textFields?.first?.text
            completion?(inputText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            
            if placeHolder == nil {
                textField.placeholder = "New Task"
            } else {
                textField.text = placeHolder
            }
        }
        
        viewController.present(alert, animated: true)
    }
}
