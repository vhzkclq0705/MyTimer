//
//  Extension++UIView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/18.
//

import UIKit

extension UIView {
    func setBackgroundView() {
        self.backgroundColor = .black
        self.alpha = 0.45
    }
    
    func setupSubView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        self.layer.mask = mask
    }
}
