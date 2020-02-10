//
//  ViewController.swift
//  TestDrive
//
//  Created by cocoa on 2020/02/05.
//  Copyright © 2020 kinemaster. All rights reserved.
//

import UIKit
import MarchingAnts

class ViewController: UIViewController {
    lazy var antView = MarchingAntsViewImpl(
        rotateMarkerImage: UIImage(systemName: "pencil.circle")!,
        scaleMarkerImage: UIImage(systemName: "pencil.circle.fill")!
    )
    
    var sizeCache: CGSize = .zero
    var angleCache: CGFloat = .zero
    var originCache: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(antView)
        
        let initOrigin = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        antView.move(to: initOrigin)
        originCache = initOrigin
        
        let initSize = CGSize(width: 100, height: 100)
        antView.scale(to: initSize)
        sizeCache = initSize
        
        let initAngle: CGFloat = 0
        antView.rotate(to: initAngle)
        angleCache = initAngle
    }
    
    @IBAction func scale(_ sender: UIButton) {
        let newSize = CGSize(
            width: sizeCache.width + 10,
            height: sizeCache.height + 10
        )
        antView.scale(to: newSize)
        sizeCache = newSize
    }

    @IBAction func rotate(_ sender: Any) {
        let newAngle = angleCache + 0.1
        antView.rotate(to: newAngle)
        angleCache = newAngle
    }
    
    @IBAction func move(_ sender: Any) {
        let newOrigin = CGPoint(
            x: originCache.x + CGFloat.random(in: -10...10),
            y: originCache.y + CGFloat.random(in: -10...10)
        )
        antView.move(to: newOrigin)
        originCache = newOrigin
    }

}

extension ViewController: UIGestureRecognizerDelegate {
    
}
