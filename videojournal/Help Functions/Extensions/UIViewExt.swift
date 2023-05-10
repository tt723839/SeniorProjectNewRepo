//
//  UIviewExt.swift
//
//  Created by Tyler Thammavong
//
//  UIViewcontroller restraints

import UIKit

extension UIView {
    
    // set the anchors of a view
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }
        if let left = leading {
            anchors.append(leadingAnchor.constraint(equalTo: left, constant: padding.left))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }
        if let right = trailing {
            anchors.append(trailingAnchor.constraint(equalTo: right, constant: -padding.right))
        }
        if size.width != 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: size.width))
        }
        if size.height != 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: size.height))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    @discardableResult
    func anchorToSuperview() -> [NSLayoutConstraint] {
        return anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func add(view: UIView, left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: left).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: right).isActive = true
        
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: top).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom).isActive = true
        
    }
    
    func setSize( width : CGFloat ,  height : CGFloat)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if  height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
            
        }
    }
    
    func center(centerX : NSLayoutXAxisAnchor? , paddingX : CGFloat   ,
                centerY : NSLayoutYAxisAnchor? , paddingY : CGFloat)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX , constant: paddingX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY , constant: paddingY).isActive = true
        }
        
    }
    
    func center(centerX : NSLayoutXAxisAnchor? , centerY : NSLayoutYAxisAnchor?)  {
        
        self.center(centerX: centerX, paddingX: 0, centerY: centerY, paddingY: 0)
        
    }
}

public extension UIView {
    
    private static let kLayerNameGradientBorder = "GradientBorderLayer"
    
    func gradientBorder(width: CGFloat,
                        colors: [UIColor],
                        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
                        andRoundCornersWithRadius cornerRadius: CGFloat = 0) {
        
        let existingBorder = gradientBorderLayer()
        let border = existingBorder ?? CAGradientLayer()
        border.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y,
                              width: bounds.size.width + width, height: bounds.size.height + width)
        border.colors = colors.map { return $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint
        
        let mask = CAShapeLayer()
        let maskRect = CGRect(x: bounds.origin.x + width/2, y: bounds.origin.y + width/2,
                              width: bounds.size.width - width, height: bounds.size.height - width)
        mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width
        
        border.mask = mask
        
        let exists = (existingBorder != nil)
        if !exists {
            layer.addSublayer(border)
        }
    }
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }
    
    func addDashedCircle() {
        self.borderWidth = 0
        let circleLayer = CAShapeLayer()
        circleLayer.lineWidth = 2.0
        let rect = bounds.insetBy(dx: circleLayer.lineWidth / 2, dy: circleLayer.lineWidth / 2)
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        circleLayer.path = path.cgPath
        circleLayer.strokeColor =  UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineJoin = .round
        circleLayer.lineDashPattern = [8,4]
        layer.addSublayer(circleLayer)
    }
}

extension CAGradientLayer {
    enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        var point: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    convenience init(start: Point, end: Point, colors: [CGColor], type: CAGradientLayerType) {
        self.init()
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        self.type = type
    }
}


extension UIView {
    
    @IBInspectable var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
            
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

extension UIView {
    var viewWidth: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    
    var viewHeight: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var rect = self.frame
            rect.origin.y = newValue - self.frame.size.height
            self.frame = rect
        }
    }
    
    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var rect = self.frame
            rect.origin.y = newValue - self.frame.size.width
            self.frame = rect
        }
    }
    
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        else { fatalError("missing expected nib named: \(name)") }
        guard
            let view = nib.first as? Self
        else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}
