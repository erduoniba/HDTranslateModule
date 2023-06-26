//
//  HDExampleSwift.swift
//  HDFindStringDemo
//
//  Created by denglibing on 2023/6/14.
//

import Foundation
import UIKit

@objc class HDExample: NSObject {
    private let value = "hello"
    
    @objc func log() {
        print("Swift 中")
        print("Swift En")
        
        print("是为 中")
        
        let label = UILabel()
        label.text = "Hello"
        
        let label2 = UILabel()
        label2.text = "你好"
        
        let label3 = UILabel()
        label3.text = "Hello 你好"
    }
}
