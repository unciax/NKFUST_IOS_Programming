//
//  ViewController.swift
//  PhotoViewer
//
//  Created by UnciaX on 2015/11/19.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ivc = segue.destinationViewController as? ImageViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "Air":
                    ivc.imageURL = ImageURL.Air
                    ivc.title = "空氣少女注意報"
                case "MAGI":
                    ivc.imageURL = ImageURL.MAGI
                    ivc.title = "迷路小瑪在萬金"
                case "shrimp":
                    ivc.imageURL = ImageURL.Shrimp
                    ivc.title = "初夏的東港之櫻"
                default: break
                }
            }
        }
    }

}

