//
//  TimerListVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit
import SnapKit

class TimerListVC: UIViewController {

    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.configuration = buttonConfig(true)
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var addTimerButton: UIButton = {
        let button = UIButton()
        button.alpha = 0
        button.setImage(UIImage(systemName: "timer"), for: .normal)
        button.configuration = buttonConfig(false)
        button.addTarget(self, action: #selector(addTimerButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var addSectionButton: UIButton = {
        let button = UIButton()
        button.alpha = 0
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.configuration = buttonConfig(false)
        button.addTarget(self, action: #selector(addSectionButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var recognizeTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(recognizeTapped(_:)))
        
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

extension TimerListVC {
    func setup() {
        view.addGestureRecognizer(recognizeTapGesture)
        
        [addTimerButton, addSectionButton, addButton]
            .forEach { view.addSubview($0) }
        
        addButton.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().offset(-40)
        }
        
        addTimerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalTo(addButton)
        }
        
        addSectionButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalTo(addButton)
        }
    }
    
    func buttonConfig(_ isMain: Bool) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = isMain ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        config.background.backgroundColor = isMain ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        config.cornerStyle = .capsule
        
        let fontSize: CGFloat = isMain ? 35 : 25
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: fontSize)
        
        return config
    }
}

extension TimerListVC {
    @objc func addButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? showButtons() : hideButtons()
    }
    
    @objc func addTimerButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func addSectionButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func recognizeTapped(_ sender: Any) {
        hideButtons()
    }
    
    func showButtons() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.addButton.transform = CGAffineTransform(rotationAngle: Double.pi / 4)
            self?.addTimerButton.alpha = 1
            self?.addTimerButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-110)
            }
            self?.addTimerButton.superview?.layoutIfNeeded()
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, delay: 0, animations: { [weak self] in
                self?.addSectionButton.alpha = 1
                self?.addSectionButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-170)
                }
                self?.addSectionButton.superview?.layoutIfNeeded()
            })
        })
    }
    
    func hideButtons() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.addButton.transform = CGAffineTransform(rotationAngle: 0)
            self?.addSectionButton.alpha = 0
            self?.addSectionButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-40)
            }
            self?.addSectionButton.superview?.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, animations: { [weak self] in
                self?.addTimerButton.alpha = 0
                self?.addTimerButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-40)
                }
                self?.addTimerButton.superview?.layoutIfNeeded()
            })
        }
    }
}
