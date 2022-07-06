//
//  TimerListVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit
import SnapKit
import ExpyTableView

// ViewController for timer list
class TimerListVC: UIViewController {
    
    // MARK: - Create UI items
    lazy var tableView: ExpyTableView = {
        let tableView = ExpyTableView(
            frame: .zero,
            style: .insetGrouped)
        
        tableView.register(
            TimerListHeaderCell.self,
            forCellReuseIdentifier: TimerListHeaderCell.id)
        tableView.register(
            TimerListCell.self,
            forCellReuseIdentifier: TimerListCell.id)
        
        tableView.expandingAnimation = .fade
        tableView.collapsingAnimation = .fade
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    let goalLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "자신의 각오 한마디를 입력해주세요!",
            font: .bold,
            size: 23,
            color: UIColor.CustomColor(.gray2))
        label.numberOfLines = 2
        
        return label
    }()
    
    let notimerLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "아직 추가된 타이머가 없습니다! 타이머를 추가해주세요!",
            font: .medium,
            size: 18,
            color: UIColor.CustomColor(.gray3))
        label.alpha = 0
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add")?
            .withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(
            self,
            action: #selector(addButtonTapped(_:)),
            for: .touchUpInside
        )
        
        return button
    }()
    
    lazy var addTimerButton: UIButton = {
        let button = UIButton()
        button.setMainButtons("timer")
        button.addTarget(
            self,
            action: #selector(addTimerButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var addSectionButton: UIButton = {
        let button = UIButton()
        button.setMainButtons("section")
        button.addTarget(
            self,
            action: #selector(addSectionButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setMainButtons("settings")
        button.addTarget(
            self,
            action: #selector(settingsButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    let addSectionLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "섹션 추가",
            font: .semibold,
            size: 14,
            color: .black)
        label.alpha = 0
        
        return label
    }()
    
    let addTimerLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "타이머 추가",
            font: .semibold,
            size: 14,
            color: .black)
        label.alpha = 0
        
        return label
    }()
    
    let settingsLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "설정",
            font: .semibold,
            size: 14,
            color: .black)
        label.alpha = 0
        
        return label
    }()
    
    let controlView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        
        return view
    }()
    
    lazy var recognizeTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(recognizeTapped(_:)))
        
        return gesture
    }()
    
    // MARK: - Property
    let viewModel = TimerViewModel()
    
    // MARK: - Funcs for life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlarmSound()
        viewModel.load()
        checkTimerCount()
        setupUI()
        requestAuthNoti()
        
        // TableView reload notification
        NotificationCenter.default.addObserver(
            self, selector: #selector(reload),
            name: NSNotification.Name(rawValue: "reload"),
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: "reload"),
            object: nil)
    }
}

// MARK: - Setup UI
extension TimerListVC {
    func setupUI() {
        view.backgroundColor = .white
        goalLabel.text = viewModel.goal
        
        [
            addSectionButton,
            addTimerButton,
            settingsButton,
            addTimerLabel,
            addSectionLabel,
            settingsLabel,
        ]
            .forEach { controlView.addSubview($0) }
        
        controlView.addGestureRecognizer(recognizeTapGesture)
        
        [
            tableView,
            addButton,
            goalLabel,
            notimerLabel,
            controlView,
        ]
            .forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.left.right.equalToSuperview()
        }
        
        goalLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(22)
            $0.left.right.equalToSuperview().inset(17)
        }
        
        notimerLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-35)
            $0.right.equalToSuperview().offset(-26)
        }
        
        addTimerButton.snp.makeConstraints {
            $0.bottom.equalTo(addButton.snp.top).offset(-10)
            $0.centerX.equalTo(addButton)
        }
        
        addSectionButton.snp.makeConstraints {
            $0.bottom.equalTo(addTimerButton.snp.top).offset(-10)
            $0.centerX.equalTo(addButton)
        }
        
        settingsButton.snp.makeConstraints {
            $0.bottom.equalTo(addSectionButton.snp.top).offset(-10)
            $0.centerX.equalTo(addButton)
        }
        
        addTimerLabel.snp.makeConstraints {
            $0.centerY.equalTo(addTimerButton)
            $0.right.equalTo(addTimerButton.snp.left).offset(-9)
        }
        
        addSectionLabel.snp.makeConstraints {
            $0.centerY.equalTo(addSectionButton)
            $0.right.equalTo(addTimerLabel)
        }
        
        settingsLabel.snp.makeConstraints {
            $0.centerY.equalTo(settingsButton)
            $0.right.equalTo(addTimerLabel)
        }
        
        controlView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func checkTimerCount() {
        notimerLabel.alpha = viewModel.numOfSections == 0 ? 1 : 0
    }
}

// MARK: - Funcs for TableView
extension TimerListVC: ExpyTableViewDelegate, ExpyTableViewDataSource {
    // true = Expandable, false = Non-Expandable(Same as default TableView)
    func tableView(
        _ tableView: ExpyTableView,
        canExpandSection section: Int)
    -> Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numOfSections
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int {
        return viewModel.numOfTimers(section) + 1
    }
    
    // About Section headers
    func tableView(
        _ tableView: ExpyTableView,
        expandableCellForSection section: Int)
    -> UITableViewCell {
        guard let header = tableView.dequeueReusableCell(withIdentifier: TimerListHeaderCell.id) as? TimerListHeaderCell else {
            return UITableViewCell()
        }
        
        let title = viewModel.sectionTitle(section)
        
        header.updateUI(text: title)
        
        return header
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerListCell.id) as? TimerListCell else {
            return UITableViewCell()
        }
        
        let timer = viewModel.timerInfo(indexPath)
        cell.updateUI(
            title: timer.title,
            min: timer.min,
            sec: timer.sec)
        
        cell.timerButtonTapHandler = { [weak self] in
            self?.popupDetailTimer(indexPath)
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return indexPath.row == 0 ? 25 : 80
    }
    
    // Check whether the Section is open or closed.
    func tableView(
        _ tableView: ExpyTableView,
        expyState state: ExpyState,
        changeForSection section: Int) {
            // This function is only a stub.
        }
}

// MARK: - Funcs for actions
extension TimerListVC {
    @objc func recognizeTapped(_ sender: Any) {
        addButton.isSelected = false
        displayButtons(false)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        displayButtons(sender.isSelected)
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
    
    @objc func settingsButtonTapped(_ sender: UIButton) {
        let vc = SettingsVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: true)
    }
    
    @objc func reload() {
        view.layer.opacity = 1
        viewModel.load()
        self.tableView.reloadData()
    }
    
    func popupTimeSet(_ indexPath: IndexPath) {
        let vc = SetTimerVC()
        vc.timer = viewModel.timerInfo(indexPath)
        vc.timerIndexPath = indexPath
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        view.layer.opacity = 0.7
        
        present(vc, animated: true)
    }
    
    func popupDetailTimer(_ indexPath: IndexPath) {
        let vc = DetailTimerVC()
        vc.myTimer = viewModel.timerInfo(indexPath)
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        view.layer.opacity = 0.7
        
        present(vc, animated: true)
    }
    
    func swipeDeleteButtonTapped(_ indexPath: IndexPath) {
        if indexPath.row == 0 {
            let section = viewModel.sections[indexPath.section]
            viewModel.deleteSection(section)
        } else {
            let timer = viewModel.timerInfo(indexPath)
            viewModel.deleteTimer(section: indexPath.section, timer: timer)
        }
        tableView.reloadData()
    }
    
    func swipeSetButtonTapped(_ indexPath: IndexPath) {
        let vc = SetTimerVC()
        vc.timer = viewModel.timerInfo(indexPath)
        vc.timerIndexPath = indexPath
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        view.layer.opacity = 0.7
        
        present(vc, animated: true)
    }
}
