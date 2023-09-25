//
//  PieChartView.swift
//  Graph-iOS
//
//  Created by Chang-Hoon Han on 2020/07/28.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit

/**
 * Pie Chart 그리기
 * https://zeddios.tistory.com/823
 * https://zeddios.tistory.com/824?category=682195
 * https://www.tnoda.com/blog/2019-06-18/
 */
@IBDesignable
class PieChartView: UIView {
    
    class PieChartModel {
        var value: CGFloat = 0.0
        var color: UIColor = .clear
        var obj: Any?
        
        public init() {}

        public init(value: CGFloat, color: UIColor, obj: Any? = nil) {
            self.value = value
            self.color = color
            self.obj = obj
        }
        
        public var description: String {
            return "{value: \(value), obj: \(String(describing: obj))}"
        }
    }
    @IBInspectable var border: CGFloat = 20
    @IBInspectable var stroke: CGFloat = 3
    
    var models: [PieChartModel] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        if models.count > 0 {
            
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.size.width, rect.size.height) / 2
            
            var total: CGFloat = 0
            models.forEach { (model) in
                total += model.value
            }
            var startAngle: CGFloat = (-(.pi) / 2)
            var endedAngle: CGFloat = 0.0
            
            models.forEach { (model) in
                
                endedAngle = (model.value / total) * (.pi * 2)
                
                let path = UIBezierPath()
                path.move(to: center)
                path.addArc(withCenter: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: startAngle + endedAngle,
                            clockwise: true)
                
                model.color.set()
                path.fill()
                startAngle += endedAngle
                path.close()
                
                UIColor.white.set()
                path.lineWidth = stroke
                path.stroke()
            }
            
            let circle = UIBezierPath(arcCenter: center,
                                      radius: radius - border,
                                      startAngle: 0,
                                      endAngle: (360 * .pi) / 180,
                                      clockwise: true)
            UIColor.white.set()
            circle.fill()
        }
    }

}
