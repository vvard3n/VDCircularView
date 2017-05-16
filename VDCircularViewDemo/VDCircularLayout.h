//
//  VDCircularLayout.h
//
//  Created by Harwyn T'an on 2017/5/5.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VDCircularLayoutDelegate <UICollectionViewDelegateFlowLayout>

@end

@interface VDCircularLayout : UICollectionViewFlowLayout

/**
 缩放系数
 */
@property (nonatomic, assign) CGFloat scaleFactor;

/**
 Item失去焦点时的透明度
 Float(0.0 - 1.0)
 */
@property (nonatomic, assign) CGFloat itemLoseFocusAlpha;

@property (nonatomic, weak) id <VDCircularLayoutDelegate> delegate;

@end
