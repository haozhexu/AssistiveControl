//
//  ViewController.swift
//  AssistiveSample
//
//  Created by Haozhe XU on 18/2/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collapsedView = UIView(frame: CGRect(x: 50, y: 100, width: 40, height: 40))
        collapsedView.backgroundColor = .red
        
        let expandedView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        expandedView.backgroundColor = .orange
        
        let _ = AssistiveControl.create(in: self.view, collapsedView: collapsedView, expandedView: expandedView)
    }

}

