//
//  ViewController.swift
//  SSL
//
//  Created by Haifisch on 6/6/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
                            
    var json:NSMutableDictionary = NSMutableDictionary()
    @IBOutlet var daysSince : UILabel = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadDays(UIButton()) // Has to be *a* object... for fucks sake
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func reloadDays(sender : AnyObject) {
        var url: NSURL = NSURL(string: "http://dayswithoutansslexploit.com/api/")
        var data:NSData = NSData(contentsOfURL: url)
        if data != nil
        {
            json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSMutableDictionary
            self.daysSince.text = NSString(format: "%@", json["days"] as NSString)
            //println(json["days"].integerValue)
        }else {
            println("Data empty")
        }
    }
    @IBAction func share(sender : AnyObject) {
        /*
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[[NSString stringWithFormat:@"%@ days since the last SSL exploit. http://dayswithoutansslexploit.com",self.daysSince.text]] applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
        */
        var controller = UIActivityViewController(activityItems:[NSString(format: "%@ days since the last SSL exploit. http://dayswithoutansslexploit.com",self.daysSince.text)], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    func tableView(tableView: UITableView!,
        heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
            return 90
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        return json["list"].count
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "ExploitCell")
        /* Original Objective C code
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.text = [[json[@"list"] objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text = [[json[@"list"] objectAtIndex:indexPath.row] objectForKey:@"description"];
        cell.detailTextLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        */
        // Awe yeah! Swift
        cell.textLabel.textColor = UIColor.blueColor()
        var list:NSArray = json["list"] as NSArray
        cell.textLabel.text = list.objectAtIndex(indexPath.row).objectForKey("name") as NSString
        cell.detailTextLabel.text = list.objectAtIndex(indexPath.row).objectForKey("description") as NSString
        cell.detailTextLabel.numberOfLines = 0
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    func tableView(tableView: UITableView!,
        didSelectRowAtIndexPath indexPath: NSIndexPath!) {
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[json[@"list"] objectAtIndex:indexPath.row] objectForKey:@"url"]]];
            UIApplication.sharedApplication().openURL(NSURL(string: json["list"].objectAtIndex(indexPath.row)["url"] as NSString))
    }

}

