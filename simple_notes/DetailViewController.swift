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
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

