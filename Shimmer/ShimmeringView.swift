//
//  ShimmeringView.swift
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
#if canImport(UIKit)
import UIKit

final public class ShimmeringView: UIView {

    override public class var layerClass: Swift.AnyClass {
        return ShimmeringLayer.self
    }

    /// The content view to be shimmered
    public var contentView = UIView() {
        didSet {
            if oldValue != contentView {
                addSubview(contentView)
                shimmerLayer?.contentLayer = contentView.layer
            }
        }
    }

    /// Set to `true` to start shimmer animation, and `false` to stop. Detaults to `false`.
    public var isShimmering: Bool = false {
        didSet { shimmerLayer?.isShimmering = isShimmering }
    }

    /// The speed of the shimmer animation in points per second. The higher the number, the faster the animation.
    /// Defaults to 230.
    public var shimmerSpeed: CGFloat = 230.0 {
        didSet { shimmerLayer?.shimmerSpeed = shimmerSpeed }
    }

    /// The highlight length of the shimmer. Range of [0,1], defaults to 1.0.
    public var shimmerHighlightLength: CGFloat = 1.0 {
        didSet { shimmerLayer?.shimmerHighlightLength = shimmerHighlightLength }
    }

    /// The direction of the shimmer animation.
    /// Defaults to `.right`, which will run the animation from left to right.
    public var shimmerDirection: Shimmer.Direction = .right {
        didSet { shimmerLayer?.updateShimmering() }
    }

    /// The time interval between shimmers in seconds.
    /// Defaults to 0.4.
    public var shimmerPauseDuration: CFTimeInterval = 0.4 {
        didSet  { shimmerLayer?.shimmerPauseDuration = shimmerPauseDuration }
    }

    /// The opacity of the content during a shimmer. Defaults to 0.5.
    public var shimmerAnimationOpacity: CGFloat = 0.5 {
        didSet { shimmerLayer?.shimmerAnimationOpacity = shimmerAnimationOpacity }
    }

    /// The opacity of the content when not shimmering. Defaults to 1.0.
    public var shimmerOpacity: CGFloat = 1.0 {
        didSet { shimmerLayer?.shimmerOpacity = shimmerOpacity }
    }

    /// The absolute CoreAnimation media time when the shimmer will begin.
    public var shimmerBeginTime: CFTimeInterval = .greatestFiniteMagnitude {
        didSet { shimmerLayer?.shimmerBeginTime = shimmerBeginTime }
    }

    /// The duration of the fade used when the shimmer begins. Defaults to 0.1.
    public var shimmerBeginFadeDuration: CFTimeInterval = 0.1 {
        didSet { shimmerLayer?.shimmerBeginFadeDuration = shimmerBeginFadeDuration }
    }

    /// The duration of the fade used when the shimmer ends. Defaults to 0.3.
    public var shimmerEndFadeDuration: CFTimeInterval = 0.3 {
        didSet { shimmerLayer?.shimmerEndFadeDuration = shimmerEndFadeDuration }
    }

    /// The absolute CoreAnimation media time when the shimmer will fade in.
    public var shimmerFadeTime: CFTimeInterval? {
        didSet { shimmerLayer?.shimmerFadeTime = shimmerFadeTime }
    }

    override public func layoutSubviews() {
        contentView.bounds = self.bounds
        contentView.center = self.center
        super.layoutSubviews()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private var shimmerLayer: ShimmeringLayer? {
        return (layer as? ShimmeringLayer)
    }

}
#endif
