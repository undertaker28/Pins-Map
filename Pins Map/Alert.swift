//
//  Alert.swift
//  Pins Map
//
//  Created by Pavel on 5.08.22.
//

import SwiftUI

extension View {
    func alertAddAddress(title: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default) { (action) in
            let textFieldAddress = alertController.textFields?.first
            guard let addressText = textFieldAddress?.text else {
                return
            }
            completionHandler(addressText)
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
            
        }
        
        rootController().present(alertController, animated: true)
    }
    
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
    
    func alertError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(alertOk)
        
        rootController().present(alertController, animated: true)
    }
}
