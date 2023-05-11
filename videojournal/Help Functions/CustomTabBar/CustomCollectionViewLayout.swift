//
//  CustomCollectionViewLayout.swift
//  videojournal
//
//  Created by Tyler Thammavong
//

import UIKit

protocol CustomCollectionViewLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class CustomCollectionViewLayout : UICollectionViewLayout {
    weak var delegate: CustomCollectionViewLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPaddingInRows: CGFloat = 8.5
    private let cellPaddingInColumns: CGFloat = 7
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
        
    override func prepare() {
        super.prepare()
        
        guard
            cache.isEmpty,
            let collectionView = collectionView
        else {
            return
        }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPaddingInRows * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPaddingInRows, dy: cellPaddingInColumns)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
//class CustomCollectionViewLayout : UICollectionViewLayout {
//    fileprivate var cache = [IndexPath: UICollectionViewLayoutAttributes]()
//    fileprivate var cellPadding: CGFloat = 17
//    fileprivate var contentHeight: CGFloat = 0
//    var oldBound: CGRect!
//    let numberOfColumns: Int = 10
//    var cellHeight: CGFloat = 255
//
//    fileprivate var contentWidth: CGFloat {
//        guard let collectionView = collectionView else {
//            return 0
//        }
//        let insets = collectionView.contentInset
//        return collectionView.bounds.width - (insets.left + insets.right)
//    }
//
//    override var collectionViewContentSize: CGSize {
//        return CGSize(width: contentWidth, height: contentHeight)
//    }
//
//    override func prepare() {
//        super.prepare()
//        contentHeight = 0
//        cache.removeAll(keepingCapacity: true)
//        guard cache.isEmpty == true, let collectionView = collectionView else {
//            return
//        }
//        if collectionView.numberOfSections == 0 {
//            return
//        }
//
//        let cellWidth = contentWidth / CGFloat(numberOfColumns)
//        cellHeight = cellWidth / 720 * 1220
//
//        var xOffset = [CGFloat]()
//        for column in 0 ..< numberOfColumns {
//            xOffset.append(CGFloat(column) * cellWidth)
//        }
//
//        var column = 0
//        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
//
//        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
//            let indexPath = IndexPath(item: item, section: 0)
//            var newheight = cellHeight
//            if column == 0 {
//             newheight = ((yOffset[column + 1] - yOffset[column]) > cellHeight * 0.3) ? cellHeight : (cellHeight * 0.90)
//            }
//
//            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: newheight)
//            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            attributes.frame = insetFrame
//
//            cache[indexPath] = (attributes)
//            contentHeight = max(contentHeight, frame.maxY)
//            yOffset[column] = yOffset[column] + newheight
//
//            if column >= (numberOfColumns - 1) {
//                column = 0
//            } else {
//                column = column + 1
//            }
//        }
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
//        // Loop through the cache and look for items in the rect
//        visibleLayoutAttributes = cache.values.filter({ (attributes) -> Bool in
//            return attributes.frame.intersects(rect)
//        })
//        print(visibleLayoutAttributes)
//        return visibleLayoutAttributes
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        // print(cache[indexPath.item])
//        return cache[indexPath]
//    }
//}
