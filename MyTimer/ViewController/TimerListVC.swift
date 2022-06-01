//
//  TimerListVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit
import SnapKit
import ExpyTableView

// ViewController for main View
class TimerListVC: UIViewController {
    
    // MARK: - Create UI items
    lazy var tableView: ExpyTableView = {
        let tableView = ExpyTableView(frame: .zero, style: .insetGrouped)
        tableView.register(TimerListHeaderCell.self, forCellReuseIdentifier: TimerListHeaderCell.id)
        tableView.register(TimerListCell.self, forCellReuseIdentifier: TimerListCell.id)
        tableView.expandingAnimation = .fade
        tableView.collapsingAnimation = .fade
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    // MARK: - Funcs for life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
}

// MARK: - Funcs for setup UI
extension TimerListVC {
    func setup() {
        viewModel.load()
        
        [tableView, addTimerButton, addSectionButton,
         addButton, addTimerLabel, addSectionLabel]
        .forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(50)
            $0.left.right.equalToSuperview().inset(30)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().offset(-40)
        }
        
        addTimerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-110)
            $0.centerX.equalTo(addButton)
        }
        
        addSectionButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-170)
            $0.centerX.equalTo(addButton)
        }
        
        addTimerLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-120)
            $0.right.equalTo(addTimerButton.snp.left).offset(-10)
        }
        
        addSectionLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-180)
            $0.right.equalTo(addSectionButton.snp.left).offset(-10)
        }
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(reload),
            name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    func buttonConfig(_ isMain: Bool) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = isMain ? .white : Colors.color(0)
        config.background.backgroundColor = isMain ? Colors.color(0) : .white
        config.cornerStyle = .capsule
        
        let fontSize: CGFloat = isMain ? 35 : 25
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: fontSize)
        
        return config
    }
}

// MARK: - Funcs for TableView
extension TimerListVC: ExpyTableViewDelegate, ExpyTableViewDataSource {
    // true = Expandable, false = Non-Expandable(Same as default TableView)
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfTimers(section) + 1
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
        
        cell.updateUI(title: timer.title, min: timer.min, sec: timer.sec)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Check whether the Section is open or closed.
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
        // This function is only a stub.
    }
}

// MARK: - Funcs for Button actions
extension TimerListVC {
    @objc func addButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        displayButtons(sender.isSelected)
        tableView.layer.opacity = sender.isSelected ? 0.7 : 1
        tableView.isUserInteractionEnabled = !sender.isSelected
    }
    
    @objc func addTimerButtonTapped(_ sender: UIButton) {
        let vc = AddTimerVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: true)
    }
    
    @objc func addSectionButtonTapped(_ sender: UIButton) {
        let vc = AddSectionVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: true)
    }
    
    @objc func reload() {
        viewModel.load()
        self.tableView.reloadData()
    }
    
    // AddButton tap animation
    func displayButtons(_ show: Bool) {
        let angle: CGFloat = show ? Double.pi / 4 : 0
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.addButton.transform = CGAffineTransform(rotationAngle: angle)
            if show {
                self?.addTimerButton.alpha = 1; self?.addTimerLabel.alpha = 1
            } else {
                self?.addSectionButton.alpha = 0; self?.addSectionLabel.alpha = 0
            }
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: { [weak self] in
                if show {
                    self?.addSectionButton.alpha = 1; self?.addSectionLabel.alpha = 1
                } else {
                    self?.addTimerButton.alpha = 0; self?.addTimerLabel.alpha = 0
                }
            })
        })
    }
}
