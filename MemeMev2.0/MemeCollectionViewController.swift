//
//  SentMemesCollectionViewController.swift
//  MemeMev1.0
//
//  Created by Anmol Raibhandare on 7/1/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController{
    
    // MARK: Properties
    
    // Create a property called memes, and set it to the memes array from the AppDelegate
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
        self.collectionView.reloadData()
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        // Set the image
        cell.memeGeneratedImageView.image = meme.memedImage

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let memeDetail = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetail.meme = memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(memeDetail, animated: true)

    }
    
}
