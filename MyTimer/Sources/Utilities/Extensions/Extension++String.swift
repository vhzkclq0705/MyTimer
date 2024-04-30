//
//  Extension++String.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-30.
//

import UIKit

extension String {
    
    func convertToAttributedString() -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                .foregroundColor: UIColor.CustomColor(.purple4),
                .font : UIFont(name: Font.bold.rawValue, size: 30)!
            ]
        )
    }
    
}
