//
//  ViewController.swift
//  ShimmerSwift
//
//  Created by Beau Nouvelle on 7/9/18.
//  Copyright © 2018 nouvelle. All rights reserved.
//

import UIKit
import ShimmerSwift

class ViewController: UIViewController {

    let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    func setupSubviews() {
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

        let startStopButton = UIButton(frame: CGRect(x: 0, y: 200, width: 200, height: 100))
        startStopButton.addTarget(self, action: #selector(tappedStartStopButton), for: .touchUpInside)
        startStopButton.setTitle("Start/Stop Shimmer", for: .normal)
        startStopButton.setTitleColor(.black, for: .normal)
        view.addSubview(startStopButton)
    }

    @objc func tappedStartStopButton() {
        shimmerView.isShimmering = !shimmerView.isShimmering
    }

}

