//
//  Extensions.swift
//  videojournal
//
//  Created by Tyler Thammavong
//
//  UI formatting colors, gradients, background, banner, etc.

import UIKit
import CoreLocation
import AVKit

var xoAssociationKey: Int = 0
extension CALayer {
    
    @objc var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}

extension NSObject{
    
    func matchPattren(CheckString: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return test.evaluate(with: CheckString)
    }
}

extension UIView {
    
    func addColors() {
        
        let lightGreen = UIColor(0xB9D22E)
        let mediumGreen = UIColor(0x70AF1B)
        let darkGreen = UIColor(0x1C7609)
        
        let colors: [UIColor] = [lightGreen,mediumGreen,darkGreen]
        
        let gradientLayer = CAGradientLayer()
        var colorsArray: [CGColor] = []
        var locationsArray: [NSNumber] = []
        
        gradientLayer.frame = self.bounds
        
        for (index, color) in colors.enumerated() {
            
            // append same color twice
            colorsArray.append(color.cgColor)
            colorsArray.append(color.cgColor)
            
            locationsArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index)))
            locationsArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index + 1)))
            
        }
        
        gradientLayer.colors = colorsArray
        gradientLayer.locations = locationsArray
        
        self.backgroundColor = .clear
        self.layer.addSublayer(gradientLayer)
        
        // This can be done outside of this funciton
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
    
    func setGradientBackground(type: CAGradientLayerType! = .axial, colorArray: [CGColor], startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colorArray
        gradientLayer.type = type
        
        //set the ratio there
        gradientLayer.locations = locations
        
        //horizental position
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.opacity = 1
        gradientLayer.masksToBounds = true
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradient(type: CAGradientLayerType! = .axial,
                     startPoint: CAGradientLayer.Point,
                     endPoint: CAGradientLayer.Point,
                     colorArray: [UIColor],
                     fillColor: UIColor? = nil,
                     locations: [NSNumber]? = nil) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
        
        let gradientLayer = CAGradientLayer(start: startPoint, end: endPoint, colors: colorArray.compactMap({$0.cgColor}), type: type)
        
        if let fillColor = fillColor {
            backgroundColor = fillColor
        }else{
            backgroundColor = .clear
        }
        
        gradientLayer.frame = bounds
        gradientLayer.masksToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func captureScreen() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func fadeIn(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
            if let complete = onCompletion { complete() }
        })
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
            self.isHidden = true
            if let complete = onCompletion { complete() }
        })
    }
    
    func popIn(_ duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func bouncingAnimation(isRepeat: Bool = true) {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: isRepeat ? [.autoreverse, .repeat] : [.autoreverse], animations: {
            self.isHidden = false
            var frame = self.frame
            frame.origin.y -= 20
            self.frame = frame
        })
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            
            if(corners.contains(.topLeft)) {
                cornerMask.insert(.layerMinXMinYCorner)
            }
            
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask
            return
        }
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundCornersWith(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }
        
        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }
        
        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }
        
        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        path.closeSubpath()
        cgPath = path
    }
}

extension Float {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    var intValue: Int {
        return Int(self)
    }
}

extension Double {
    
    //Convert Double to int
    func toInt()-> Int {
        return Int(self)
    }
    
    func toString()-> String {
        return String(self)
    }
    
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Int {
    
    func toDouble()-> Double {
        return Double(self)
    }
    
    var floatValue: Float {
        return Float(self)
    }
    
    var stringValue: String {
        return String(self)
    }
    
    var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
}

extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            if components.count > 2 {
                let b = components[2]
                return String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
            }
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255))
        }
        return nil
    }
}

extension String {
    
    var decimals: String {
        return trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
    }
    var doubleValue: Double {
        return Double(self) ?? 0
    }
    
    var floatValue: Float {
        return Float(self) ?? 0
    }
    
    var intValue: Int {
        return Int(self) ?? 0
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

extension String {
    func toNumber()->NSNumber {
        
        let stringValue = self
        
        if let intValue = Int(stringValue as String) {
            return NSNumber(value: intValue)
        }
        
        return 0
    }
    
    var containsAlphabets: Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        }
    }
    
    // MARK: - Localizations
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(withComment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    
}

extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var htmlAttributed: (NSAttributedString?, NSDictionary?) {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return (nil, nil)
            }
            
