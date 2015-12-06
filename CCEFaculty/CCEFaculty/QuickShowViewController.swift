//
//  QuickShowViewController.swift
//  CCEFaculty
//
//  Created by UnciaX on 2015/12/5.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class QuickShowViewController: UIViewController {

    @IBOutlet weak var lblInfo: UILabel!
    var teacherCore:Teacher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let core = teacherCore!
        let str = "研究室：\(core.office) - 分機：\(core.ext)"
        lblInfo?.text = str
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override var preferredContentSize: CGSize {
        get{
            if lblInfo != nil && presentingViewController != nil {
                return lblInfo.sizeThatFits(presentingViewController!.view.bounds.size)
            }else{
                return super.preferredContentSize
            }
        }
        set{
            super.preferredContentSize = newValue
        }
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
