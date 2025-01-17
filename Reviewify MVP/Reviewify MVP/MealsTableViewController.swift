//
//  MealsTableViewController.swift
//  Speakeasy
//
//  Created by Bryce Langlotz on 5/12/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class MealsTableViewController: UITableViewController {
    
    var meals = [Meal]()
    var selectedMeal:Meal!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        refreshMeals()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshMeals()
    }
    
    func showAlert(titles:String!, message:String!) {
        var alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    @IBAction func refreshMeals() {
        var hud = MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        hud.labelText = "Fetching Scanned Meals"
        PFUser.currentUser()!.getScannedMealsInBackgroundWithBlock { (results, error) -> Void in
            if let error = error {
                self.showAlert("Error", message: "There was a problem downloading your meals")
            }
            if let mealsResults = results as? [Meal] {
                self.meals = mealsResults
                self.tableView.reloadData()
            }
            hud.hide(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return meals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MealCellReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        if meals[indexPath.row].claimed! {
            cell.textLabel?.textColor = UIColor.redColor()
            cell.textLabel?.text = "Claimed"
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        else {
            cell.textLabel?.textColor = UIColor.algorithmsGreen()
            cell.textLabel?.text = "Available"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }

        cell.detailTextLabel?.text = "Reward: \(meals[indexPath.row].potentialReward!)"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMeal = meals[indexPath.row]
        if selectedMeal.claimed == false {
            performSegueWithIdentifier("ReviewScannedMealSegueIdentifier", sender: self)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReviewScannedMealSegueIdentifier" {
            var destinationViewController = segue.destinationViewController as! ReviewTableViewController
            destinationViewController.restaurantCode = selectedMeal.restaurantObjectId
            destinationViewController.mealCode = selectedMeal.objectId
            destinationViewController.server = selectedMeal.serverObjectId
            destinationViewController.potentialReward = selectedMeal.potentialReward
        }
    }

}
