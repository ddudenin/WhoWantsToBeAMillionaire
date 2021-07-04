//
//  AnswersCollectionViewLayout.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 12.06.2021.
//

import UIKit

final class AnswersCollectionViewLayout: UICollectionViewFlowLayout {
    
    private var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var contentSize = CGSize(width: 0, height: 0)
    
    override func prepare() {
        super.prepare()
        
        self.cacheAttributes = [:]
        
        guard let collectionView = self.collectionView else { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        guard itemsCount > 0 else { return }
        
        let insets: CGFloat = 5
        
        self.contentSize = CGSize(width: UIScreen.main.bounds.width - 3 * insets, height: collectionView.bounds.height - 3 * insets)
        
        let cellWidth = ceil((collectionView.frame.width - 3 * insets) / 2)
        
        var lastY: CGFloat = insets
        var lastX: CGFloat = insets
        
        let rowCount = itemsCount / 2
        let cellHeight = ceil(self.contentSize.height / CGFloat(rowCount))
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = CGRect(x: lastX, y: lastY,
                                      width: cellWidth, height: cellHeight)
            
            if (index + 1) % 2 == 0 {
                lastX = insets
                lastY += cellHeight + insets
            } else {
                lastX += cellWidth + insets
            }
            
            self.cacheAttributes[indexPath] = attributes
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in self.cacheAttributes.values {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
}

