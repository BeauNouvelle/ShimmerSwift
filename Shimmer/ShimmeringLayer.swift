//
//  ShimmeringLayer.swift
//  ShimmerSwift
//
//  Created by Beau Nouvelle on 7/9/18.
//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org/>


import Foundation
import QuartzCore
#if canImport(UIKit)
import UIKit

final public class ShimmeringLayer: CALayer {

    /// Set to `true` to start shimmer animation, and `false` to stop. Detaults to `false`.
    public var isShimmering: Bool = false {
        didSet { if oldValue != isShimmering { updateShimmering() } }
    }

    /// The speed of the shimmer animation in points per second. The higher the number, the faster the animation.
    /// Defaults to 230.
    public var shimmerSpeed: CGFloat = 230.0 {
        didSet { if oldValue != shimmerSpeed { updateShimmering() } }
    }

    /// The highlight length of the shimmer. Range of [0,1], defaults to 1.0.
    public var shimmerHighlightLength: CGFloat = 1.0 {
        didSet { if oldValue != shimmerHighlightLength { updateShimmering() } }
    }

    /// The direction of the shimmer animation.
    /// Defaults to `.right`, which will run the animation from left to right.
    public var shimmerDirection: Shimmer.Direction = .right {
        didSet { if oldValue != shimmerDirection { updateShimmering() } }
    }

    /// The time interval between shimmers in seconds.
    /// Defaults to 0.4.
    public var shimmerPauseDuration: CFTimeInterval = 0.4 {
        didSet { if oldValue != shimmerPauseDuration { updateShimmering() } }
    }

    /// The opacity of the content during a shimmer. Defaults to 0.5.
    public var shimmerAnimationOpacity: CGFloat = 0.5 {
        didSet { if oldValue != shimmerAnimationOpacity { updateMaskColors() } }
    }

    /// The opacity of the content when not shimmering. Defaults to 1.0.
    public var shimmerOpacity: CGFloat = 1.0 {
        didSet { if oldValue != shimmerOpacity { updateMaskColors() } }
    }

    /// The absolute CoreAnimation media time when the shimmer will begin.
    public var shimmerBeginTime: CFTimeInterval = .greatestFiniteMagnitude {
        didSet { if oldValue != shimmerBeginTime { updateShimmering() } }
    }

    /// The duration of the fade used when the shimmer begins. Defaults to 0.1.
    public var shimmerBeginFadeDuration: CFTimeInterval = 0.1

    /// The duration of the fade used when the shimmer ends. Defaults to 0.3.
    public var shimmerEndFadeDuration: CFTimeInterval = 0.3

    /// The absolute CoreAnimation media time when the shimmer will fade in.
    public var shimmerFadeTime: CFTimeInterval?

    private let shimmerDefaultBeginTime: CFTimeInterval = .greatestFiniteMagnitude

    private var maskLayer: ShimmeringMaskLayer?

    override init() {
        super.init()
    }

    override public func layoutSublayers() {
        super.layoutSublayers()
        let rect = self.bounds
        contentLayer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        contentLayer?.bounds = rect
        contentLayer?.position = CGPoint(x: rect.midX, y: rect.midY)

        if maskLayer != nil {
            updateMaskLayout()
        }
    }

    var contentLayer: CALayer? {
        didSet {
            maskLayer = nil
            if let content = contentLayer {
                sublayers = [content]
            } else {
                sublayers = nil
            }
            updateShimmering()
        }
    }

    override public var bounds: CGRect {
        didSet {
            if oldValue.equalTo(bounds) {
                updateShimmering()
            }
        }
    }

    private func clearMask() {
        if maskLayer == nil { return }

        let disableActions = CATransaction.disableActions()
        CATransaction.setDisableActions(true)
        maskLayer = nil
        contentLayer?.mask = nil

        CATransaction.setDisableActions(disableActions)
    }

    private func createMaskIfNeeded() {
        if isShimmering && maskLayer == nil {
            maskLayer = ShimmeringMaskLayer()
            maskLayer?.delegate = self
            contentLayer?.mask = maskLayer
            updateMaskColors()
            updateMaskLayout()
        }
    }

    func updateMaskColors() {
        guard maskLayer != nil else { return }
        let maskedColor = UIColor(white: 1.0, alpha: shimmerOpacity)
        let unmaskedColor = UIColor(white: 1.0, alpha: shimmerAnimationOpacity)
        maskLayer?.colors = [maskedColor.cgColor, unmaskedColor.cgColor, maskedColor.cgColor]
    }

