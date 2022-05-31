//
//  AddSectionVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit

class AddSectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addSubView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
}

extension AddSectionVC {
    func setup() {
        view.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(reload),
            name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    func addSubView() {
        let width: CGFloat = view.bounds.width * 2 / 3
        let heigth: CGFloat = width / 1.5
        let x: CGFloat = view.center.x - width / 2
        let y: CGFloat = view.center.y - heigth / 2
        
        let addSectionView = AddSectionView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        
        view.addSubview(addSectionView)
    }
    
    @objc func reload() {
        dismiss(animated: true)
    }
}
