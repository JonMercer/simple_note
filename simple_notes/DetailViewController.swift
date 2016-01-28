//
//  DetailViewController.swift
//  simple_notes
//
//  Created by Odin on 2016-01-26.
//  Copyright © 2016 Jon Mercer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //This label contains the details in the detail view
    @IBOutlet weak var detailDescriptionLabel: UITextView!


    // Controls what should show up in the detail view
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        
        if objects.count == 0 { //exit when empty
            return
        }
        
        //NOTE: deleting this because "detail" is not being used.
        //if let detail = self.detailItem {
        if let label = self.detailDescriptionLabel {
            //                label.text = detail.description
            label.text = objects[currentIndex] //loads that object value into the label's text. Who calls this function though?
            if label.text == BLANK_NOTE { //what's the pooint of the BLANK_NOTE to begin with?
                label.text = ""
            }
        }
        
    }

    override func viewDidLoad() {
        //is it the viewDidLoad() super call from MasterViewController the one calling this?  Don't think so actually.
        super.viewDidLoad()
        
        //Will always reset the detailViewController on reset ???
        detailViewController = self
        
        /* Enabling the keyboard by default */
        //means it becomes the first object to recieve the event
        detailDescriptionLabel.becomeFirstResponder()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

