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
    }
    
    // MARK: Configure
    
    override func configureViewController() {
        setupBindings()
    }
    
    private func setupBindings() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<RxSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimerListCell.id, for: indexPath) as? TimerListCell else {
                    return UICollectionViewCell()
                }
                let timer = dataSource.sectionModels[indexPath.section].items[indexPath.item]
                cell.updateUI(timer: timer)
                
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TimerListHeaderView.id, for: indexPath) as? TimerListHeaderView else {
                    return UICollectionReusableView()
                }
                header.updateUI(text: dataSource.sectionModels[indexPath.section].title)
                
                header.expandButtonTapHandler
                    .subscribe(with: self, onNext: { owner, _ in
                        
                    })
                    .disposed(by: header.disposeBag)
                
                header.modifyButtonTapHandler
                    .subscribe(with: self, onNext: { owner, _ in
                        
                    })
                    .disposed(by: header.disposeBag)
                
                return header
            }
        )
        
        let input = TimerListViewModel.Input(
            menuButtonTapEvent: timerListView.menuButton.rx.tap.asObservable(),
            addSectionButtonTapEvent: timerListView.addSectionButton.rx.tap.asObservable(),
            addTimerButtonTapEvent: timerListView.addTimerButton.rx.tap.asObservable(),
            settingsButtonTapEvent: timerListView.settingsButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .drive(timerListView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.showButtons
            .emit(with: self, onNext: { owner, _ in
                owner.changeStateOfMenuButtons()
            })
            .disposed(by: disposeBag)
        
        output.presentAddSectionViewController
            .emit(with: self, onNext: { owner, _ in
                owner.didTapMenuButtons(.Section)
            })
            .disposed(by: disposeBag)
        
        output.presentAddTimerViewController
            .emit(with: self, onNext: { owner, _ in
                owner.didTapMenuButtons(.Timer)
            })
            .disposed(by: disposeBag)
        
        output.presentSettingsViewController
            .emit(with: self, onNext: { owner, _ in
                owner.didTapMenuButtons(.Settings)
            })
            .disposed(by: disposeBag)
        
        timerListView.controlView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self, onNext: { owner, _ in
                owner.changeStateOfMenuButtons()
            })
            .disposed(by: disposeBag)
    }
    
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
    
//    @objc func addTimerButtonTapped(_ sender: UIButton) {
//        let vc = AddTimerVC()
//        
//        presentCustom(vc)
//    }
//    
//    @objc func addSectionButtonTapped(_ sender: UIButton) {
//        let vc = AddSectionVC()
//        
//        presentCustom(vc)
//    }
//    
//    @objc func settingsButtonTapped(_ sender: UIButton) {
//        let vc = SettingsVC()
//        vc.goal = timerListView.goalLabel.text!
//        
//        presentCustom(vc)
//    }
    
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
    
    // MARK: Actions
    
    private func changeStateOfMenuButtons() {
        timerListView.menuButton.isSelected.toggle()
        animate(show: timerListView.menuButton.isSelected, duration: 0.05)
    }
    
    private func didTapMenuButtons(_ style: MenuButtonStyle) {
        let vc = switch style {
        case .Section: 
            AddSectionViewController(viewModel: AddSectionViewModel())
        default: 
            UIViewController()
        }
        
        presentCustom(vc)
    }
    
    // MARK: Button Animations
    
    private func animate(show: Bool, duration: TimeInterval) {
        let firstAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            self?.firstAnimation(show)
        }
        let secondAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            self?.secondAnimation(show)
        }
        let thirdAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            self?.thirdAnimation(show)
        }
        
        firstAnimator.addCompletion { _ in
            secondAnimator.startAnimation()
        }
        secondAnimator.addCompletion { _ in
            thirdAnimator.startAnimation()
        }
        thirdAnimator.addCompletion { [weak self] _ in
            if !show { self?.timerListView.controlView.isHidden = true }
        }
        
        if show { timerListView.controlView.isHidden = false }
        firstAnimator.startAnimation()
    }
    
    private func firstAnimation(_ show: Bool) {
        if show { timerListView.addTimerButton.alpha = 1 }
        else { timerListView.settingsButton.alpha = 0 }
        
        timerListView.menuButton.transform = CGAffineTransform(
            rotationAngle: show ? Double.pi : 0)
    }
    
    private func secondAnimation(_ show: Bool) {
        timerListView.addSectionButton.alpha = show ? 1 : 0
    }
    
    private func thirdAnimation(_ show: Bool) {
        if show { timerListView.settingsButton.alpha = 1 }
        else { timerListView.addTimerButton.alpha = 0 }
    }

}
