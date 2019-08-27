//
//  ViewController.swift
//  RCBacktraceDemo
//
//  Created by roy.cao on 2019/8/27.
//  Copyright © 2019 roy. All rights reserved.
//

import UIKit
import RCBacktrace

@objcMembers public class Backtrace: NSObject {

    public static func callstack(thread: Thread) {
        let symbols = RCBacktrace.callstack(.main)
        for symbol in symbols {
            print(symbol.description)
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "first page"

        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 60, height: 30))
        button.backgroundColor = .orange
        button.setTitle("test", for: .normal)
        button.addTarget(self, action: #selector(tapTest), for: .touchUpInside)

        view.addSubview(button)
    }

    @objc func tapTest() {
        DispatchQueue.global().async {
            let symbols = RCBacktrace.callstack(.main)
            for symbol in symbols {
                print(symbol.description)
            }
        }

        foo()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(SecondViewController(), animated: true)
    }

    func foo() {
        bar()
    }

    func bar() {
        baz()
    }

    func baz() {
        while true {

        }
    }
}
