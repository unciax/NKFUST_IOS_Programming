//
//  ImageViewController.swift
//  ScrollableImage
//
//  Created by UnciaX on 2015/11/17.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnUp: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnDown: UIButton!
    var ori_width:CGFloat=0
    var ori_height:CGFloat=0
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageURL:NSURL? {
        didSet {
            if view.window != nil {
                image = nil
                fetchImage()
            }
        }
    }
    
    private var imageView = UIImageView()
    
    private var image:UIImage? {
        get{ return imageView.image}
        set{
            spinner?.stopAnimating()
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize=imageView.frame.size
            ori_width = imageView.frame.size.width
            ori_height = imageView.frame.size.height
            resetMinimumZoomScale()
            btnUp.enabled=false
            btnLeft.enabled=false
            btnRight.enabled=imageView.frame.size.width > scrollView.bounds.width ? true : false
            btnDown.enabled=imageView.frame.size.height > scrollView.bounds.height ? true : false
        }
    }
    
    private func fetchImage(){
        if let url = imageURL {
            spinner.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()){
                    if url == self.imageURL{
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        }else{
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func offSetButton(sender: AnyObject) {
        let btnName:String = sender.currentTitle!!
        var new_x:CGFloat = CGFloat()
        var new_y:CGFloat = CGFloat()
        switch(btnName){
            case "⬆︎":
                new_x = scrollView.contentOffset.x
                new_y = scrollView.contentOffset.y - scrollView.bounds.height
                if (new_y <= 0) {
                    new_y = 0
                    btnUp.enabled = false
                    btnDown.enabled = true
                }else {
                    btnUp.enabled = true
                    btnDown.enabled = true
                }
                
                break;
            case "➡︎":
                new_x = scrollView.contentOffset.x + scrollView.bounds.width
                new_y = scrollView.contentOffset.y
                if (new_x + scrollView.bounds.width >= imageView.frame.size.width) {
                    new_x = imageView.frame.size.width - scrollView.bounds.width
                    btnRight.enabled = false
                    btnLeft.enabled = true
                } else {
                    btnRight.enabled = true
                    btnLeft.enabled = true
                }
                break;
            case "⬇︎":
                new_x = scrollView.contentOffset.x
                new_y = scrollView.contentOffset.y + scrollView.bounds.height
                if (new_y + scrollView.bounds.height >= imageView.frame.size.height) {
                    new_y = imageView.frame.size.height - scrollView.bounds.height
                    btnDown.enabled = false
                    btnUp.enabled=true
                } else {
                    btnDown.enabled = true
                    btnUp.enabled=true
                }
                break;
            case "⬅︎":
                new_x = scrollView.contentOffset.x - scrollView.bounds.width
                new_y = scrollView.contentOffset.y
                if (new_x <= 0) {
                    new_x = 0
                    btnLeft.enabled = false
                    btnRight.enabled=true
                } else {
                    btnLeft.enabled = true
                    btnRight.enabled=true
                }
                break;
            default: break;
        }
        
        scrollView.scrollRectToVisible(CGRect(x: new_x, y: new_y, width: scrollView.bounds.width, height: scrollView.bounds.height),animated: true)
        print("case:\(btnName) imageView.width:\(imageView.frame.size.width) x:\(new_x) y:\(new_y)")
        print("\(btnRight.enabled)")
    }
    
    func resetMinimumZoomScale(){
        let lastZoomScale = scrollView.zoomScale
        print("last Scale:\(scrollView.zoomScale)")
        dispatch_async(dispatch_get_main_queue()){
            let imageViewSize = self.imageView.frame.size
            let scrollViewSize = self.scrollView.bounds.size
            
            self.scrollView.minimumZoomScale = min(scrollViewSize.height/self.ori_height , scrollViewSize.width/self.ori_width)
            if lastZoomScale < self.scrollView.minimumZoomScale { self.scrollView.zoomScale = self.scrollView.minimumZoomScale }
            print("scrollView.height:\(scrollViewSize.height) imageView.height:\(imageViewSize.height) ratio:\(scrollViewSize.height/self.ori_height)")
            print("scrollView.width:\(scrollViewSize.width) imageView.width:\(imageViewSize.width) ratio:\(scrollViewSize.width/self.ori_width)")
            print("min:\(self.scrollView.minimumZoomScale)")            
        }
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        btnUp.enabled = false
        btnLeft.enabled = false
        btnRight.enabled = false
        btnDown.enabled = false
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }


    func scrollViewDidZoom(scrollView: UIScrollView) {
        putImageAtCenter(true)
    }
    
    func putImageAtCenter(resetEnable:Bool){
        dispatch_async(dispatch_get_main_queue()){
            let imageViewSize = self.imageView.frame.size
            let scrollViewSize = self.scrollView.bounds.size
        
            let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
            let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
            if(resetEnable){
                self.btnUp.enabled=imageViewSize.height > scrollViewSize.height ? true : false
                self.btnLeft.enabled=imageViewSize.width > scrollViewSize.width ? true : false
                self.btnRight.enabled=imageViewSize.width > scrollViewSize.width ? true : false
                self.btnDown.enabled=imageViewSize.height > scrollViewSize.height ? true : false
            }
            self.scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
            print("VerticalPadding:\(verticalPadding) HorizontalPadding:\(horizontalPadding)")
            print("ScrollViewOffset \(self.scrollView.contentOffset)")
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let imageViewSize = self.imageView.frame.size
        let scrollViewSize = self.scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        if(imageViewSize.width < scrollViewSize.width) { scrollView.contentOffset.x = 0-horizontalPadding }
        if(imageViewSize.height < scrollViewSize.height) { scrollView.contentOffset.y = 0-verticalPadding }
        
        btnUp.enabled = scrollView.contentOffset.y  <= 0 ? false : true
        btnDown.enabled = (scrollView.contentOffset.y + scrollView.bounds.height  >= imageView.frame.size.height) ? false:true
        btnLeft.enabled = scrollView.contentOffset.x <= 0 ? false : true
        btnRight.enabled = (scrollView.contentOffset.x + scrollView.bounds.width  >= imageView.frame.size.width)   ? false : true
        
        print("Offset:\(scrollView.contentOffset.x) x \(scrollView.contentOffset.y)")
        print("Image:\(imageView.frame.size.width) x \(imageView.frame.size.height)")
        print("ScrollView \(scrollView.bounds.width) x \(scrollView.bounds.height)")
        print("VerticalPadding:\(verticalPadding) HorizontalPadding:\(horizontalPadding)")
        print("ScrollViewOffset \(self.scrollView.contentOffset)")  
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (image != nil ) {
            
            resetMinimumZoomScale()
            if (scrollView.zoomScale != 1.0) {
                putImageAtCenter(false)
                print("now Scale:\(scrollView.zoomScale)")
                print("scrollView.height:\(scrollView.bounds.height) imageView.height:\(imageView.frame.size.height)")
                print("scrollView.width:\(scrollView.bounds.width) imageView.width:\(imageView.frame.size.width)")
                
            }
        }
    }
}