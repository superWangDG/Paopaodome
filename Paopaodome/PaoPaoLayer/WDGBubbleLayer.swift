//  气泡的边框
//  WDGBubbleLayer.swift
//  Paopaodome
//
//  Created by 98data on 2019/10/12.
//  Copyright © 2019 98data. All rights reserved.
//

import Foundation
import UIKit

enum ArrowDirection: Int {
    case right = 0
    case bottom
    case left
    case top
}

class WDGBubbleLayer : NSObject {
    // 矩形的半径
    var cornerRadius:CGFloat = 0
    // 箭头的圆角半径
    var arrowRadius:CGFloat = 0
    // 箭头高度
    var arrowHeight:CGFloat = 0
    // 箭头宽度
    var arrowWidth:CGFloat = 0
    // 箭头位置
    var arrowDirection:ArrowDirection = .right
    // 箭头相对位置
    var arrowPosition:CGFloat = 0
    // mask成气泡弹框的view的size
    private var size:CGSize = CGSize.zero
    
    /// mask成气泡弹框的view的size
    init(originalSize:CGSize) {
        super.init()
        self.setDefaultProperty()
        
        self.size = originalSize
    }
    
    func layer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = self.bubblePath()
        return layer
    }
    
    func setDefaultProperty() {
        self.cornerRadius = 8
        self.arrowWidth = 30
        self.arrowHeight = 12
        self.arrowDirection = .right
        self.arrowPosition = 0.5
        self.arrowRadius = 2
    }
    
    func bubblePath() -> CGPath {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let path = CGMutablePath()
        // 获取绘图所需要的关键点
        let points = self.keyPoints()
        
        let currentPoint = points.object(at: 6) as! CGPoint
        path.move(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
        
        var pointA = CGPoint.zero,pointB = CGPoint.zero
        var radius:CGFloat = 0
        var count = 0
        while count < 7 {
            // 整个过程需要画七个圆角，所以分为七个步骤
            radius = count < 3 ?  arrowRadius : cornerRadius;
            pointA = points.object(at: count) as! CGPoint
            pointB = points.object(at: (count+1) % 7) as! CGPoint
            path.addArc(tangent1End: pointA, tangent2End: pointB, radius: radius)
            count = count + 1
        }
        path.closeSubpath()
        UIGraphicsEndImageContext()
        return path
    }
    
    // 初始化数据
    func keyPoints() -> NSMutableArray {
        let points = NSMutableArray()
        
        // 确定箭头的三个点
        var beginPoint = CGPoint.zero
        var topPoint = CGPoint.zero
        var endPoint = CGPoint.zero
        
        // 箭头顶点topPoint的X坐标(或Y坐标)的范围（用来计算arrowPosition）
        let tpXRange:CGFloat = self.size.width -  2 * self.cornerRadius - arrowWidth
        let tpYRange:CGFloat = self.size.height -  2 * self.cornerRadius - arrowWidth
        
        // 矩形框左上角的坐标
        var x:CGFloat = 0,y:CGFloat = 0
        //矩形框的大小
        var width = self.size.width, height = self.size.height
        
         // 计算箭头的位置，以及调整矩形框的位置和大小
        switch self.arrowDirection {
            case .right:
                topPoint = CGPoint(x: size.width, y: size.height / 2.0 + tpYRange * (arrowPosition - 0.5))
                beginPoint = CGPoint(x: topPoint.x - arrowHeight , y: topPoint.y - arrowWidth / 2.0)
                endPoint = CGPoint(x: beginPoint.x, y: beginPoint.y + arrowWidth)
                
                width -= arrowHeight
                break
            case .bottom:
                topPoint = CGPoint(x: size.width / 2 + tpXRange * (arrowPosition - 0.5), y: size.height )
                beginPoint = CGPoint(x: topPoint.x + arrowWidth / 2.0 , y: topPoint.y - arrowHeight)
                endPoint = CGPoint(x: beginPoint.x - arrowWidth, y: beginPoint.y)
                
                height -= arrowHeight
                break
            case .left:
                topPoint = CGPoint(x: 0, y: size.height / 2.0 + tpYRange * (arrowPosition - 0.5))
                beginPoint = CGPoint(x: topPoint.x + arrowHeight , y: topPoint.y + arrowWidth / 2.0)
                endPoint = CGPoint(x: beginPoint.x, y: beginPoint.y - arrowWidth)
                
                x = arrowHeight
                width -= arrowHeight
                break
            case .top:
                topPoint = CGPoint(x: size.width / 2 + tpXRange * (arrowPosition - 0.5), y: 0 )
                beginPoint = CGPoint(x: topPoint.x - arrowWidth / 2.0 , y: topPoint.y + arrowHeight)
                endPoint = CGPoint(x: beginPoint.x + arrowWidth, y: beginPoint.y)
                
                y = arrowHeight
                height -= arrowHeight
                break
        }
        
        points.add(beginPoint)
        points.add(topPoint)
        points.add(endPoint)
        
        let bottomRight = CGPoint(x: x + width, y: y + height)
        let bottomLeft = CGPoint(x: x , y: y + height)
        let topLeft = CGPoint(x: x , y: y )
        let topRight = CGPoint(x: x + width, y: y)
        
        let rectPoints = NSMutableArray(objects: bottomRight,bottomLeft,topLeft,topRight)
        
        var rectPointIndex = self.arrowDirection.rawValue
        
        for _ in 0..<4 {
            points.add(rectPoints.object(at: rectPointIndex))
            rectPointIndex = (rectPointIndex + 1) % 4
        }
        
        return points
    }
    
}
