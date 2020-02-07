//
//  File.swift
//  
//
//  Created by Simon Kim on 2020/01/05.
//

import UIKit

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

public final class MarchingAntsView: UIView {
    private let areaWidth: CGFloat = 50
    private let first: CAShapeLayer
    private let second: CAShapeLayer
    
    private lazy var rotateImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "pencil.circle"))
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var scaleImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "pencil.circle.fill"))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var initialCenter = CGPoint()
    lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture(_:)))

    init(strokeColor: UIColor = .white, antsColor: UIColor = .black, lineDashPattern: [Int] = [6, 8]) {
        first = CAShapeLayer(strokeWithPath: .zero, color: strokeColor)
        second = CAShapeLayer(antsWithPath: .zero, color: antsColor, lineDashPattern: lineDashPattern)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        layer.addSublayer(first)
        layer.addSublayer(second)
        
        addSubview(rotateImageView)
        addSubview(scaleImageView)
        
        addGestureRecognizer(panGestureRecognizer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        rotateImageView.frame = CGRect(
            x: self.frame.width - areaWidth / 2,
            y: -areaWidth / 2,
            width: areaWidth,
            height: areaWidth
        )
        scaleImageView.frame = CGRect(
            x: self.frame.width - areaWidth / 2,
            y: self.frame.height - areaWidth / 2,
            width: areaWidth,
            height: areaWidth
        )
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds, !isHidden, alpha > 0 else { return nil }
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }
        
        return super.hitTest(point, with: event)
    }
                
    func move(to rect: CGRect) {
        self.frame = rect
        first.path = bounds.boundingPath
        second.path = bounds.boundingPath
    }
    
    private func scale(scaleX: CGFloat, y: CGFloat) {
        layer.setAffineTransform(CGAffineTransform(scaleX: scaleX, y: y))
    }
    
    private func rotate(rotationAngle: CGFloat) {
        layer.setAffineTransform(CGAffineTransform(rotationAngle: rotationAngle))
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = gestureRecognizer.translation(in: piece.superview)
        if gestureRecognizer.state == .began {
           // Save the view's original position.
           self.initialCenter = piece.center
        }
           // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
           // Add the X and Y translation to the view's original position.
           let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
           piece.center = newCenter
        }
        else {
           // On cancellation, return the piece to its original location.
           piece.center = initialCenter
        }
        // TODO: (cocoa)
        
        let point = gestureRecognizer.location(in: self)
        
        if rotateImageView.frame.contains(point) {
            // TODO: (cocoa) 거리 -> rotationAngle: CGFloat
        }
        
        if scaleImageView.frame.contains(point) {
            // TODO: (cocoa) 거리 -> scaleX: CGFloat, y: CGFloat
        }
        
        
        print(#function)
    }
    
}