    private func updateMaskLayout() {
        guard let content = contentLayer else { return }

        var length: CGFloat = 0.0
        if shimmerDirection == .down || shimmerDirection == .up {
            length = content.bounds.height
        } else {
            length = content.bounds.width
        }

        if length == 0 {
            return
        }

        let extraDistance = length + shimmerSpeed * CGFloat(shimmerPauseDuration)
        let fullShimmerLength = length * 3 + extraDistance
        let travelDistance = length * 2 + extraDistance

        let highlightOutsideLength = (1 - shimmerHighlightLength) / 2
        maskLayer?.locations = [highlightOutsideLength, 0.5, (1 - highlightOutsideLength)] as [NSNumber]

        let startPoint = (length + extraDistance) / fullShimmerLength
        let endPoint = travelDistance / fullShimmerLength

        maskLayer?.anchorPoint = .zero
        if shimmerDirection == .down || shimmerDirection == .up {
            maskLayer?.startPoint = CGPoint(x: 0, y: startPoint)
            maskLayer?.endPoint = CGPoint(x: 0, y: endPoint)
            maskLayer?.position = CGPoint(x: 0, y: -travelDistance)
            maskLayer?.bounds = CGRect(x: 0, y: 0, width: content.bounds.width, height: fullShimmerLength)
        } else {
            maskLayer?.startPoint = CGPoint(x: startPoint, y: 0)
            maskLayer?.endPoint = CGPoint(x: endPoint, y: 0)
            maskLayer?.position = CGPoint(x: -travelDistance, y: 0)
            maskLayer?.bounds = CGRect(x: 0, y: 0, width: fullShimmerLength, height: content.bounds.height)
        }
    }

    func updateShimmering() {
        createMaskIfNeeded()
        guard let maskLayer = maskLayer else { return }
        layoutIfNeeded()

        let disableActions = CATransaction.disableActions()
        if isShimmering == false {
            if disableActions {
                clearMask()
            } else {

                var slideEndTime: CFTimeInterval = 0
                if let slideAnimation = maskLayer.animation(forKey: Shimmer.Key.slideAnimation) {
                    let now = CACurrentMediaTime()
                    let slideTotalDuration = now - slideAnimation.beginTime
                    let slideTimeOffset = fmod(slideTotalDuration, slideAnimation.duration)
                    let finishAnimation = Shimmer.slideFinish(animation: slideAnimation)

                    finishAnimation.beginTime = now - slideTimeOffset
                    slideEndTime = finishAnimation.beginTime + slideAnimation.duration
                    maskLayer.add(finishAnimation, forKey: Shimmer.Key.slideAnimation)
                }

                let fadeInAnimation = Shimmer.fadeAnimation(
                    layer: maskLayer.fadeLayer,
                    opacity: 1.0,
                    duration: shimmerEndFadeDuration)
                fadeInAnimation.delegate = self
                fadeInAnimation.setValue(true, forKey: Shimmer.Key.endFadeAnimation)
                fadeInAnimation.beginTime = slideEndTime
                maskLayer.fadeLayer.add(fadeInAnimation, forKey: Shimmer.Key.fadeAnimation)
                shimmerFadeTime = slideEndTime
            }
        } else {
            var fadeOutAnimation: CABasicAnimation?
            if shimmerBeginFadeDuration > 0.0 && disableActions == false {
                let fadeOut = Shimmer.fadeAnimation(
                    layer: maskLayer.fadeLayer,
                    opacity: 0.0,
                    duration: shimmerBeginFadeDuration)
                fadeOutAnimation = fadeOut
                maskLayer.fadeLayer.add(fadeOut, forKey: Shimmer.Key.fadeAnimation)
            } else {
                let innerDisableActions = CATransaction.disableActions()
                CATransaction.setDisableActions(true)
                maskLayer.fadeLayer.opacity = 0.0
                maskLayer.fadeLayer.removeAllAnimations()
                CATransaction.setDisableActions(innerDisableActions)
            }

            var length: CGFloat = 0.0
            if shimmerDirection == .down || shimmerDirection == .up {
                length = contentLayer?.bounds.height ?? 0
            } else {
                length = contentLayer?.bounds.width ?? 0
            }

            let animationDuration: CFTimeInterval = Double((length / shimmerSpeed)) + shimmerPauseDuration
            if let slideAnimation = maskLayer.animation(forKey: Shimmer.Key.slideAnimation) {
                let repeatAnimation = Shimmer.slideRepeat(
                    animation: slideAnimation,
                    duration: animationDuration,
                    direction: shimmerDirection)
                maskLayer.add(repeatAnimation, forKey: Shimmer.Key.slideAnimation)
            } else {
                let slideAnimation = Shimmer.slideAnimation(duration: animationDuration, direction: shimmerDirection)
                slideAnimation.fillMode = .forwards
                slideAnimation.isRemovedOnCompletion = false
                if shimmerBeginTime == shimmerDefaultBeginTime {
                    shimmerBeginTime = CACurrentMediaTime() + (fadeOutAnimation?.duration ?? 0)
                }
                slideAnimation.beginTime = shimmerBeginTime
                maskLayer.add(slideAnimation, forKey: Shimmer.Key.slideAnimation)
            }
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
    }
}

extension ShimmeringLayer: CALayerDelegate {
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return nil
    }
}

extension ShimmeringLayer: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true && anim.value(forKey: Shimmer.Key.endFadeAnimation) as? Bool == true {
            maskLayer?.fadeLayer.removeAnimation(forKey: Shimmer.Key.fadeAnimation)
            clearMask()
        }
    }
}

#endif
