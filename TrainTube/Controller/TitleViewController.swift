//
//  TitleViewController.swift
//  TrainTube
//
//  Created by Kumie Miyata on 2020/11/08.
//

import UIKit
import Foundation
import WebKit

class TitleViewController: UIViewController {
    
    var timer:Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            let nextVC = TableViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
