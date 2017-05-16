//
//  VDCircularLayout.m
//
//  Created by Harwyn T'an on 2017/5/5.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "VDCircularLayout.h"

@interface VDCircularLayout ()
//@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (nonatomic, assign) NSInteger index;

@end

@implementation VDCircularLayout

// 初始化方法
- (instancetype)init
{
    if (self == [super init]) {
        self.index = 0;
        self.itemLoseFocusAlpha = 1.0;
    }
    return self;
}

- (CGSize)collectionViewContentSize
{
    return [super collectionViewContentSize];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGRect visibleRect;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        visibleRect= CGRectMake(self.collectionView.contentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    else {
        visibleRect = CGRectMake(0,self.collectionView.contentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    NSArray *visibleItemArray =[[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:visibleRect] copyItems:YES];
    NSInteger closest_index = 0;
    CGFloat distanceToCenter = 10000.0;
    CGFloat zIndex = 0;
    for (UICollectionViewLayoutAttributes *attributes in visibleItemArray)
    {
        
        CGFloat scale = 0;
        CGFloat absOffset = 0;
        
        if (self.scaleFactor > 0) {
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                CGFloat leftMargin = attributes.center.x - self.collectionView.contentOffset.x;
                CGFloat halfCenterX = self.collectionView.frame.size.width / 2;
                absOffset = fabs(halfCenterX - leftMargin);
                scale = 1 - absOffset / halfCenterX;
            }
            else {
                CGFloat topMargin = attributes.center.y - self.collectionView.contentOffset.y;
                CGFloat halfCenterY = self.collectionView.frame.size.height / 2;
                absOffset = fabs(halfCenterY - topMargin);
                scale = 1 - absOffset / halfCenterY;
            }
            attributes.transform3D = CATransform3DMakeScale(1 + scale * (self.scaleFactor - 1), 1 + scale * (self.scaleFactor - 1),1);
        }
        if (self.itemLoseFocusAlpha > 0||self.itemLoseFocusAlpha < 1) {
            if (scale < self.itemLoseFocusAlpha)
            {
                attributes.alpha = self.itemLoseFocusAlpha;
            }
            else if (scale > 0.99)
            {
                attributes.alpha = 1.0;
            }
            else
            {
                attributes.alpha = scale;
            }
        }
        
        if (absOffset < distanceToCenter) {
            attributes.zIndex = zIndex;
            zIndex++;
            distanceToCenter = absOffset;
            closest_index = [visibleItemArray indexOfObject:attributes];
        }
        else {
            zIndex--;
            attributes.zIndex = zIndex;
            
        }
    }
    if (visibleItemArray && visibleItemArray.count > 0) {
        UICollectionViewLayoutAttributes *closest_attribute = visibleItemArray[closest_index];
        closest_attribute.zIndex = 1000;
    }
    return visibleItemArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGPoint pInView = [self.collectionView.superview convertPoint:self.collectionView.center toView:self.collectionView];
    
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    
    if (indexPathNow.row == 0)
    {
        if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
            if (newBounds.origin.x < [UIScreen mainScreen].bounds.size.width / 2) {
                if (_index != indexPathNow.row) {
                    _index = 0;
                    
                }
            }
        }
        else {
            if (newBounds.origin.y < [UIScreen mainScreen].bounds.size.height / 2) {
                if (_index != indexPathNow.row) {
                    _index = 0;
                }
            }
        }
    }
    else {
        if (_index != indexPathNow.row) {
            _index = indexPathNow.row;
        }
    }
    
    [super shouldInvalidateLayoutForBoundsChange:newBounds];
    
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat minOffset = CGFLOAT_MAX;
    CGFloat horizontalCenter = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;
    CGFloat verticalCenter = proposedContentOffset.y+self.collectionView.bounds.size.height/2;
    
    CGRect visibleRect;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        visibleRect= CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    else {
        visibleRect = CGRectMake(0,proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    NSArray *visibleAttributes = [super layoutAttributesForElementsInRect:visibleRect];
    
    for (UICollectionViewLayoutAttributes *atts in visibleAttributes)
    {
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            CGFloat itemCenterX = atts.center.x;
            if (fabs(itemCenterX - horizontalCenter) <= fabs(minOffset)) {
                minOffset = itemCenterX - horizontalCenter;
            }
        }
        else {
            CGFloat itemCenterY = atts.center.y;
            if (fabs(itemCenterY - verticalCenter) <= fabs(minOffset)) {
                minOffset = itemCenterY - verticalCenter;
            }
        }
    }
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat centerOffsetX = proposedContentOffset.x + minOffset;
        if (centerOffsetX < 0) {
            centerOffsetX = 0;
        }
        
        if (centerOffsetX > self.collectionView.contentSize.width -(self.sectionInset.left + self.sectionInset.right + self.itemSize.width)) {
            centerOffsetX = floor(centerOffsetX);
        }
        return CGPointMake(centerOffsetX, proposedContentOffset.y);
    }
    else {
        CGFloat centerOffsetY = proposedContentOffset.y + minOffset;
        if (centerOffsetY < 0) {
            centerOffsetY = 0;
        }
        
        if (centerOffsetY > self.collectionView.contentSize.height -(self.sectionInset.top + self.sectionInset.bottom + self.itemSize.height)) {
            centerOffsetY = floor(centerOffsetY);
        }
        return CGPointMake(proposedContentOffset.x, centerOffsetY);
    }
}


@end
