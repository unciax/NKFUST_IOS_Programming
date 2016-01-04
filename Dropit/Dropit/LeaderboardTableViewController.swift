//
//  LeaderboardTableViewController.swift
//  Dropit
//
//  Created by UnciaX on 2015/12/16.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {
    @IBOutlet var table: UITableView!
    var sr = ScoreRecord()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        if sr.ScoreList.count < 20 {
            return sr.ScoreList.count
        }else{
            return 20
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! ScoreTableViewCell
        print(indexPath.row)
        cell.lblNo.text = "#\(indexPath.row+1)"
        cell.lblScore.text = "\(sr.ScoreList[indexPath.row].score)"
        cell.lblMode.text = sr.ScoreList[indexPath.row].mode == 0 ? "[Block Removing]" : "[Surviving]"
        cell.lblDuration.text = "Duration time:\(getTimeString(sr.ScoreList[indexPath.row].duration))"

        return cell
    }
    
    func getTimeString(ti:NSTimeInterval) -> String{
        var min = 0
        var sec = Int(ti)
        min = (sec-(sec%60))/60
        sec = sec%60
        return String(format: "%02d : %02d", min,sec)
    }

  
}
