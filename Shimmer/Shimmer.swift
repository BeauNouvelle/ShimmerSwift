//
//  Shimmer.swift
//  FBShimmerSwift
//
//  Created by Beau Nouvelle on 9/9/18.
//  Copyright © 2018 nouvelle. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

final class Shimmer {

    enum Direction {
        case right
        case left
        case up
        case down
    }
    
    static let slideAnimationKey = "slide"
    static let fadeAnimationKey = "fade"
    static let endFadeAnimationKey = "fade-end"

    static func fadeAnimation(layer: CALayer, opacity: CGFloat, duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = layer.presentation()?.opacity
        animation.toValue = opacity
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        animation.duration = duration
        return animation
    }

    static func slideAnimation(duration: CFTimeInterval, direction: Direction) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.toValue = NSValue(cgPoint: .zero)
        animation.duration = duration
        animation.repeatCount = .greatestFiniteMagnitude
        if direction == .left || direction == .up {
            animation.speed = -fabsf(animation.speed)
        }
        return animation
    }

    static func slideRepeat(animation: CAAnimation, duration: CFTimeInterval, direction: Direction) -> CAAnimation {
        let anim = animation.copy() as! CAAnimation
        anim.repeatCount = .greatestFiniteMagnitude
        anim.duration = duration
        anim.speed = (direction == .right || direction == .down) ? fabsf(anim.speed) : -fabsf(anim.speed)
        return anim
    }

    static func slideFinish(animation: CAAnimation) -> CAAnimation {
        let anim = animation.copy() as! CAAnimation
        anim.repeatCount = 0
        return anim
    }

}

