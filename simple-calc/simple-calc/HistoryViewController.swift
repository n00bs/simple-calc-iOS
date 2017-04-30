//
//  HistoryViewController.swift
//  simple-calc
//
//  Created by Abhishek Chauhan on 4/29/17.
//  Copyright © 2017 Abhishek Chauhan. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var list: UIScrollView!
    var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0..<data.count {
            let item = UILabel(frame: CGRect(x: 0, y: index * 30, width: Int(list.bounds.size.width), height: 31))
            item.textAlignment = .right
            item.textColor = UIColor.black
            item.text = data[index]
            list.addSubview(item)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! ViewController
        viewController.historyList = data
    }
    
}
