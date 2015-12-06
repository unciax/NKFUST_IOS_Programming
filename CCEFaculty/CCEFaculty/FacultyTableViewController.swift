//
//  FacultyTableViewController.swift
//  CCEFaculty
//
//  Created by UnciaX on 2015/12/1.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit
import SwiftyJSON

class FacultyTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet var facultyTable: UITableView!
    var core = DataCore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加入下拉更新控制項
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("fetchAndReload"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        fetchAndReload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return core.teacherArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as! FacultyTableViewCell
        cell.teacherName.text = core.teacherArray[indexPath.row].name
        cell.teacherEdu.text = core.teacherArray[indexPath.row].education
        cell.selfimage.image = core.teacherArray[indexPath.row].image
        return cell
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let rect = tableView.rectForRowAtIndexPath(indexPath).origin.y
        let detailController: QuickShowViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("QuickShowView") as! QuickShowViewController
        detailController.teacherCore = core.teacherArray[indexPath.row]
        detailController.modalPresentationStyle = .Popover
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let popoverView = detailController.popoverPresentationController
        detailController.preferredContentSize = CGSize(width: 250, height: 21)
        popoverView?.delegate=self
        popoverView?.sourceView = cell
        print("Row Y + 2 times cell height : \(rect+cell.bounds.height*2)")
        print("view height : \(view.bounds.height)")
        print(rect)
        if ((rect+cell.bounds.height*2+20) > view.bounds.height){
            popoverView?.permittedArrowDirections = .Down
            popoverView?.sourceRect = CGRect(x: cell.bounds.width-50,y: 0,width: 0,height: 0)
        }else{
            popoverView?.permittedArrowDirections = .Up
            popoverView?.sourceRect = CGRect(x: cell.bounds.width-50,y: cell.bounds.height,width: 0,height: 0)
        }
        presentViewController(detailController, animated: true, completion: nil)

    }


    
    func fetchAndReload(){
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Loading...")
        let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        dispatch_async(queue) {
            if(!self.core.loadData()){
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "", message: "目前服務暫時無法使用，請稍候再試", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "好", style:UIAlertActionStyle.Default, handler:nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.facultyTable.reloadData()
                if self.refreshControl!.refreshing
                {
                    self.refreshControl!.endRefreshing()
                }
                self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to reload data")
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            switch identifier {
                case "ShowDetail":
                    if let vc = segue.destinationViewController as? DetailViewController {
                        let cell = sender as! FacultyTableViewCell
                        vc.title = cell.teacherName.text
                        let indexPath = facultyTable.indexPathForCell(cell)
                        vc.teacherCore = core.teacherArray[indexPath!.row]
                    }
                default: break
            }

        }
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return UIModalPresentationStyle.None
    }
    

  }
