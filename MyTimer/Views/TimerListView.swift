////
////  TimerListView.swift
////  MyTimer
////
////  Created by 권오준 on 2022/07/10.
////
//
//import UIKit
//import SnapKit
//import ExpyTableView
//
//class TimerListView: UIView {
//    // MARK: - UI
//    lazy var tableView: ExpyTableView = {
//        let tableView = ExpyTableView(
//            frame: .zero,
//            style: .insetGrouped)
//        
//        tableView.register(
//            TimerListHeaderCell.self,
//            forCellReuseIdentifier: TimerListHeaderCell.id)
//        tableView.register(
//            TimerListCell.self,
//            forCellReuseIdentifier: TimerListCell.id)
//        
//        tableView.expandingAnimation = .fade
//        tableView.collapsingAnimation = .fade
//        tableView.backgroundColor = .clear
//        tableView.separatorStyle = .none
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        return tableView
//    }()
//    
//    var goalLabel: UILabel = {
//        let label = UILabel()
//        label.setLabelStyle(
//            text: "자신의 각오 한마디를 입력해주세요!",
//            font: .bold,
//            size: 23,
//            color: UIColor.CustomColor(.gray2))
//        label.numberOfLines = 0
//        
//        return label
//    }()
//    
//    let notimerLabel: UILabel = {
//        let label = UILabel()
//        label.setLabelStyle(
//            text: "아직 추가된 타이머가 없습니다!\n 타이머를 추가해주세요!",
//            font: .medium,
//            size: 18,
//            color: UIColor.CustomColor(.gray3))
//        label.alpha = 0
//        label.textAlignment = .center
//        label.numberOfLines = 2
//        
//        return label
//    }()
//    
//    lazy var addButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "add")?
//            .withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(
//            self,
//            action: #selector(addButtonTapped(_:)),
//            for: .touchUpInside
//        )
//        
//        return button
//    }()
//    
//    lazy var addTimerButton: UIButton = {
//        let button = UIButton()
//        button.setMainButtons("timer")
//        button.addTarget(
//            self,
//            action: #selector(addTimerButtonTapped(_:)),
//            for: .touchUpInside)
//        
//        return button
//    }()
//    
//    lazy var addSectionButton: UIButton = {
//        let button = UIButton()
//        button.setMainButtons("section")
//        button.addTarget(
//            self,
//            action: #selector(addSectionButtonTapped(_:)),
//            for: .touchUpInside)
//        
//        return button
//    }()
//    
//    lazy var settingsButton: UIButton = {
//        let button = UIButton()
//        button.setMainButtons("settings")
//        button.addTarget(
//            self,
//            action: #selector(settingsButtonTapped(_:)),
//            for: .touchUpInside)
//        
//        return button
//    }()
//    
//    let addSectionLabel: UILabel = {
//        let label = UILabel()
//        label.setLabelStyle(
//            text: "섹션 추가",
//            font: .semibold,
//            size: 14,
//            color: .white)
//        label.alpha = 0
//        
//        return label
//    }()
//    
//    let addTimerLabel: UILabel = {
//        let label = UILabel()
//        label.setLabelStyle(
//            text: "타이머 추가",
//            font: .semibold,
//            size: 14,
//            color: .white)
//        label.alpha = 0
//        
//        return label
//    }()
//    
//    let settingsLabel: UILabel = {
//        let label = UILabel()
//        label.setLabelStyle(
//            text: "설정",
//            font: .semibold,
//            size: 14,
//            color: .white)
//        label.alpha = 0
//        
//        return label
//    }()
//    
//    let backgroundView: UIView = {
//        let view = UIView()
//        view.setBackgroundView()
//        view.isHidden = true
//        
//        return view
//    }()
//    
//    let controlView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        view.isHidden = true
//        
//        return view
//    }()
//    
//    lazy var recognizeTapGesture: UITapGestureRecognizer = {
//        let gesture = UITapGestureRecognizer()
//        gesture.addTarget(self, action: #selector(recognizeTapped(_:)))
//        
//        return gesture
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        setLayout()
//    }
//    
//    func addViews() {
//        backgroundColor = .white
//        
//        [
//            addSectionButton,
//            addTimerButton,
//            settingsButton,
//            addTimerLabel,
//            addSectionLabel,
//            settingsLabel,
//        ]
//            .forEach { controlView.addSubview($0) }
//        
//        controlView.addGestureRecognizer(recognizeTapGesture)
//        
//        [
//            backgroundView,
//            tableView,
//            addButton,
//            goalLabel,
//            notimerLabel,
//            controlView,
//        ]
//            .forEach { addSubview($0) }
//    }
//    
//    func setLayout() {
//        backgroundView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        tableView.snp.makeConstraints {
//            $0.top.equalTo(goalLabel.snp.bottom)
//            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
//            $0.left.right.equalToSuperview()
//        }
//        
//        goalLabel.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide).offset(22)
//            $0.left.right.equalToSuperview().inset(17)
//        }
//        
//        notimerLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
//        
//        addButton.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(-35)
//            $0.right.equalToSuperview().offset(-26)
//        }
//        
//        addTimerButton.snp.makeConstraints {
//            $0.bottom.equalTo(addButton.snp.top).offset(-10)
//            $0.centerX.equalTo(addButton)
//        }
//        
//        addSectionButton.snp.makeConstraints {
//            $0.bottom.equalTo(addTimerButton.snp.top).offset(-10)
//            $0.centerX.equalTo(addButton)
//        }
//        
//        settingsButton.snp.makeConstraints {
//            $0.bottom.equalTo(addSectionButton.snp.top).offset(-10)
//            $0.centerX.equalTo(addButton)
//        }
//        
//        addTimerLabel.snp.makeConstraints {
//            $0.centerY.equalTo(addTimerButton)
//            $0.right.equalTo(addTimerButton.snp.left).offset(-9)
//        }
//        
//        addSectionLabel.snp.makeConstraints {
//            $0.centerY.equalTo(addSectionButton)
//            $0.right.equalTo(addTimerLabel)
//        }
//        
//        settingsLabel.snp.makeConstraints {
//            $0.centerY.equalTo(settingsButton)
//            $0.right.equalTo(addTimerLabel)
//        }
//        
//        controlView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//}
