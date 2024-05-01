//
//  TimerListView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/10.
//

import UIKit
import SnapKit
import Then

/// Enum for animations of menu buttons
enum ButtonAnimation {
    case First
    case Second
    case Third
}

/// View for TimerListViewController
final class TimerListView: BaseView {
    
    // MARK: UI
    
    lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        let width = UIScreen.main.bounds.width
        $0.itemSize = CGSize(width: width, height: 80)
        $0.headerReferenceSize = CGSize(width: width, height: 40)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.register(TimerListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TimerListHeaderView.id)
        $0.register(TimerListCell.self, forCellWithReuseIdentifier: TimerListCell.id)
    }

    lazy var notimerLabel = UILabel().then {
        $0.setLabelStyle(
            text: "아직 추가된 타이머가 없습니다!\n 타이머를 추가해주세요!",
            font: .medium,
            size: 18,
            color: UIColor.CustomColor(.gray3))
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    lazy var menuButton = UIButton().then {
        $0.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    lazy var addSectionButton = createButtons(.Section)
    lazy var addTimerButton = createButtons(.Timer)
    lazy var settingsButton = createButtons(.Settings)

    lazy var controlView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    // MARK: Properties
    
    private var isRotated = false

    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configure
    
    override func configureUI() {
        [
            addSectionButton,
            addTimerButton,
            settingsButton
        ]
            .forEach { controlView.addSubview($0) }

        [
            collectionView,
            menuButton,
            notimerLabel,
            controlView
        ]
            .forEach { addSubview($0) }
    }

    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(25)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.left.right.equalToSuperview().inset(15)
        }

        notimerLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        menuButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-35)
            $0.right.equalToSuperview().offset(-26)
        }

        addTimerButton.snp.makeConstraints {
            $0.bottom.equalTo(menuButton.snp.top).offset(-10)
            $0.trailing.equalTo(menuButton)
        }

        addSectionButton.snp.makeConstraints {
            $0.bottom.equalTo(addTimerButton.snp.top).offset(-10)
            $0.trailing.equalTo(menuButton)
        }

        settingsButton.snp.makeConstraints {
            $0.bottom.equalTo(addSectionButton.snp.top).offset(-10)
            $0.trailing.equalTo(menuButton)
        }

        controlView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Update UI
    
    func displayNoTimerLabel(_ show: Bool) {
        notimerLabel.isHidden = !show
    }
    
    func animateButtons(duration: TimeInterval) {
        rotateMenuButton()
        let show = isRotated
        
        let firstAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            self?.startAnimation(.First, show)
        }
        let secondAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            self?.startAnimation(.Second, show)
        }
        let thirdAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            self?.startAnimation(.Third, show)
        }
        
        firstAnimator.addCompletion { _ in
            secondAnimator.startAnimation()
        }
        secondAnimator.addCompletion { _ in
            thirdAnimator.startAnimation()
        }
        thirdAnimator.addCompletion { [weak self] _ in
            if !show { self?.displayControlView() }
        }
        
        if show { displayControlView() }
        firstAnimator.startAnimation()
    }
    
    private func rotateMenuButton() {
        let angle = isRotated ? 0 : Double.pi / 4
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.menuButton.transform = CGAffineTransform(rotationAngle: angle)
        }
        isRotated.toggle()
    }
    
    private func displayControlView() {
        controlView.isHidden.toggle()
    }
    
    private func startAnimation(_ animation: ButtonAnimation, _ show: Bool) {
        switch animation {
        case .First:
            if show { addTimerButton.alpha = 1 }
            else {settingsButton.alpha = 0 }
        case .Second:
            addSectionButton.alpha = show ? 1 : 0
        case .Third:
            if show { settingsButton.alpha = 1 }
            else { addTimerButton.alpha = 0 }
        }
    }
    
    // MARK: Create common UI components
    
    private func createButtons(_ buttons: MenuButtonStyle) -> UIButton {
        return UIButton().then {
            $0.setMainButtons(buttons)
        }
    }
    
}
