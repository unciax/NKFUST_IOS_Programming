//
//  DetailViewController.swift
//  CCEFaculty
//
//  Created by UnciaX on 2015/12/3.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnEMail: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBAction func callNumber(sender: UIButton) {
        UIApplication.sharedApplication().openURL(tel!)
    }
    
    var email:NSURL?
    var tel:NSURL?
    
    @IBAction func sendEMail(sender: UIButton) {
        UIApplication.sharedApplication().openURL(email!)
    }
    
    var teacherCore:Teacher?
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let core = teacherCore!
        lblName.text = core.name
        lblLocation.text = core.office
        image.image = core.image
        btnCall.setTitle("\(core.ext)", forState: .Normal)
        email = NSURL(string: "mailto:\(core.email)")
        tel = NSURL(string: "tel://+88676011000p\(core.ext)")
        btnEMail.setTitle(core.email, forState: .Normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
