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
        tableView.backgroundColor = #colorLiteral(red: 0.09275915474, green: 0.09275915474, blue: 0.09275915474, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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
    
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.alpha = 0
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.configuration = buttonConfig(false)
        button.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        
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
    
    lazy var settingsLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.text = "설정"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    lazy var controlView: UIView = {
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
    
    // MARK: - viewModel
    let viewModel = TimerViewModel()
    
    // MARK: - Funcs for life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlarmSound()
        viewModel.load()
        setupUI()
        requestAuthNoti()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
}

// MARK: - Funcs for setup UI
extension TimerListVC {
    func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)
        
        [ addSectionButton, addTimerButton, settingsButton,
          addTimerLabel, addSectionLabel, settingsLabel ]
            .forEach { controlView.addSubview($0) }
        
        controlView.addGestureRecognizer(recognizeTapGesture)

        [ tableView, addButton, controlView ]
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
        
        settingsButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-230)
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
        
        settingsLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-240)
            $0.right.equalTo(addSectionButton.snp.left).offset(-10)
        }
        
        controlView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        
        let timer = viewModel.timerInfo(indexPath)
        cell.updateUI(title: timer.title, min: timer.min, sec: timer.sec,
                      color: viewModel.sectionColor(indexPath.section))
//        cell.updateUI(title: timer.title, min: timer.min, sec: timer.sec,
//                      color: Colors.color(7))
        
        cell.timeSetButtonTapHandler = {
            self.popupTimeSet(indexPath)
        }
        
        cell.timerButtonTapHandler = { [weak self] in
            self?.popupDetailTimer(indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 50 : 80
    }
    
    // TableView swipe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let setCellAction = UIContextualAction(style: .normal, title: "") { _, _, _ in
            self.swipeSetButtonTapped(indexPath)
        }
        setCellAction.image = UIImage(systemName: "gear")
        setCellAction.backgroundColor = viewModel.sectionColor(indexPath.section)
        
        let deleteCellAction = UIContextualAction(style: .normal, title: "") { _, _, _ in
            self.swipeDeleteButtonAlert(indexPath)
        }
        deleteCellAction.image = UIImage(systemName: "trash.fill")
        deleteCellAction.backgroundColor = .lightGray
        
        if indexPath.row == 0 {
            return UISwipeActionsConfiguration(actions: [deleteCellAction])
        } else {
            return UISwipeActionsConfiguration(actions: [deleteCellAction, setCellAction])
        }
        
    }
    
    // Check whether the Section is open or closed.
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
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
        vc.color = viewModel.sectionColor(indexPath.section)
        vc.myTimer = viewModel.timerInfo(indexPath)
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        view.layer.opacity = 0.7
        
        present(vc, animated: true)
    }
    
    func swipeDeleteButtonAlert(_ indexPath: IndexPath) {
        var selectType: String
        var title: String
        
        if indexPath.row == 0 {
            selectType = "섹션을"
            title = viewModel.sections[indexPath.section].title
        } else {
            selectType = "타이머를"
            title = viewModel.timerInfo(indexPath).title
        }
        self.openAlert(title: "\(title)",
                              message: "해당 \(selectType) 삭제하시겠습니까?",
                              alertStyle: .alert,
                              actionTitles: ["확인", "취소"],
                              actionStyles: [.default, .cancel],
                              actions: [
                                  {_ in
                                      self.swipeDeleteButtonTapped(indexPath)
                                  }, {_ in }
                             ])
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
    
    // AddButton tap animation
    func displayButtons(_ show: Bool) {
        tableView.isUserInteractionEnabled = !show
        tableView.layer.opacity = show ? 0.7 : 1
        controlView.isHidden = !show
        
        let angle: CGFloat = show ? Double.pi / 4 : 0
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.addButton.transform = CGAffineTransform(rotationAngle: angle)
            if show {
                self.addTimerButton.alpha = 1; self.addTimerLabel.alpha = 1;
            } else {
                self.settingsButton.alpha = 0; self.settingsLabel.alpha = 0
            }
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
                if show {
                    self.addSectionButton.alpha = 1; self.addSectionLabel.alpha = 1
                } else {
                    self.addTimerButton.alpha = 0; self.addTimerLabel.alpha = 0
                }
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
                    if show {
                        self.settingsButton.alpha = 1; self.settingsLabel.alpha = 1
                    } else {
                        self.addSectionButton.alpha = 0; self.addSectionLabel.alpha = 0
                    }
                })
            })
        })
    }
}
