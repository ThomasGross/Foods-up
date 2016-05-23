//
//  CategoryTableViewController.swift
//  BurningFood
//
//  Created by Thomas Rasmussen on 22/05/2016.
//  Copyright © 2016 Thomas Rasmussen. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    let categoryService = CategoryService()
    
    var categoryList = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryList = categoryService.getCategories()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCellSegue", forIndexPath: indexPath) as! CategoryTableViewCell
        
        let imgUrl = self.categoryList[indexPath.row].photoURL
        
        cell.imgView_flag.image = UIImage(named: imgUrl)
        cell.imgView_flag.contentMode = .ScaleAspectFill // fills the imageview
        cell.imgView_flag.clipsToBounds = true // clips to all sides of imageview
        //cell.imgView_flag.layer.cornerRadius = 3.0 // round corners
    
        cell.lbl_country.text = self.categoryList[indexPath.row].categoryName
        
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segueToMapView") {
            let segueToMapView = segue.destinationViewController as? MapViewController
            
            print(categoryList[(tableView.indexPathForSelectedRow?.row)!])
            
            segueToMapView?.searchString = (categoryList[(tableView.indexPathForSelectedRow?.row)!]).searchString
        }
    }

}
