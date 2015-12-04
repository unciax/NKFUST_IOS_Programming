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
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ori_width:CGFloat=0
    var ori_height:CGFloat=0
    var email:NSURL?
    var tel:NSURL?
    private var imageView = UIImageView()
    
    private var image:UIImage? {
        get{ return imageView.image}
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize=imageView.frame.size
            ori_width = imageView.frame.size.width
            ori_height = imageView.frame.size.height
            putImageAtCenter()
        }
    }
 
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func callNumber(sender: UIButton) {
        UIApplication.sharedApplication().openURL(tel!)
    }
    
    
    
    @IBAction func sendEMail(sender: UIButton) {
        UIApplication.sharedApplication().openURL(email!)
    }
    
    var teacherCore:Teacher?
 
    func putImageAtCenter(){
        let imageViewSize = self.imageView.frame.size
        let scrollViewSize = self.scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        self.scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        print("VerticalPadding:\(verticalPadding) HorizontalPadding:\(horizontalPadding)")
        print("ScrollViewOffset \(self.scrollView.contentOffset)")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let imageViewSize = self.imageView.frame.size
        let scrollViewSize = self.scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        if(imageViewSize.width < scrollViewSize.width) { scrollView.contentOffset.x = 0-horizontalPadding }
        if(imageViewSize.height < scrollViewSize.height) { scrollView.contentOffset.y = 0-verticalPadding }
        
        print("Offset:\(scrollView.contentOffset.x) x \(scrollView.contentOffset.y)")
        print("Image:\(imageView.frame.size.width) x \(imageView.frame.size.height)")
        print("ScrollView \(scrollView.bounds.width) x \(scrollView.bounds.height)")
        print("VerticalPadding:\(verticalPadding) HorizontalPadding:\(horizontalPadding)")
        print("ScrollViewOffset \(self.scrollView.contentOffset)")
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        
        let core = teacherCore!
        lblName.text = core.name
        lblLocation.text = core.office
        imageView.image = core.image
        btnCall.setTitle("\(core.ext)", forState: .Normal)
        email = NSURL(string: "mailto:\(core.email)")
        tel = NSURL(string: "tel://+88676011000p\(core.ext)")
        btnEMail.setTitle(core.email, forState: .Normal)
        
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
