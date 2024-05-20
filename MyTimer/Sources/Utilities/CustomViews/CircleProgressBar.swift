//
//  CircleProgressBar.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import UIKit

/// Circle Progress Bar for timers
final class CircleProgressBar: BaseView {
    
    // MARK: Properties
    
    private let circleLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Configure
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    func setupProgressingAnimation(duration: Double) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        circularProgressAnimation.duration = duration
        circularProgressAnimation.fromValue = 0
        circularProgressAnimation.toValue = 1
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        
        progressLayer.add(circularProgressAnimation, forKey: "progressAnimation")
        progressLayer.speed = 0
    }
    
    func configureLayers() {
        setupLayers(layer: circleLayer, color: .gray1, end: 1)
        setupLayers(layer: progressLayer, color: .purple5, end: 0)
    }
    
    private func setupLayers(layer: CAShapeLayer, color: Colors, end: CGFloat) {
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
            radius: frame.size.width / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: CGFloat.pi * 3 / 2,
            clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.strokeColor = UIColor.CustomColor(color).cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = 20
        layer.strokeEnd = end
        
        self.layer.addSublayer(layer)
    }
    
    // MARK: Progressing Methods
    
    func startProgress() {
        progressLayer.speed = 1
    }
    
    func pauseLa(){
        let pauseTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0
        progressLayer.timeOffset = pauseTime
    }
    
    func resumeAnimation(){
        let pauseTime = progressLayer.timeOffset
        progressLayer.beginTime = 0
        progressLayer.speed = 1
        
        let timeSincePause = progressLayer.convertTime(
            CACurrentMediaTime(),
            from: nil) - pauseTime
        
        progressLayer.beginTime = timeSincePause
    }
    
    func reset() {
        progressLayer.removeAnimation(forKey: "progressAnimation")
    }
}
