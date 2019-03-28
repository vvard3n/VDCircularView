//
//  VDCircularView.m
//
//  Created by Harwyn T'an on 2017/5/5.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "VDCircularView.h"
#import "VDCircularLayout.h"
//#import <YYKit/UIImageView+YYWebImage.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface VDCircularView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) VDCircularLayout *flowLayout;
@property (nonatomic, weak) UICollectionView *circularView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign) CGFloat currentOffsetX;

@end

@implementation VDCircularView

- (void)setItemSize:(CGSize)itemSize {
    if (itemSize.height < self.bounds.size.height * 0.6) {
        itemSize.height = self.bounds.size.height * 0.6 ;
    }
    
    _itemSize = itemSize;
    self.flowLayout.itemSize = itemSize;
}

- (void)setDatas:(NSArray<VDCircularModel *> *)datas {
    _datas = datas;
    if (datas.count > 0) {
        NSMutableArray *marr;
        if (datas.count == 1) {
            marr = [NSMutableArray arrayWithCapacity:datas.count * 5];
            [marr addObjectsFromArray:datas];
            [marr addObjectsFromArray:datas];
            [marr addObjectsFromArray:datas];
            [marr addObjectsFromArray:datas];
            [marr addObjectsFromArray:datas];
        }
        else {
            marr = [NSMutableArray arrayWithCapacity:datas.count * 3];
            [marr addObjectsFromArray:datas];
            [marr addObjectsFromArray:datas];
            [marr addObjectsFromArray:datas];
        }
        _datas = marr.copy;
    }
    [self.circularView reloadData];
    if (_autoScroll) {
        [self startAutoScroll];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.circularView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    self.flowLayout.itemSize = self.itemSize;
    
    self.circularView.contentOffset = CGPointMake((self.datas.count / 3) * (self.flowLayout.itemSize.width + self.minimumLineSpacing) - (self.bounds.size.width - self.flowLayout.itemSize.width) * 0.5, 0);
    _currentOffsetX = (self.datas.count / 3) * (self.flowLayout.itemSize.width + self.minimumLineSpacing) - (self.bounds.size.width - self.flowLayout.itemSize.width) * 0.5;
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
    _minimumLineSpacing = minimumLineSpacing;
    self.flowLayout.minimumLineSpacing = minimumLineSpacing;
}

- (void)setScaleFactor:(CGFloat)scaleFactor {
    _scaleFactor = scaleFactor;
    self.flowLayout.scaleFactor = scaleFactor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self.circularView reloadData];
}

- (void)setShadowEnable:(BOOL)shadowEnable {
    _shadowEnable = shadowEnable;
    [self.circularView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        VDCircularLayout *collectionViewFlowLayout = [[VDCircularLayout alloc] init];
        self.flowLayout = collectionViewFlowLayout;
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionViewFlowLayout.minimumInteritemSpacing = 0;
        collectionViewFlowLayout.minimumLineSpacing = 0;
        UICollectionView *circularView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:collectionViewFlowLayout];
        circularView.backgroundColor = [UIColor lightGrayColor];
        self.circularView = circularView;
        circularView.backgroundColor = [UIColor whiteColor];
        circularView.showsHorizontalScrollIndicator = NO;
        circularView.showsVerticalScrollIndicator = NO;
        circularView.delegate = self;
        circularView.dataSource = self;
        circularView.decelerationRate = 0;
        [circularView registerClass:[VDCircularViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:circularView];
        
        self.autoScrollDuration = 3;
        self.itemSize = CGSizeMake(kScreenWidth - 2 * 50, (kScreenWidth - 2 * 50) / 16.0 * 9);
        self.cornerRadius = 0;
        self.autoScrollType = VDCircularViewAutoScrollTypeLeft;
        self.minimumLineSpacing = 0;
        self.scaleFactor = 1;
        self.autoScroll = NO;
    }
    return self;
}

#pragma mark UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VDCircularViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.datas[indexPath.item];
    cell.cornerRadius = self.cornerRadius;
    cell.shadowEnable = self.shadowEnable;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(vd_circularView:atIndexPath:)]) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:indexPath.item - self.datas.count / 3 inSection:0];
        [self.delegate vd_circularView:self atIndexPath:indexpath];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

