//
//  CircleProgressBar.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import Foundation
import UIKit

class CircleProgressBar: UIView {
    
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
    
    func createCircularPath(_ color: UIColor) {
        // CircularPath for layer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 150, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        // Set circleLayer
        circleLayer.path = circularPath.cgPath
        setupLayerUI(layer: circleLayer, width: 20, end: 1, color: color)
        layer.addSublayer(circleLayer)
        
        // Set progressLayer
        progressLayer.path = circularPath.cgPath
        setupLayerUI(layer: progressLayer, width: 20, end: 0, color: .lightGray)
        layer.addSublayer(progressLayer)
    }
    
    func setupLayerUI(layer: CAShapeLayer, width: CGFloat, end: CGFloat, color: UIColor) {
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = width
        layer.strokeEnd = end
        layer.strokeColor = color.cgColor
    }
    
    func progressAnimation(_ duration: TimeInterval) {
        // Create animation with KeyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        
        progressLayer.add(circularProgressAnimation, forKey: "progressAnimation")
    }
    
    func pauseLayer(){
        let pauseTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0
        progressLayer.timeOffset = pauseTime
    }
    
    func resumeAnimation(){
        let pauseTime = progressLayer.timeOffset
        progressLayer.beginTime = 0
        progressLayer.speed = 1
        
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        
        progressLayer.beginTime = timeSincePause
    }
    
    func reset() {
        progressLayer.removeAnimation(forKey: "progressAnimation")
    }
}
