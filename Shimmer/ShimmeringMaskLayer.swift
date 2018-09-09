//
//  ShimmeringMaskLayer.swift
//  FBShimmerSwift
//
//  Created by Beau Nouvelle on 9/9/18.
//  Copyright © 2018 nouvelle. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

final class ShimmeringMaskLayer: CAGradientLayer {

    let fadeLayer = CALayer()

    override init() {
        super.init()
        fadeLayer.backgroundColor = UIColor.white.cgColor
        addSublayer(fadeLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        let rect = bounds
        fadeLayer.bounds = rect
        fadeLayer.position = CGPoint(x: rect.midX, y: rect.midY)
    }
}
