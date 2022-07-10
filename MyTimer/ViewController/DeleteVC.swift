//
//  DeleteTimerVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit

class DeleteTimerVC: UIViewController {

    // MARK: - Property
    let checkView = CheckView()
    var sectionTitle: String?
    var timer: MyTimer?
    
    // MARK: - Life cycle
    override func loadView() {
        view = checkView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
