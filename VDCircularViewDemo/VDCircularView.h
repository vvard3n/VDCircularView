//
//  VDCircularView.h
//
//  Created by Harwyn T'an on 2017/5/5.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VDCircularView;

@protocol VDCircularViewDelegate <NSObject>

- (void)vd_circularView:(VDCircularView *)circularView atIndexPath:(NSIndexPath *)indexPath;

@end

@interface VDCircularModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgSrc;

@end

typedef NS_OPTIONS(NSUInteger, VDCircularViewAutoScrollType) {
    VDCircularViewAutoScrollTypeLeft = 1 << 0,
    VDCircularViewAutoScrollTypeRight = 1 << 1,
};

@interface VDCircularView : UIView
/**
 最小间距
 */
@property (nonatomic, assign) CGFloat minimumLineSpacing;
/**
 缩放系数
 */
@property (nonatomic, assign) CGFloat scaleFactor;

/**
 item大小
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 自动轮播
 */
@property (nonatomic, assign) BOOL autoScroll;

/**
 自动轮播方向
 */
@property (nonatomic, assign) VDCircularViewAutoScrollType autoScrollType;

@property (nonatomic, strong) NSArray <VDCircularModel *>*datas;

@property (nonatomic, weak) id <VDCircularViewDelegate> delegate;

- (void)stopAutoScroll;
- (void)startAutoScroll;

@end

@interface VDCircularViewCell : UICollectionViewCell

@property (nonatomic, strong) VDCircularModel *model;

@end
