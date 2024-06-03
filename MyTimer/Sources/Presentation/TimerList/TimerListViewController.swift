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
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<CellModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimerListCell.id, for: indexPath) as? TimerListCell else {
                    return UICollectionViewCell()
                }
                cell.setupBindings(timer: item) { [weak self] id in
                    self?.didTapTimerButtons(id)
                }
                
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TimerListHeaderView.id, for: indexPath) as? TimerListHeaderView else {
                    return UICollectionReusableView()
                }
                let section = dataSource.sectionModels[indexPath.section]
                header.setupBindings(section: section) { [weak self] type, id in
                    switch type {
                    case .Expand: self?.viewModel.changeSectionState(id: id)
                    case .Update: self?.didTapUpdateSectionButtons(id: id)
                    }
                }
                
                return header
            })
        
        let input = TimerListViewModel.Input(
            menuButtonTapEvent: timerListView.menuButton.rx.tap.asObservable(),
            addSectionButtonTapEvent: timerListView.addSectionButton.rx.tap.asObservable(),
            addTimerButtonTapEvent: timerListView.addTimerButton.rx.tap.asObservable(),
            settingsButtonTapEvent: timerListView.settingsButton.rx.tap.asObservable(),
            controlViewTapEvent: timerListView.controlView.rx.tapGesture().when(.recognized).map { _ in }.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.data
            .do(onNext: { [weak self] data in
                self?.displayNoTimersLabel(isEmpty: data.isEmpty)
            })
            .drive(timerListView.collectionView.rx.items(dataSource: dataSource))
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
        
        output.showButtons
            .emit(with: self, onNext: { owner, _ in
                owner.animateMenuButtons()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    
    // MARK: Update View
    
    private func displayNoTimersLabel(isEmpty: Bool) {
        timerListView.displayNoTimerLabel(isEmpty)
    }
    
    private func animateMenuButtons() {
        timerListView.animateButtons(duration: 0.05)
    }
    
    // MARK: Actions
    
    private func didTapMenuButtons(_ style: MenuButtonStyle) {
        let vc = switch style {
        case .Section: 
            AddSectionViewController(viewModel: AddSectionViewModel())
        case .Timer:
            UpdateTimerViewController(viewModel: UpdateTimerViewModel())
        default:
            UIViewController()
        }
        
        presentCustom(vc)
    }
    
    private func didTapUpdateSectionButtons(id: UUID) {
        let vc = UpdateSectionViewContoller(viewModel: UpdateSectionViewModel(id: id))
        presentCustom(vc)
    }
    
    private func didTapTimerButtons(_ timerID: UUID) {
//        let viewModel = DetailTimerViewModel(sectionTitle: title, sectionID: sectionID, timerID: timerID)
//        let vc = DetailTimerViewController(viewModel: viewModel)
//        presentCustom(vc)
    }

}
