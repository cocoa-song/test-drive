//
//  ViewController.swift
//  TestDrive
//
//  Created by cocoa on 2020/02/05.
//  Copyright © 2020 kinemaster. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var antView = MarchingAntsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(antView)
        antView.move(to: CGRect(x: 100, y: 100, width: 100, height: 100))
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    
}
