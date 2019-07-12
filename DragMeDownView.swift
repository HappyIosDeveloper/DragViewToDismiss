//
//  DragMeDownView.swift
//  DragMeDown
//
//  Created by Alfredo Uzumaki on 7/12/19.
//  Copyright © 2019 Alfredo Uzumaki. All rights reserved.
//

import UIKit

class DragMeDownView: UIView {
    
    @IBInspectable
    var showBottomLine: Bool = true
    @IBInspectable
    var collapsedHeight: CGFloat = 80
    var bottomLine = UIView()
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint!
    var originalFrame:CGRect!
    var currentPositionTouched: CGPoint?
    var allowMove = true
    var collapsed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestures()
        if showBottomLine {
            createButtomLine()
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func createButtomLine() {
        let width = 30
        let x = (self.frame.width / 2) - CGFloat(width / 2)
        let y = (self.frame.maxY - 8) - 8
        bottomLine.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: 6))
        addSubview(bottomLine)
        bottomLine.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4933703785)
        bottomLine.layer.cornerRadius = bottomLine.frame.height / 2
        bringSubviewToFront(bottomLine)
        bottomLine.tag = 777
    }
    
    func hideSubViews() {
        UIView.animate(withDuration: 0.4) {
            self.subviews.filter({$0.tag != 777}).forEach({$0.alpha = 0})
            self.layoutIfNeeded()
        }
    }
    
    func showSubViews() {
        UIView.animate(withDuration: 0.4) {
            self.subviews.filter({$0.tag != 777}).forEach({$0.alpha = 1})
            self.layoutIfNeeded()
        }
    }
}

extension DragMeDownView {
    
    func addGestures() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        addGestureRecognizer(panGestureRecognizer!)
        originalPosition = center
        originalFrame = frame
    }
    
    func removeGustures() {
        if panGestureRecognizer != nil {
            self.removeGestureRecognizer(panGestureRecognizer!)
        }
    }
    
    func backToOriginPlace() {
        allowMove = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame.origin = CGPoint(x: self.originalFrame.minX, y: self.originalFrame.minY)
            self.transform = .identity
        }, completion: { (isCompleted) in
            self.allowMove = true
            self.collapsed = false
            self.showSubViews()
        })
    }
    
    func collapse() {
        allowMove = false
        hideSubViews()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame.origin = CGPoint(x: self.originalFrame.minX, y: self.collapsedHeight - self.originalFrame.height)
            self.transform = .identity
        }, completion: { (isCompleted) in
            self.allowMove = true
            self.collapsed = true
        })
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        if allowMove {
            if self.frame.minY > (self.frame.height/2) {
                backToOriginPlace()
            } else if self.frame.minY < collapsedHeight {
                if collapsed {
                    backToOriginPlace()
                } else {
                    collapse()
                }
            } else {
                let translation = panGesture.translation(in: self)
                if panGesture.state == .began {
                    currentPositionTouched = panGesture.location(in: self)
                } else if panGesture.state == .changed {
                    if self.frame.minY >= originalFrame.minY {
                        self.frame.origin = CGPoint(x: originalPosition!.x - (self.originalFrame.width/2), y: translation.y + (self.originalFrame.height/4))
                    } else {
                        backToOriginPlace()
                    }
                } else if panGesture.state == .ended {
                    let velocity = panGesture.velocity(in: self)
                    if velocity.y >= originalFrame.minY {
                        backToOriginPlace()
                    } else {
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                            self.center = self.originalPosition!
                        }, completion: nil)
                    }
                }
            }
        }
    }
}

extension DragMeDownView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
