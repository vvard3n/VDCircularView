//
//  ViewController.m
//  VDCircularViewDemo
//
//  Created by Harwyn T'an on 2017/5/15.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "ViewController.h"
#import "VDCircularView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VDCircularView *cview = [[VDCircularView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width - 2 * 17) / 16.0 * 9 + 50)];
    cview.shadowEnable = YES;
    cview.minimumLineSpacing = 10;
    cview.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 17, ([UIScreen mainScreen].bounds.size.width - 2 * 17) / 16.0 * 9);
    cview.scaleFactor = 1;
    cview.cornerRadius = 8;
    cview.autoScroll = YES;
    [self.view addSubview:cview];
    
    NSMutableArray *marr = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        VDCircularModel *model = [[VDCircularModel alloc] init];
        model.title = [NSString stringWithFormat:@"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题%ld", i];
        model.imgSrc = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo_top_ca79a146.png";
        [marr addObject:model];
    }
    cview.datas = marr.copy;
    
    VDCircularView *cview1 = [[VDCircularView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cview.frame) + 20, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width - 2 * 17) / 16.0 * 9 + 50)];
    cview1.shadowEnable = YES;
    cview1.minimumLineSpacing = -5;
    cview1.scaleFactor = 1.05;
    cview1.autoScrollDuration = 1;
//    cview1.cornerRadius = 8;
    cview1.autoScroll = YES;
    [self.view addSubview:cview1];
    
    NSMutableArray *marr1 = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        VDCircularModel *model = [[VDCircularModel alloc] init];
        model.title = [NSString stringWithFormat:@"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题%ld", i];
        model.imgSrc = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo_top_ca79a146.png";
        [marr1 addObject:model];
    }
    cview1.datas = marr1.copy;
    
    VDCircularView *cview2 = [[VDCircularView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cview1.frame) + 20, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width - 2 * 17) / 16.0 * 9 + 50)];
    cview2.shadowEnable = NO;
    cview2.minimumLineSpacing = 10;
    cview2.scaleFactor = 1.05;
    cview2.autoScrollDuration = 1.5;
    cview2.cornerRadius = 8;
    cview2.autoScroll = YES;
    [self.view addSubview:cview2];
    
    NSMutableArray *marr2 = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        VDCircularModel *model = [[VDCircularModel alloc] init];
        model.title = [NSString stringWithFormat:@"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题%ld", i];
        model.imgSrc = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo_top_ca79a146.png";
        [marr2 addObject:model];
    }
    cview2.datas = marr2.copy;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
