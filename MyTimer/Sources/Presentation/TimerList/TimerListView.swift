//
//  TimerListView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/10.
//

import UIKit
import SnapKit
import Then

final class TimerListView: BaseView {
    
    // MARK: UI
    
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
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

    lazy var menuButton = UIButton().then {
        $0.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    lazy var addTimerButton = createButtons("timer")
    lazy var addSectionButton = createButtons("section")
    lazy var settingsButton = createButtons("settings")

    lazy var addSectionLabel = createLabels("섹션 추가")
    lazy var addTimerLabel = createLabels("타이머 추가")
    lazy var settingsLabel = createLabels("설정")

    lazy var backgroundView = UIView().then {
        $0.setBackgroundView()
        $0.isHidden = true
    }

    lazy var controlView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }

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
            settingsButton,
            addTimerLabel,
            addSectionLabel,
            settingsLabel,
        ]
            .forEach { controlView.addSubview($0) }

        [
            backgroundView,
            tableView,
            menuButton,
            goalLabel,
            notimerLabel,
            controlView,
        ]
            .forEach { addSubview($0) }
    }

    override func configureLayout() {
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

        menuButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-35)
            $0.right.equalToSuperview().offset(-26)
        }

        addTimerButton.snp.makeConstraints {
            $0.bottom.equalTo(menuButton.snp.top).offset(-10)
            $0.centerX.equalTo(menuButton)
        }

        addSectionButton.snp.makeConstraints {
            $0.bottom.equalTo(addTimerButton.snp.top).offset(-10)
            $0.centerX.equalTo(menuButton)
        }

        settingsButton.snp.makeConstraints {
            $0.bottom.equalTo(addSectionButton.snp.top).offset(-10)
            $0.centerX.equalTo(menuButton)
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
    
    // MARK: Create common UI components
    
    private func createButtons(_ title: String) -> UIButton {
        return UIButton().then {
            $0.setMainButtons(title)
        }
    }
    
    private func createLabels(_ title: String) -> UILabel {
        return UILabel().then {
            $0.setLabelStyle(
                text: title,
                font: .semibold,
                size: 14,
                color: .white)
            $0.alpha = 0
        }
    }
    
}
