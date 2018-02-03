//
//  HUDView.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 2/3/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import UIKit

class HUDView: UIView {
	var text = ""
	
	class func hud(inView view: UIView, animated: Bool) -> HUDView {
		let hudView = HUDView(frame: view.bounds)
		
		hudView.isOpaque = false
		
		view.addSubview(hudView)
		view.isUserInteractionEnabled = false
		
		hudView.show(animated: animated)
		
		return hudView
	}

	override func draw(_ rect: CGRect) {
		let boxWidth: CGFloat = 96
		let boxHeight: CGFloat = 96
		
		let boxRect = CGRect(
			x: round((bounds.size.width - boxWidth) / 2),
			y: round((bounds.size.height - boxHeight) / 2),
			width: boxWidth,
			height: boxHeight)
		
		let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
		
		UIColor(white: 0.3, alpha: 0.8).setFill()
		roundedRect.fill()
	}
	
	// MARK:- Public methods
	
	func show(animated: Bool) {
		if animated {
			// 1
			alpha = 0
			transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
			// 2
			UIView.animate(withDuration: 0.3, delay: 0,
				usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
				options: [], animations: {
				self.alpha = 1
				self.transform = CGAffineTransform.identity
				}, completion: nil)
		}
	}
	
	func hide() {
		superview?.isUserInteractionEnabled = true
		removeFromSuperview()
	}
	
}
