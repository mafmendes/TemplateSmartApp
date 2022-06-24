//
//  MaterialLoadingIndicator.swift
//  scenekit_Tet
//
//  Created by Oliveira, Jorge Moreira de on 06/05/2021.
//

import Foundation
import UIKit
import SwiftUI
//
import Resources
import AppConstants
import Common
import BaseUI

public typealias MaterialLoadingIndicator = App_Designables_UIKit.MaterialLoadingIndicator

//
//
// MARK: Sugar: extensions
//

public extension AnyView {
    func addMaterialLoading(using input: VM.MaterialLoadingIndicator.ViewInput) -> some View {
        let loadingView = App_Designables_UIKit.MaterialLoadingIndicator.default(with: input.radius,
                                                                                 lineWidth: input.lineWidth).asAnyView
            .frame(width: 0, height: 0) // DONT DELETE ELSE OVERLAY POSITION BREAKS
        
        return self
            .doIf(input.isLoading) {
                $0.alpha(0)
            .overlay(loadingView)
        }
    }
}

//
// MARK: Sugar
//

public extension App_Designables_UIKit.MaterialLoadingIndicator {
        
    static var defaultRadius: CGFloat {
        SizeNames.size_3.cgFloat
    }
    
    var asAnyView: AnyView {
        let view = UIView()
        view.addSubview(self)
        return view.common.asAnyView
    }
    
    static func `default`(with radius: CGFloat = defaultRadius,
                          lineWidth: (CGFloat, CGFloat)? = nil,
                          startAnimating: Bool = true) -> App_Designables_UIKit.MaterialLoadingIndicator {
        let color = ColorSemantic.labelPrimary.uiColor
        let loading = App_Designables_UIKit.MaterialLoadingIndicator(radius: radius,
                                               color: color,
                                               trackingColor: .lightGray.alpha(0.3))
        if let lineWidth = lineWidth {
            loading.line1Width = lineWidth.0
            loading.line2Width = lineWidth.1
        } else {
            loading.line1Width = CommonNameSpace.ColorScheme.current == .light ? 2 : 2
            loading.line2Width = 1
        }

        if startAnimating {
            loading.startAnimating()
        }
        return loading
    }
    
}

//
// MARK: Implementation
//

public extension App_Designables_UIKit {
    
    //
    // https://github.com/twho/loading-buttons-ios/blob/master/LoadingButtons/Indicators/MaterialLoadingIndicator.swift
    //
    class Indicator: UIView, IndicatorProtocol {
        
        open var isAnimating: Bool = false
        open var radius: CGFloat = 18.0
        open var color: UIColor = .gray
        open var trackingColor: UIColor?

        public convenience init(radius: CGFloat = 18.0, color: UIColor = .gray, trackingColor: UIColor? = nil) {
            self.init()
            self.radius = radius
            self.color = color
            self.trackingColor = trackingColor
        }
        
        open func startAnimating() {
            guard !isAnimating else { return }
            isHidden = false
            isAnimating = true
            layer.speed = 1
            setupAnimation(in: layer, size: CGSize(width: 2 * radius, height: 2 * radius))
        }
        
        open func stopAnimating() {
            guard isAnimating else { return }
            isHidden = true
            isAnimating = false
            layer.sublayers?.removeAll()
        }
        
        open func setupAnimation(in layer: CALayer, size: CGSize) {
            fatalError("Need to be implemented")
        }
    }
    
    class MaterialLoadingIndicator: Indicator {
                
        fileprivate let drawableLayer = CAShapeLayer()
        fileprivate let trackingDrawableLayer = CAShapeLayer()

        override open var color: UIColor {
            didSet {
                drawableLayer.strokeColor = color.cgColor
            }
        }
        
        override open var trackingColor: UIColor? {
            didSet {
                trackingDrawableLayer.strokeColor = trackingColor!.cgColor
            }
        }

        @IBInspectable open var line1Width: CGFloat = 1 {
            didSet {
                drawableLayer.lineWidth = line1Width
                trackingDrawableLayer.lineWidth = line2Width
                updatePath()
            }
        }
        
        @IBInspectable open var line2Width: CGFloat = 2 {
            didSet {
                drawableLayer.lineWidth = line1Width
                trackingDrawableLayer.lineWidth = line2Width
                updatePath()
            }
        }
        
        open override var bounds: CGRect {
            didSet {
                updateFrame()
                updatePath()
            }
        }
        
        public convenience init(radius: CGFloat = 18.0, color: UIColor = .gray, trackingColor: UIColor? = nil) {
            self.init()
            self.radius = radius
            self.color = color
            self.trackingColor = trackingColor
            setup()
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            updateFrame()
            updatePath()
        }
        
        override open func startAnimating() {
            if isAnimating {
                return
            }
            isAnimating = true
            isHidden = false
            // Size is unused here.
            setupAnimation(in: drawableLayer, size: .zero)
        }
        
