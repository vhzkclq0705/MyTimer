//
//  CircleProgressBar.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import Foundation
import UIKit

class CircleProgressBar: UIView {
    
    // MARK: - Property
    var timerduration: TimeInterval?
    var circleLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    var startPoint = CGFloat(-Double.pi / 2)
    var endPoint = CGFloat(3 * Double.pi / 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup CircleProgressBar
    func createCircularPath() {
        // CircularPath for layer
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: 0, y: 0),
            radius: 150,
            startAngle: startPoint,
            endAngle: endPoint,
            clockwise: true)
        
        // Set circleLayer
        circleLayer.path = circularPath.cgPath
        circleLayer.strokeColor = UIColor.CustomColor(.gray1).cgColor
        setupLayerUI(layer: circleLayer, width: 20, end: 1)
        layer.addSublayer(circleLayer)
        
        // Set progressLayer
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.CustomColor(.purple5).cgColor
        setupLayerUI(layer: progressLayer, width: 20, end: 0)
        layer.addSublayer(progressLayer)
    }
    
    func setupLayerUI(layer: CAShapeLayer, width: CGFloat, end: CGFloat) {
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = width
        layer.strokeEnd = end
    }
    
    func progressAnimation(_ duration: TimeInterval) {
        // Create animation with KeyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        
        // Add animation to Layer
        progressLayer.add(circularProgressAnimation, forKey: "progressAnimation")
    }
    
    // MARK: - Funcs for when layer is in progress
    func pauseLayer(){
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
