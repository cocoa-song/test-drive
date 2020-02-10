//
//  File.swift
//  
//
//  Created by Simon Kim on 2020/01/05.
//

import UIKit

extension CAShapeLayer {
    
    convenience init(antsWithPath path: CGPath, color: UIColor = .black, lineDashPattern: [Int] = [6, 8]) {
        self.init()
        self.path = path
        self.strokeColor = color.cgColor
        self.fillColor = nil
        self.lineDashPattern = lineDashPattern as [NSNumber]
        
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.duration = 1.0
        animation.fromValue = 0
        animation.toValue = lineDashPattern.reduce(0) { $0 - $1 }
        animation.repeatCount = .infinity
        animation.autoreverses = false

        self.add(animation, forKey: "dash")
    }
    
    convenience init(strokeWithPath path: CGPath, color: UIColor) {
        self.init()
        self.path = path
        self.strokeColor = color.cgColor
        self.fillColor = nil
    }
}


private extension CGRect {
    var boundingPath: CGPath {
        UIBezierPath(rect: self).cgPath
    }
}

private extension CGPath {
    static var zero: CGPath {
        UIBezierPath(rect: CGRect.zero).cgPath
    }
}

public protocol MarchingAntsView {
    init(
        strokeColor: UIColor,
        antsColor: UIColor,
        lineDashPattern: [Int],
        markerWidth: CGFloat,
        rotateMarkerImage: UIImage,
        scaleMarkerImage: UIImage
    )
    func scale(to size: CGSize)
    func rotate(to angle: CGFloat)
    func move(to origin: CGPoint)
}

public final class MarchingAntsViewImpl: UIView {
    let markerWidth: CGFloat
    
    // cache
    var nextAngle: CGFloat = 0
    var nextSize: CGSize = .zero
    var nextOrigin: CGPoint = .zero
    
    // MARK: sublayers
    let strokeLayer: CAShapeLayer
    let antsLayer: CAShapeLayer
    let rotateMarkerLayer: CALayer
    let scaleMarkerLayer: CALayer
        
    public init(
        strokeColor: UIColor = .white,
        antsColor: UIColor = .black,
        lineDashPattern: [Int] = [6, 8],
        markerWidth: CGFloat = 10,
        rotateMarkerImage: UIImage,
        scaleMarkerImage: UIImage) {
        
        self.markerWidth = markerWidth
        strokeLayer = CAShapeLayer(strokeWithPath: .zero, color: strokeColor)
        antsLayer = CAShapeLayer(antsWithPath: .zero, color: antsColor, lineDashPattern: lineDashPattern)
        rotateMarkerLayer = MarchingAntsViewImpl.makeMarkerLayer(with: rotateMarkerImage)
        scaleMarkerLayer = MarchingAntsViewImpl.makeMarkerLayer(with: scaleMarkerImage)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func makeMarkerLayer(with image: UIImage) -> CALayer {
        let layer = CALayer()
        layer.contents = image.cgImage
        return layer
    }
    
    // MARK: life cycle
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        layer.addSublayer(strokeLayer)
        layer.addSublayer(antsLayer)
        layer.addSublayer(rotateMarkerLayer)
        layer.addSublayer(scaleMarkerLayer)
    }
                    
    private func setBoundingPath() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        rotateMarkerLayer.frame = CGRect(
            x: bounds.width - markerWidth / 2,
            y: -markerWidth / 2,
            width: markerWidth,
            height: markerWidth
        )
        scaleMarkerLayer.frame = CGRect(
            x: bounds.width - markerWidth / 2,
            y: bounds.height - markerWidth / 2,
            width: markerWidth,
            height: markerWidth
        )
        CATransaction.commit()
        
        strokeLayer.path = CGRect(origin: .zero, size: nextSize).boundingPath
        antsLayer.path = CGRect(origin: .zero, size: nextSize).boundingPath
    }
    
    private func performMutation() {
        self.center = nextOrigin
        self.bounds = CGRect(
            origin: .zero,
            size: nextSize
        )
        setBoundingPath()
        layer.setAffineTransform(CGAffineTransform(rotationAngle: nextAngle))
    }
}

extension MarchingAntsViewImpl: MarchingAntsView {
    public func rotate(to angle: CGFloat) {
        nextAngle = angle
        performMutation()
    }
    
    public func scale(to newSize: CGSize) {
        nextSize = newSize
        performMutation()
    }
    
    public func move(to origin: CGPoint) {
        nextOrigin = origin
        performMutation()
    }
}
