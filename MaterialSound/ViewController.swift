//
//  ViewController.swift
//  MaterialSound
//
//  Created by 董静 on 3/25/21.
//  Copyright © 2021 JING. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var patch:PDPatch?
    var patch2:PDPatch?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //
        var soundButton :UIButton
        soundButton = UIButton()
        soundButton.addTarget(self, action: #selector(clickSound), for: .touchUpInside)
        soundButton.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        soundButton.backgroundColor = .systemGreen
        self.view.addSubview(soundButton)
        
        var slider: UISlider
        slider = UISlider(frame: CGRect(x: 15, y: soundButton.bottom + 15, width: view.width - 30 , height: 30))
        slider.maximumValue = 1000
        slider.minimumValue = 0
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(self.slideChanged(_:)), for: .valueChanged)
        self.view.addSubview(slider)
        patch = PDPatch.init(file: "material.pd")
        
        
    }
    
    @objc func clickSound(){
        patch?.onPatch(10)
    }
    @objc func slideChanged(_ sender:UISlider!){
        patch?.changeNoise(sender.value)
    }
    

}