        override open func stopAnimating() {
            drawableLayer.removeAllAnimations()
            isAnimating = false
            isHidden = true
        }
        
        fileprivate func setup() {
            isHidden = true
            layer.addSublayer(trackingDrawableLayer)
            layer.addSublayer(drawableLayer)

            drawableLayer.strokeColor = color.cgColor
            drawableLayer.lineWidth = line1Width
            drawableLayer.fillColor = UIColor.clear.cgColor
            drawableLayer.lineJoin = .round
            drawableLayer.strokeStart = 0.99
            drawableLayer.strokeEnd = 1
            
            if let trackingColor = trackingColor {
                trackingDrawableLayer.strokeColor = trackingColor.cgColor
            } else {
                trackingDrawableLayer.strokeColor = UIColor.clear.cgColor
            }
            
            trackingDrawableLayer.lineWidth = line2Width
            trackingDrawableLayer.fillColor = UIColor.clear.cgColor
            trackingDrawableLayer.lineJoin = .round
            trackingDrawableLayer.strokeStart = 0
            trackingDrawableLayer.strokeEnd = 1
            
            updateFrame()
            updatePath()
        }
        
        fileprivate func updateFrame() {
            drawableLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            trackingDrawableLayer.frame = drawableLayer.frame
        }
        
        fileprivate func updatePath() {
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            let radius: CGFloat = radius - line1Width
            
            drawableLayer.path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: 0,
                endAngle: CGFloat(2 * Double.pi),
                clockwise: true
            ).cgPath
            trackingDrawableLayer.path = drawableLayer.path
        }
        
        override open func setupAnimation(in layer: CALayer, size: CGSize) {
            layer.removeAllAnimations()
            
            let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnim.fromValue = 0
            rotationAnim.duration = 4
            rotationAnim.toValue = 2 * Double.pi
            rotationAnim.repeatCount = Float.infinity
            rotationAnim.isRemovedOnCompletion = false
            
            let startHeadAnim = CABasicAnimation(keyPath: "strokeStart")
            startHeadAnim.beginTime = 0.1
            startHeadAnim.fromValue = 0
            startHeadAnim.toValue = 0.25
            startHeadAnim.duration = 1
            startHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            let startTailAnim = CABasicAnimation(keyPath: "strokeEnd")
            startTailAnim.beginTime = 0.1
            startTailAnim.fromValue = 0
            startTailAnim.toValue = 1
            startTailAnim.duration = 1
            startTailAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            let endHeadAnim = CABasicAnimation(keyPath: "strokeStart")
            endHeadAnim.beginTime = 1
            endHeadAnim.fromValue = 0.25
            endHeadAnim.toValue = 0.99
            endHeadAnim.duration = 0.5
            endHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            let endTailAnim = CABasicAnimation(keyPath: "strokeEnd")
            endTailAnim.beginTime = 1
            endTailAnim.fromValue = 1
            endTailAnim.toValue = 1
            endTailAnim.duration = 0.5
            endTailAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            let strokeAnimGroup = CAAnimationGroup()
            strokeAnimGroup.duration = 1.5
            strokeAnimGroup.animations = [startHeadAnim, startTailAnim, endHeadAnim, endTailAnim]
            strokeAnimGroup.repeatCount = Float.infinity
            strokeAnimGroup.isRemovedOnCompletion = false
            
            layer.add(rotationAnim, forKey: "rotation")
            layer.add(strokeAnimGroup, forKey: "stroke")
        }
    }
}

public protocol IndicatorProtocol {
    /**
     The radius of the indicator.
     */
    var radius: CGFloat { get set }
    /**
     The primary color of the indicator.
     */
    var color: UIColor { get set }
    /**
     The primary color of the indicator.
     */
    var trackingColor: UIColor? { get set }
    /**
     Current status of animation, read-only.
     */
    var isAnimating: Bool { get }
    /**
     Start animating.
     */
    func startAnimating()
    /**
     Stop animating and remove layer.
     */
    func stopAnimating()
    /**
     Set up the animation of the indicator.
     
     - Parameter layer: The layer to present animation.
     - Parameter size:  The size of the animation.
     */
    func setupAnimation(in layer: CALayer, size: CGSize)
}

//
// MARK: Preview
//

#if canImport(SwiftUI) && DEBUG
public struct Designables_Previews_MaterialLoadingIndicator {
    private init() { }

    open class PreviewVC: BasePreviewVC {
        let loading = App_Designables_UIKit.MaterialLoadingIndicator.default()
        public override func loadView() {
            super.loadView()
            view.addSubview(loading)
            loading.layouts.centerToSuperview()
        }
    }
    struct Preview: PreviewProvider {
        static var previews: some View {
            PreviewVC().asAnyView.buildPreviews()
        }
    }
}
#endif
