//
//  MemeDetailViewController.swift
//  MemeMev1.0
//
//  Created by Anmol Raibhandare on 7/1/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController{
    
    var meme: Meme!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.memeImageView!.image = meme.memedImage
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
