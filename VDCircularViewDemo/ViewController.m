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
    
    VDCircularView *cview = [[VDCircularView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 0.592 * [UIScreen mainScreen].bounds.size.width)];
    cview.autoScroll = YES;
    cview.scaleFactor = 1.1162790698;
    cview.minimumLineSpacing = 15;
    [self.view addSubview:cview];
    
    NSMutableArray *marr = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        VDCircularModel *model = [[VDCircularModel alloc] init];
        model.title = [NSString stringWithFormat:@"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题%ld", i];
        model.imgSrc = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo_top_ca79a146.png";
        [marr addObject:model];
    }
    cview.datas = marr.copy;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
