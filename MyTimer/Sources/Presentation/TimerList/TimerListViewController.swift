//
//  TimerListViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

// ViewController for timer list
final class TimerListViewController: BaseViewController {
    
    // MARK: Properties
    
    private let viewModel: TimerListViewModel
    private let timerListView = TimerListView()
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: TimerListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func loadView() {
        super.loadView()
        view = timerListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setController()
//        loadAlarmSound()
//        checkTimerCount()
//        setGoal()
//        requestAuthNoti()
//        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(reload),
//            name: NSNotification.Name(rawValue: "reload"),
//            object: nil)
    }
    
    // MARK: Configure
    
    override func configureViewController() {
        setupBindings()
    }
    
    private func setupBindings() {
        let input = TimerListViewModel.Input(
            menuButtonTapEvent: timerListView.menuButton.rx.tap.asObservable(),
            addSectionButtonTapEvent: timerListView.addSectionButton.rx.tap.asObservable(),
            addTimerButtonTapEvent: timerListView.addTimerButton.rx.tap.asObservable(),
            settingsButtonTapEvent: timerListView.settingsButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.showButtons
            .emit(onNext: {
                // Button Up Animation
            })
            .disposed(by: disposeBag)
        
        output.presentAddSectionViewController
            .emit(onNext: {
                // Present AddSection
            })
            .disposed(by: disposeBag)
        
        output.presentAddTimerViewController
            .emit(onNext: {
                // Present AddTimer
            })
            .disposed(by: disposeBag)
        
        output.presentSettingsViewController
            .emit(onNext: {
                // Present Settings
            })
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<RxSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerListHeaderCell.id) as? TimerListHeaderCell else {
                    return UITableViewCell()
                }
                cell.updateUI(text: item.title)
                
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].title
            }
        )
        
        output.sections
            .drive(timerListView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup
//    func setController() {
//        timerListView.tableView.delegate = self
//        timerListView.tableView.dataSource = self
//        
//        timerListView.addButton.addTarget(
//            self,
//            action: #selector(addButtonTapped(_:)),
//            for: .touchUpInside
//        )
//        timerListView.addTimerButton.addTarget(
//            self,
//            action: #selector(addTimerButtonTapped(_:)),
//            for: .touchUpInside)
//        timerListView.addSectionButton.addTarget(
//            self,
//            action: #selector(addSectionButtonTapped(_:)),
//            for: .touchUpInside)
//        timerListView.settingsButton.addTarget(
//            self,
//            action: #selector(settingsButtonTapped(_:)),
//            for: .touchUpInside)
//        timerListView.recognizeTapGesture.addTarget(
//            self,
//            action: #selector(recognizeTapped(_:)))
//    }
    
    func setGoal() {
        let basic = "자신의 각오 한 마디를 입력해주세요"
        if let goal = UserDefaults.standard.string(forKey: "goal") {
            timerListView.goalLabel.text = goal
            timerListView.goalLabel.textColor = goal == basic
            ? UIColor.CustomColor(.gray1)
            : UIColor.CustomColor(.purple5)
        } else {
            timerListView.goalLabel.text = basic
            timerListView.goalLabel.textColor = UIColor.CustomColor(.gray1)
        }
    }
    
//    func checkTimerCount() {
//        timerListView.notimerLabel.isHidden = viewModel.numOfSections == 0
//        ? false : true
//    }
//    
//    // MARK: - Actions
//    @objc func reload() {
//        viewModel.load()
//        setGoal()
//        checkTimerCount()
//        timerListView.tableView.reloadData()
//    }
//    
//    @objc func recognizeTapped(_ sender: Any) {
//        timerListView.addButton.isSelected = false
//        displayButtons(false)
//    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        displayButtons(sender.isSelected)
    }
    
    @objc func addTimerButtonTapped(_ sender: UIButton) {
        let vc = AddTimerVC()
        
        presentCustom(vc)
    }
    
    @objc func addSectionButtonTapped(_ sender: UIButton) {
        let vc = AddSectionVC()
        
        presentCustom(vc)
    }
    
    @objc func settingsButtonTapped(_ sender: UIButton) {
        let vc = SettingsVC()
        vc.goal = timerListView.goalLabel.text!
        
        presentCustom(vc)
    }
    