            var dict:NSDictionary?
            dict = NSMutableDictionary()
            
            return try (NSAttributedString(data: data,
                                           options: [.documentType: NSAttributedString.DocumentType.html,
                                                     .characterEncoding: String.Encoding.utf8.rawValue],
                                           documentAttributes: &dict), dict)
        } catch {
            print("error: ", error)
            return (nil, nil)
        }
    }
    
    func htmlAttributed(using font: UIFont, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
            "html *" +
            "{" +
            "font-size: \(font.pointSize)pt !important;" +
            "color: #\(color.hexString!) !important;" +
            "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
            "html *" +
            "{" +
            "font-size: \(size)pt !important;" +
            "color: #\(color.hexString!) !important;" +
            "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension UITabBar {
    @IBInspectable
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.sizeThatFits(CGSize(width: self.frame.width, height: newValue))
        }
    }
}

extension UISegmentedControl {
    
    func setSelectedGradientBackground() {
        
        var subviews = self.subviews
        if #available(iOS 13.0, *) {
            
            subviews = self.subviews
        } else {
            subviews = self.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        }
        
        for (index, view) in subviews.enumerated() {
            if index == self.selectedSegmentIndex {
                view.backgroundColor = UIColor(patternImage: UIImage(named: "gradiend-background-ic")!)
                view.roundCorners(corners: .allCorners, radius: 7)
            } else {
                view.backgroundColor = UIColor.clear
                view.roundCorners(corners: .allCorners, radius: 7)
            }
        }
    }
    
    func setItemList(items: [String]) {
        
        self.removeAllSegments()
        for (index, value) in items.enumerated() {
            
            self.insertSegment(withTitle: value, at: index, animated: false)
        }
        self.apportionsSegmentWidthsByContent = true
        
        let image = UIImage(named: "gradiend-background-ic")!
        self.subviews.first?.backgroundColor = UIColor(patternImage: image)
        self.subviews.first?.roundCorners(corners: .allCorners, radius: 7)
        
        //Set tint Color
        self.setTintColor()
    }
    
    func setTintColor() {
        self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = UIColor.clear
        } else {
            self.tintColor = UIColor.clear
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIImage {
    public convenience init(url: String) {
        guard let url = URL(string: url) else {
            self.init()
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            self.init()
            return
        }
        self.init(data: data)!
    }
    
    class func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func scale(image: UIImage, by scale: CGFloat) -> UIImage? {
        let size = image.size
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return UIImage.resize(image: image, targetSize: scaledSize)
    }
    
    class func imageWithLabel(label: UILabel) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        label.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    //    func addFilter(filter: Constant.FilterType, intensity: Double) -> UIImage {
    //        let filter = CIFilter(name: filter.rawValue)!
    //
    //        // convert UIImage to CIImage and set as input
    //        let ciInput = CIImage(image: self)
    //        filter.setValue(ciInput, forKey: kCIInputImageKey)
    //
    //        let inputKeys = filter.inputKeys
    //
    //        if inputKeys.contains(kCIInputIntensityKey) {
    //            filter.setValue(intensity, forKey: kCIInputIntensityKey)
    //        }
    //        guard let ciOutput = filter.outputImage else { return self}
    //        let ciContext = CIContext()
    //        let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent)
    //        return UIImage(cgImage: cgImage!)
    //    }
    
    var tag: Int{
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? Int ?? 0
        }
        
        set {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

//MARK:- Float extension for formating price value into commas like '15,600.00'
extension Float {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    var commaRepresentation: String {
        return Float.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension AVAsset {
    
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

extension CLPlacemark {
    
    var compactAddress: String? {
        var result: [String] = []
        
        if let street = thoroughfare {
            result.append(street)
        }
        
        if let city = locality {
            result.append(city)
        }
        
        if let country = country {
            result.append(country)
        }
        
        return result.joined(separator: ", ")
    }
}

extension Encodable {
    func makeJson() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

extension Data {
    func makeJson() throws -> [String: Any] {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
            return dictionary ?? [:]
        } catch {
            throw error
        }
    }
    
    func deviceTokenString() -> String {
        let tokenParts = self.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        return tokenParts.joined()
    }
}

extension CLLocation {
    
    func getAddressFromLatLon(completion: @escaping(String)-> Void) {
        
        // Geocode Location
        CLGeocoder().reverseGeocodeLocation(self) { (placemarks, error) in
            // Process Response
            let result = self.processResponse(withPlacemarks: placemarks, error: error)
            completion(result)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) -> String {
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error.localizedDescription))")
            return "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                print(placemark)
                return placemark.compactAddress ?? ""
            } else {
                return "No Matching Addresses Found"
            }
        }
    }
}

extension UUID {
    static var uuid:String? {
        get {
            return UUID().uuidString
        }
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension Notification.Name {
    static let updateHomeView = Notification.Name("didUpdateHomeView")
    static let updateCardListView = Notification.Name("updateCardListView")
    static let updateCardData = Notification.Name("updateCardData")
}

extension IndexPath {
    
    public func next(in tableView: UITableView) -> IndexPath? {
        var newIndexPath = IndexPath(row: row + 1, section: section)
        if newIndexPath.row >= tableView.numberOfRows(inSection: section) {
            let newSection = section + 1
            newIndexPath = IndexPath(row: 0, section: newSection)
            if newSection >= tableView.numberOfSections {
                return nil
            }
        }
        return newIndexPath
    }
    
    public func previous(in tableView: UITableView) -> IndexPath? {
        var newIndexPath = IndexPath(row: row - 1, section: section)
        if newIndexPath.row < 0 {
            let newSection = section - 1
            if newSection < 0 {
                return nil
            }
            let maxRow = tableView.numberOfRows(inSection: newSection) - 1
            newIndexPath = IndexPath(row: maxRow, section: newSection)
        }
        return newIndexPath
    }
    
    public func next(in collectionView: UICollectionView) -> IndexPath? {
        
        var newIndexPath = IndexPath(row: row + 1, section: section)
        if newIndexPath.row >= collectionView.numberOfItems(inSection: section) {
            let newSection = section + 1
            newIndexPath = IndexPath(item: 0, section: newSection)
            if newSection >= collectionView.numberOfSections {
                return nil
            }
        }
        return newIndexPath
    }
    
    public func previous(in collectionView: UICollectionView) -> IndexPath? {
        
        var newIndexPath = IndexPath(row: row - 1, section: section)
        if newIndexPath.row < 0 {
            let newSection = section - 1
            if newSection < 0 {
                return nil
            }
            let maxRow = collectionView.numberOfItems(inSection: newSection) - 1
            newIndexPath = IndexPath(item: maxRow, section: newSection)
        }
        return newIndexPath
    }
    
}

extension UICollectionView {
    func selectAll() {
        for section in 0..<self.numberOfSections {
            for item in 0..<self.numberOfItems(inSection: section) {
                self.selectItem(at: IndexPath(item: item, section: section), animated: false, scrollPosition: [])
            }
        }
    }
    
    func deSelectAll() {
        for section in 0..<self.numberOfSections {
            for item in 0..<self.numberOfItems(inSection: section) {
                self.deselectItem(at: IndexPath(item: item, section: section), animated: false)
            }
        }
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension CGRect {
    public init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0, width: size.width, height: size.height)
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

//extension Auth {
//    static var authId:String? {
//        get {
//            return Auth.auth().currentUser?.uid
//        }
//    }
//}

extension UILabel {
    
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            return 0
        }
    }
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}


extension NSMutableAttributedString {
    func setAttributedString(on value: String, font: UIFont) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    static func makeHyperlink(/*for path: String,*/ in string: String, as substring: String) -> NSRange {
        
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        return substringRange
    }
}


extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension UIButton {
    func underline() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font:  self.titleLabel!.font!,
            .foregroundColor: self.titleLabel!.textColor!,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(string: self.titleLabel?.text ?? "", attributes: attributes)
        self.setAttributedTitle(attributeString, for: .normal)
    }
    
    var index: Int{
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? Int ?? 0
        }
        
        set {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension UINavigationBar {
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}

extension URL {
    public func mimeType() -> String {
        if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
    
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        AVAsset(url: self).generateThumbnail(completion: completion)
    }
    
    func createVideoThumbnail(completion: @escaping ((UIImage?)->Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: self)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumbnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

extension CGFloat {
    var double: CGFloat {
        return self*2
    }
    
    var half: CGFloat {
        return self/2
    }
    
    var eighth: CGFloat {
        return self / 2
    }
    
    var quarter: CGFloat {
        return self / 4
    }
    
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
