//
//  ViewController.swift
//  AssistiveSample
//
//  Created by Haozhe XU on 18/2/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var parkingBehaviorControl: UISegmentedControl!
    
    var control: AssistiveControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collapsedView = UIView(frame: CGRect(x: 50, y: 100, width: 40, height: 40))
        collapsedView.backgroundColor = .red
        
        let expandedView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        expandedView.backgroundColor = .orange
        
        self.control = AssistiveControl.create(in: self.view, collapsedView: collapsedView, expandedView: expandedView)
        control.delegate = self
    }
    
    @IBAction func parkingBehaviorControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.control.parkingBehavior = .stickyEdge
        } else {
            self.control.parkingBehavior = .freestyle
        }
    }

}

extension ViewController: AssistiveControlDelegate {
    
    func assistiveControlDidMove(_ assistiveControl: AssistiveControl) {
        self.label.text = "Assistive control did move"
    }
    
    func assistiveControlWillExpand(_ assistiveControl: AssistiveControl) {
    }
    
    func assistiveControlDidExpand(_ assistiveControl: AssistiveControl) {
        self.label.text = "Assistive control expanded"
    }
    
    func assistiveControlWillCollapse(_ assistiveControl: AssistiveControl) {
    }
    
    func assistiveControlDidCollapse(_ assistiveControl: AssistiveControl) {
        self.label.text = "Assistive control collapsed"
    }
}

