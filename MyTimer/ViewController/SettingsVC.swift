//
//  SettingsVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/07.
//

import UIKit
import SnapKit

// ViewController for settings
class SettingsVC: UIViewController {
    
    // MARK: - Create UI items
    lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.changeLabelStyle(
//            text: "알람 소리를 설정하세요!",
//            size: 20)
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.register(
            AlarmSoundCell.self,
            forCellReuseIdentifier: AlarmSoundCell.id)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.addTarget(
            self,
            action: #selector(okButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var subView: UIView = {
        let view = UIView()
        view.setupSubView()
        
        return view
    }()
    
    // MARK: - Property
    let viewModel = SettingsViewModel()
    var defaultAlarmIndex: IndexPath?
    
    // MARK: - Funcs for life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup UI
extension SettingsVC {
    func setupUI() {
        view.backgroundColor = .clear
        
        [
            tableView,
            titleLabel,
            okButton,
        ]
            .forEach { subView.addSubview($0) }
        
        view.addSubview(subView)
        
        subView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.top).offset(-20)
            $0.bottom.equalTo(okButton.snp.bottom).offset(20)
            $0.left.right.equalTo(tableView).inset(-20)
        }
        
        tableView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(250)
            $0.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(tableView.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(20)
            $0.centerX.equalTo(tableView)
            $0.width.equalTo(tableView)
        }
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int {
        viewModel.numOfSounds
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmSoundCell.id) as? AlarmSoundCell else {
            return UITableViewCell()
        }
        
        cell.updateUI(viewModel.sounds[indexPath.row])
        
        if cell.soundLabel.text == alarmSound {
            defaultAlarmIndex = indexPath
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            guard let cell = tableView.cellForRow(at: indexPath) as? AlarmSoundCell else {
                return
            }
            cell.checkButton.isSelected = true
            
            stopAudio()
            viewModel.changeAlarmSound(indexPath.row)
            playAudio(false)
            
            if let index = defaultAlarmIndex {
                tableView.reloadRows(at: [index], with: .none)
            }
        }
    
    func tableView(
        _ tableView: UITableView,
        didDeselectRowAt indexPath: IndexPath) {
            guard let cell = tableView.cellForRow(at: indexPath) as? AlarmSoundCell else {
                return
            }
            cell.checkButton.isSelected = false
        }
}

extension SettingsVC {
    @objc func okButtonTapped(_ sender: UIButton) {
        stopAudio()
        dismiss(animated: true)
    }
}
