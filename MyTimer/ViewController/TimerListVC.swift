//
//  TimerListVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit
import SnapKit
import ExpyTableView

// UI Setup
class TimerListVC: UIViewController {

    lazy var tableView: ExpyTableView = {
        let tableView = ExpyTableView(frame: .zero, style: .insetGrouped)
        tableView.register(TimerListHeaderCell.self, forCellReuseIdentifier: TimerListHeaderCell.id)
        tableView.register(TimerListCell.self, forCellReuseIdentifier: TimerListCell.id)
        tableView.expandingAnimation = .fade
        tableView.collapsingAnimation = .fade
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
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
    
    lazy var addSectionLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.text = "섹션 추가"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    lazy var addTimerLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.text = "타이머 추가"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    
    let viewModel = TimerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// About how to display TableView
extension TimerListVC: ExpyTableViewDelegate, ExpyTableViewDataSource {
    // true = Expandable, false = Non-Expandable(Same as default TableView)
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfTimers(section)
    }
    
    // About Section headers
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        guard let header = tableView.dequeueReusableCell(withIdentifier: TimerListHeaderCell.id) as? TimerListHeaderCell else { return UITableViewCell() }
        
        let title = viewModel.sectionTitle(section)
        let color = viewModel.sectionColor(section)
        
        header.updateUI(text: title, color: color)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerListCell.id) as? TimerListCell else { return UITableViewCell() }
        
        let timer = viewModel.timerInfo(section: indexPath.section, index: indexPath.row)
        cell.updateUI(title: timer.title, time: timer.time)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // Check whether the Section is open or closed.
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
        // This function is only a stub.
    }
}

// Functions for UI setup
extension TimerListVC {
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.load()
        
        [tableView, addTimerButton, addSectionButton,
         addButton, addTimerLabel, addSectionLabel]
        .forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(50)
        }
        
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
        
        addTimerLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.right.equalTo(addTimerButton.snp.left).offset(-10)
        }
        
        addSectionLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.right.equalTo(addSectionButton.snp.left).offset(-10)
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
        tableView.layer.opacity = sender.isSelected ? 0.7 : 1
    }
    
    @objc func addTimerButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func addSectionButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func recognizeTapped(_ sender: Any) {
        if addButton.isSelected {
            hideButtons()
        }
    }
    
    func showButtons() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.addButton.transform = CGAffineTransform(rotationAngle: Double.pi / 4)
            self?.addTimerButton.alpha = 1
            self?.addTimerLabel.alpha = 1
            self?.addTimerButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-110)
            }
            self?.addTimerButton.superview?.layoutIfNeeded()
            self?.addTimerLabel.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-120)
            }
            self?.addTimerLabel.superview?.layoutIfNeeded()
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, delay: 0, animations: { [weak self] in
                self?.addSectionButton.alpha = 1
                self?.addSectionLabel.alpha = 1
                self?.addSectionButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-170)
                }
                self?.addSectionButton.superview?.layoutIfNeeded()
                self?.addSectionLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-180)
                }
                self?.addSectionLabel.superview?.layoutIfNeeded()
            })
        })
    }
    
    func hideButtons() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.addButton.transform = CGAffineTransform(rotationAngle: 0)
            self?.addSectionButton.alpha = 0
            self?.addSectionLabel.alpha = 0
            self?.addSectionButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-40)
            }
            self?.addSectionButton.superview?.layoutIfNeeded()
            self?.addSectionLabel.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-40)
            }
            self?.addSectionLabel.superview?.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, animations: { [weak self] in
                self?.addTimerButton.alpha = 0
                self?.addTimerLabel.alpha = 0
                self?.addTimerButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-40)
                }
                self?.addTimerButton.superview?.layoutIfNeeded()
                self?.addTimerLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-40)
                }
                self?.addTimerLabel.superview?.layoutIfNeeded()
            })
        }
    }
}