#pragma mark UIScrollViewDelegate
/**
 滚动中，此方法中实现无限轮播
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat locX = scrollView.contentOffset.x;
    CGFloat itemWidth = (self.flowLayout.itemSize.width + self.minimumLineSpacing);
    CGFloat marginWidth = (self.bounds.size.width - self.flowLayout.itemSize.width) * 0.5;
    CGFloat maxLeftX = (self.datas.count / 3 - 1) * itemWidth - marginWidth;
    CGFloat maxRightX = (self.datas.count / 3 * 2) * itemWidth - marginWidth;
    if (locX <= maxLeftX) {
        CGFloat lastItemLocX = (self.datas.count / 3 * 2 - 1) * itemWidth - marginWidth;
        [scrollView setContentOffset:CGPointMake(lastItemLocX, 0) animated:NO];
        _currentOffsetX = lastItemLocX;
    }
    else if (locX >= maxRightX) {
        CGFloat firstItemLocX = (self.datas.count / 3) * itemWidth - marginWidth;
        [scrollView setContentOffset:CGPointMake(firstItemLocX, 0) animated:NO];
        _currentOffsetX = firstItemLocX;
    }
}

/**
 即将开始滑动减速
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (fabs(scrollView.contentOffset.x - _currentOffsetX) > 0.333 * (self.minimumLineSpacing + self.flowLayout.itemSize.width)) {
        
        if (scrollView.contentOffset.x > _currentOffsetX) {
            [scrollView setContentOffset:CGPointMake(_currentOffsetX + self.minimumLineSpacing + self.flowLayout.itemSize.width, 0) animated:YES];
            _currentOffsetX += self.minimumLineSpacing + self.flowLayout.itemSize.width;
        }
        else{
            [scrollView setContentOffset:CGPointMake(_currentOffsetX - self.minimumLineSpacing - self.flowLayout.itemSize.width, 0) animated:YES];
            _currentOffsetX -= self.minimumLineSpacing + self.flowLayout.itemSize.width;
        }
        
    }
    else {
        [scrollView setContentOffset:CGPointMake(_currentOffsetX, 0) animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startAutoScroll];
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    self.currentOffsetX = scrollView.contentOffset.x;
//}

#pragma mark autoScorll
- (void)startAutoScroll {
    [self stopAutoScroll];
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.autoScrollDuration target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    NSLog(@"自动轮播开始");
}

- (void)stopAutoScroll {
    NSLog(@"自动轮播结束");
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage {
    UICollectionViewLayoutAttributes *attribute = [self.circularView.collectionViewLayout layoutAttributesForElementsInRect:(CGRect){self.circularView.contentOffset.x, 0, self.circularView.bounds.size.width, self.circularView.bounds.size.height}][1];
    NSIndexPath *indexPath = attribute.indexPath;
    NSIndexPath *nextIndexPath;
    if (self.autoScrollType & VDCircularViewAutoScrollTypeLeft) {
        nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:0];
    }
    else if (self.autoScrollType & VDCircularViewAutoScrollTypeRight) {
        nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:0];
    }
    [self.circularView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.currentOffsetX = nextIndexPath.item * (self.flowLayout.itemSize.width + self.minimumLineSpacing) - (self.bounds.size.width - self.flowLayout.itemSize.width) * 0.5;
}

- (void)dealloc {
    [self stopAutoScroll];
}

@end

@interface VDCircularViewCell ()
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) CALayer *maskLayer;
@property (nonatomic, weak) CALayer *shadowLayer;
@end

@implementation VDCircularViewCell

- (void)setModel:(VDCircularModel *)model {
    _model = model;
//    [self.imgView setImageWithURL:[NSURL URLWithString:model.imgSrc] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    self.imgView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    self.titleLbl.text = model.title;
    CGFloat titleHeight = [self.titleLbl sizeThatFits:CGSizeMake(self.contentView.bounds.size.width - 15 * 2, CGFLOAT_MAX)].height;
    self.titleLbl.frame = CGRectMake(15, self.contentView.bounds.size.height - titleHeight - 15, self.contentView.bounds.size.width - 15 * 2, titleHeight);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.maskLayer.frame = CGRectMake(0, self.contentView.bounds.size.height - titleHeight - 20 - 15, self.contentView.bounds.size.width, titleHeight + 20 + 15);
    self.maskLayer.hidden = !model.title || model.title.length == 0;
    [CATransaction commit];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.contentView.layer.cornerRadius = cornerRadius;
    self.shadowLayer.cornerRadius = cornerRadius;
}

- (void)setShadowEnable:(BOOL )shadowEnable {
    _shadowEnable = shadowEnable;
    self.shadowLayer.hidden = !shadowEnable;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = NO;
        
        CALayer *shadowLayer = [CALayer layer];
        self.shadowLayer = shadowLayer;
        shadowLayer.cornerRadius = 0;
        shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
        shadowLayer.frame = self.layer.bounds;
        shadowLayer.masksToBounds = NO;
        shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        shadowLayer.shadowOffset = CGSizeMake(0, 0);
        shadowLayer.shadowOpacity = 0.3f;
        shadowLayer.shadowRadius = 7.5;
        shadowLayer.shouldRasterize = YES;
        shadowLayer.rasterizationScale = [UIScreen mainScreen].scale;
        [self.layer insertSublayer:shadowLayer below:self.contentView.layer];
        
        self.contentView.layer.cornerRadius = 0;
        self.contentView.layer.masksToBounds = YES;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = [UIColor lightGrayColor];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.font = [UIFont boldSystemFontOfSize:18];
        titleLbl.textColor = [UIColor whiteColor];
        titleLbl.numberOfLines = 2;
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0.5, 0);
        layer.endPoint = CGPointMake(0.5, 1);
        layer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                         (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
        layer.locations = @[@0.0f,@1.0f];
        [imgView.layer addSublayer:layer];
        layer.frame = CGRectMake(0, self.contentView.bounds.size.height * 0.5, self.contentView.bounds.size.width, self.contentView.bounds.size.height * 0.5);
        
        self.maskLayer = layer;
        self.imgView = imgView;
        self.titleLbl = titleLbl;
        
        [self.contentView addSubview:imgView];
        [self.contentView addSubview:titleLbl];
        
        imgView.frame = self.bounds;
    }
    return self;
}

@end

@implementation VDCircularModel
@end
