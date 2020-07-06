//
//  MemeTableViewController.swift
//  MemeMev1.0
//
//  Created by Anmol Raibhandare on 7/1/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
       var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.reloadData()
    }
    
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText 
        cell.imageView?.image = meme.memedImage

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

        let memeDetail = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        memeDetail.meme = meme
        self.navigationController!.pushViewController(memeDetail, animated: true)

    }
        
    
}
