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
    var hasZoom:Bool=false
    private var imageView = UIImageView()
    
    private var image:UIImage? {
        get{ return imageView.image}
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize=imageView.frame.size
            ori_width = imageView.frame.size.width
            ori_height = imageView.frame.size.height
            resetZoomScale()
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
 
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        if(imageViewSize.width < scrollViewSize.width) { scrollView.contentOffset.x = 0-horizontalPadding }
        if(imageViewSize.height < scrollViewSize.height) { scrollView.contentOffset.y = 0-verticalPadding }
        if(imageViewSize.height > scrollViewSize.height && scrollView.contentOffset.y<0) { scrollView.contentOffset.y=0}
        
        print("Offset:\(scrollView.contentOffset.x) x \(scrollView.contentOffset.y)")
        print("Image:\(imageView.bounds.size.width) x \(imageView.bounds.size.height)")
        print("ScrollView \(scrollView.frame.width) x \(scrollView.frame.height)")
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
        image = core.image
        btnCall.setTitle("\(core.ext)", forState: .Normal)
        email = NSURL(string: "mailto:\(core.email)")
        tel = NSURL(string: "tel://+88676011000p\(core.ext)")
        btnEMail.setTitle(core.email, forState: .Normal)
        
    }

    func resetZoomScale(){
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let lastZoomScale = scrollView.zoomScale
        print("last Scale:\(scrollView.zoomScale)")
        if (scrollViewSize.height>self.ori_height && scrollViewSize.width>self.ori_width){
            self.scrollView.minimumZoomScale = 1.0
        }else{
            self.scrollView.minimumZoomScale = min(scrollViewSize.height/self.ori_height , scrollViewSize.width/self.ori_width)
        }
        if lastZoomScale < self.scrollView.minimumZoomScale { self.scrollView.zoomScale = self.scrollView.minimumZoomScale }
        if (!hasZoom){
            if (imageViewSize.height>scrollViewSize.height || imageViewSize.width>scrollViewSize.width) {
                scrollView.zoomScale = scrollView.minimumZoomScale
            }
        }
        hasZoom = true
        print("scrollView.height:\(scrollViewSize.height) imageView.height:\(imageViewSize.height) ratio:\(scrollViewSize.height/self.ori_height)")
        print("scrollView.width:\(scrollViewSize.width) imageView.width:\(imageViewSize.width) ratio:\(scrollViewSize.width/self.ori_width)")
        print("min:\(self.scrollView.minimumZoomScale)")
        print("now:\(self.scrollView.zoomScale)")
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
