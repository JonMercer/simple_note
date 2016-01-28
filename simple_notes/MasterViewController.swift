//
//  MasterViewController.swift
//  simple_notes
//
//  Created by Odin on 2016-01-26.
//  Copyright © 2016 Jon Mercer. All rights reserved.
//

import UIKit

var objects:[String] = [String]()
var currentIndex:Int = 0
var masterView:MasterViewController? // can be nil
var detailViewController:DetailViewController?

//constants
let kNotes:String = "notes"
let BLANK_NOTE:String = "(New Note)"


class MasterViewController: UITableViewController {

// Launched when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        masterView = self //because ViewController is calling a masterView constant. We had to create constants becasue we don't yet know how to handle object passing
        
        load()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        //NOTE: this originally set the detailViewController, but we want to set it ourselved in the DetailViewController.swift file.
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
    }

    // Runs right before the view appears in the screen
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        save() //we're saving when we come back from the details screen
        super.viewWillAppear(animated)
    }
    
    /* try to transition to detail view if there are not objects in the objects array. That is, open details view is app is empty */
    //"did" is called after the view has appeared
    override func viewDidAppear(animated: Bool) {
        
        //check if empty
        if objects.count == 0 {
            insertNewObject(self) //pretty much what happens when the + button is pressed
        }
        super.viewDidAppear(animated)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //runs when the "+" button is pressed
    func insertNewObject(sender: AnyObject) {
        //Checks if the first note is empty, if so, then use it.
        if(objects.count == 0 || objects[0] != BLANK_NOTE) {
            objects.insert(BLANK_NOTE, atIndex: 0) //inserts at the top of the list
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        

        
        //force the segue to showDetail
        self.performSegueWithIdentifier("showDetail", sender: self)
        
    }

    // MARK: - Segues
// Seque between the master view and the table view when an item is tapped
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" { //showDetail is just an identifier attached to the detail view. I can rename it to foo if I want
            if let indexPath = self.tableView.indexPathForSelectedRow {//what happens when the user taps a row
                let object = objects[indexPath.row]
                currentIndex = indexPath.row //grabs the current index. Not sure what this will be for
                
                //NOTE: this below is uselss because we're saving the detailViewController as a constant
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                detailViewController?.detailItem = object // the ? unwraps it and if things go wrong, the app continues as normal. An ! will break the app on purpose.
                detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                detailViewController?.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // When you're in the edit section of a note item (swiping left)
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { //ran when we go into delete mode and press the delete button
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //Called when you enter and exit editing mode
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            return
        }
        save()
    }
    
    //when swiping
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        save()
    }
    
    func save() {
        //saved the objects object with the key kNotes. (what about collision?)
        NSUserDefaults.standardUserDefaults().setObject(objects, forKey: kNotes)
        
        //force the save. Will otherwise save when the OS feels like it.
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func load() {
        // let (a constant) will only be used on successful call or cast
        // retrieve data from persistent storage
        // as? is a cast
        if let loadedData = NSUserDefaults.standardUserDefaults().arrayForKey(kNotes) as? [String] {
            objects = loadedData
        }
        
    }
    



}