//    func popupSetSection(_ index: Int) {
//        let vc = SetSectionVC()
//        vc.section = viewModel.sections[index]
//        
//        presentCustom(vc)
//    }
//    
//    func popupDetailTimer(_ indexPath: IndexPath) {
//        let vc = DetailTimerVC()
//        vc.sectionTitle = viewModel.sectionTitle(indexPath.section)
//        vc.myTimer = viewModel.timerInfo(indexPath)
//        
//        presentCustom(vc)
//    }
    
    // MARK: - Button Animations
    func displayButtons(_ show: Bool) {
        animate(show: show, duration: 0.05)
    }
    
    func changeView(_ show: Bool) {
        timerListView.controlView.isHidden = !show
        timerListView.backgroundView.isHidden = !show
    }
    
    func animate(show: Bool, duration: TimeInterval) {
        if show { self.changeView(show) }
        UIView.animate(
            withDuration: duration,
            animations: { self.firstAnimation(show) }) { _ in
                UIView.animate(
                    withDuration: duration,
                    animations: { self.secondAnimation(show) }) { _ in
                        UIView.animate(
                            withDuration: duration,
                            animations: { self.thirdAnimation(show) }) { _ in
                                if !show { self.changeView(show) }
                            }
                    }
            }
    }
    
    func firstAnimation(_ show: Bool) {
        let angle: CGFloat
        
        if show {
            [
                timerListView.addTimerButton,
                timerListView.addTimerLabel,
            ]
                .forEach { $0.alpha = 1 }
            
            angle = Double.pi / 4
        }
        else {
            [
                timerListView.settingsButton,
                timerListView.settingsLabel,
            ]
                .forEach { $0.alpha = 0 }
            
            angle = 0
        }
        
        timerListView.menuButton.transform = CGAffineTransform(
            rotationAngle: angle)
    }
    
    func secondAnimation(_ show: Bool) {
        [
            timerListView.addSectionButton,
            timerListView.addSectionLabel
        ]
            .forEach { $0.alpha = show ? 1 : 0 }
    }
    
    func thirdAnimation(_ show: Bool) {
        show
        ? [
            timerListView.settingsButton,
            timerListView.settingsLabel
        ]
            .forEach { $0.alpha = 1 }
        : [timerListView.addTimerButton,
           timerListView.addTimerLabel
        ]
            .forEach { $0.alpha = 0 }
    }
}

// MARK: - TableView
//extension TimerListViewController: ExpyTableViewDelegate,
//                       ExpyTableViewDataSource {
//    // true = Expandable, false = Non-Expandable(Same as default TableView)
//    func tableView(
//        _ tableView: ExpyTableView,
//        canExpandSection section: Int)
//    -> Bool {
//        return true
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.numOfSections
//    }
//    
//    func tableView(
//        _ tableView: UITableView,
//        numberOfRowsInSection section: Int)
//    -> Int {
//        return viewModel.numOfTimers(section) + 1
//    }
//    
//    // About Section headers
//    func tableView(
//        _ tableView: ExpyTableView,
//        expandableCellForSection section: Int)
//    -> UITableViewCell {
//        guard let header = tableView.dequeueReusableCell(withIdentifier: TimerListHeaderCell.id) as? TimerListHeaderCell else {
//            return UITableViewCell()
//        }
//        let title = viewModel.sectionTitle(section)
//        
//        header.updateUI(text: title)
//        header.modifyButtonTapHandler = {
//            self.popupSetSection(section)
//        }
//        
//        return header
//    }
//    
//    func tableView(
//        _ tableView: UITableView,
//        cellForRowAt indexPath: IndexPath)
//    -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerListCell.id) as? TimerListCell else {
//            return UITableViewCell()
//        }
//        let timer = viewModel.timerInfo(indexPath)
//        
//        cell.updateUI(
//            title: timer.title,
//            min: timer.min,
//            sec: timer.sec)
//        cell.timerButtonTapHandler = {
//            self.popupDetailTimer(indexPath)
//        }
//        
//        return cell
//    }
//    
//    func tableView(
//        _ tableView: UITableView,
//        heightForRowAt indexPath: IndexPath)
//    -> CGFloat {
//        return indexPath.row == 0 ? 25 : 80
//    }
//    
//    // Check whether the Section is open or closed.
//    func tableView(
//        _ tableView: ExpyTableView,
//        expyState state: ExpyState,
//        changeForSection section: Int) {
//            // This function is only a stub.
//        }
//}
