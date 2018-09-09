//
//  ViewController.swift
//  ShimmerSwift
//
//  Created by Beau Nouvelle on 7/9/18.
//  Copyright © 2018 nouvelle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupSubviews()
    }

    func setupSubviews() {
        let shimmerView = ShimmeringView(frame: self.view.bounds)
        self.view.addSubview(shimmerView)

        let label = UILabel(frame: shimmerView.bounds)
        label.text = "This is my shimmering text"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 50)
        shimmerView.contentView = label
        shimmerView.isShimmering = true
        shimmerView.shimmerSpeed = 400
        shimmerView.shimmerPauseDuration = 0.0
    }

}

