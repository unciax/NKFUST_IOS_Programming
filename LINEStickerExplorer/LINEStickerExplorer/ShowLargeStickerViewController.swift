//
//  ShowLargeStickerViewController.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/31.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class ShowLargeStickerViewController: UIViewController {

    var st:sticker = sticker()
    
    var img = UIImageView(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("Triggle viewWillAppear")
        super.viewWillAppear(animated)
        img.image = UIImage(data:st.sImage!)
        let frameOfImage = CGRect(x: 8, y: 8  , width: img.image!.size.width, height: img.image!.size.height)
        img.frame = frameOfImage
        view.addSubview(img)
        
        img.sizeThatFits(CGSize(width: st.image!.size.width, height: st.image!.size.height))
        print("\(st.sID) image size \(img.image!.size) \(img.bounds) \(view.bounds)")
        setViewSize()

    }
    
    
    func setViewSize(){
        view.sizeThatFits(CGSize(width: st.image!.size.width, height: st.image!.size.height))
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
