//
//  ViewController.swift
//  Paopaodome
//
//  Created by 98data on 2019/10/12.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var bbLayer : WDGBubbleLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if bbLayer == nil {
            bbLayer = WDGBubbleLayer(originalSize: imageView.frame.size)
        }
        
        imageView.backgroundColor = UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 0.4)
        imageView.layer.mask = bbLayer?.layer()
    }
    
    


}

