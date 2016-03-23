//
//  SidePanelViewController.swift
//  SlideOut
//
//  Created by Marco Tabacchino on 03/11/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit


protocol SidePanelViewControllerDelegate {
    func optionSelected(option: SlideOption)
}

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SidePanelViewControllerDelegate?
    
    var options: Array<SlideOption>!
    
    struct TableView {
        struct CellIdentifiers {
            static let SlideCell = "SlideCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.SlideCell, forIndexPath: indexPath) as! SlideCell
        cell.configureForOption(options[indexPath.row])
        return cell
    }
    
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedOption = options[indexPath.row]
        delegate?.optionSelected(selectedOption)
        //delegate?.collapseSidePanels()
    }
    
}

class SlideCell: UITableViewCell {
    
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var optionName: UILabel!
    
    
    func configureForOption(option: SlideOption) {
        optionImage.image = option.image
        optionName.text = option.title
        
    }
    
}