//
//  TimerListView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/10.
//

import UIKit
import ExpyTableView
import RxSwift
import SnapKit
import Then

final class TimerListView: UIView {
    
    // MARK: UI
    
    lazy var tableView = ExpyTableView(frame: .zero, style: .insetGrouped).then {
        $0.expandingAnimation = .fade
        $0.collapsingAnimation = .fade
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        
        $0.register(TimerListHeaderCell.self, forCellReuseIdentifier: TimerListHeaderCell.id)
        $0.register(TimerListCell.self, forCellReuseIdentifier: TimerListCell.id)
    }

    lazy var goalLabel = UILabel().then {
        $0.setLabelStyle(
            text: "자신의 각오 한마디를 입력해주세요!",
            font: .bold,
            size: 23,
            color: UIColor.CustomColor(.gray2))
        $0.numberOfLines = 0
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

    lazy var addButton = UIButton().then {
        $0.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    lazy var addTimerButton = UIButton().then {
        $0.setMainButtons("timer")
    }

    lazy var addSectionButton = UIButton().then {
        $0.setMainButtons("section")
    }

    lazy var settingsButton = UIButton().then {
        $0.setMainButtons("settings")
    }

    lazy var addSectionLabel = UILabel().then {
        $0.setLabelStyle(
            text: "섹션 추가",
            font: .semibold,
            size: 14,
            color: .white)
        $0.alpha = 0
    }

    lazy var addTimerLabel = UILabel().then {
        $0.setLabelStyle(
            text: "타이머 추가",
            font: .semibold,
            size: 14,
            color: .white)
        $0.alpha = 0
    }

    lazy var settingsLabel = UILabel().then {
        $0.setLabelStyle(
            text: "설정",
            font: .semibold,
            size: 14,
            color: .white)
        $0.alpha = 0
    }

    let backgroundView: UIView = {
        let view = UIView()
        view.setBackgroundView()
        view.isHidden = true

        return view
    }()

    let controlView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true

        return view
    }()

    let recognizeTapGesture = UITapGestureRecognizer()

    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        setLayout()
    }

    // MARK: Configure
    
    private func addViews() {
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
            backgroundView,
            tableView,
            addButton,
            goalLabel,
            notimerLabel,
            controlView,
        ]
            .forEach { addSubview($0) }
    }

    func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.left.right.equalToSuperview()
        }

        goalLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(22)
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
}
