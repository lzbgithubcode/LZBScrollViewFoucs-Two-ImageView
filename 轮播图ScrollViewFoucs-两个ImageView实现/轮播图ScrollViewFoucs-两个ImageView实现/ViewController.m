//
//  ViewController.m
//  轮播图ScrollViewFoucs-两个ImageView实现
//
//  Created by apple on 16/6/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "LZBFocusScrollView.h"

@interface ViewController () <LZBFocusScrollViewDeledate>

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //本地图片
    LZBFocusScrollView *focusView = [[LZBFocusScrollView alloc]init];
    focusView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
    [self.view addSubview:focusView];
    
    NSArray *image = @[[UIImage imageNamed:@"LZBFocusScrollView.bundle/1.png"],[UIImage imageNamed:@"LZBFocusScrollView.bundle/2.png"],[UIImage imageNamed:@"LZBFocusScrollView.bundle/3.png"]];
    
    focusView.imageArray = image;
    
    [focusView setpageControlCurrentColor:[UIColor redColor] OtherColor:[UIColor whiteColor]];
    
    [focusView setClickImage:^(NSInteger index) {
        NSLog(@"点击了第%ld张图片",index);
    }];
    
    //网络图片
    NSArray *imageUrl =  @[@"http://hiphotos.baidu.com/praisejesus/pic/item/e8df7df89fac869eb68f316d.jpg", @"http://pic39.nipic.com/20140226/18071023_162553457000_2.jpg", @"http://file27.mafengwo.net/M00/B2/12/wKgB6lO0ahWAMhL8AAV1yBFJDJw20.jpeg"];
    
    LZBFocusScrollView *focusView2 = [[LZBFocusScrollView alloc]initWithFrame:CGRectZero WithImageArray:imageUrl];

    focusView2.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 150);
    [self.view addSubview:focusView2];

    focusView2.delegate =self;
    focusView2.style = LZBFocusScrollViewScrollStyle_pageCurl;
    
    [focusView2 setpageControlCurrentColor:[UIColor redColor] OtherColor:[UIColor whiteColor]];
    [focusView2 setPageControlCurrentImage:[UIImage imageNamed:@"LZBFocusScrollView.bundle/pageControl_current"] OtherImage:[UIImage imageNamed:@"LZBFocusScrollView.bundle/pageControl_nor"]];
    
    
    //网络图片
    NSArray *imageUrl2 =  @[@"http://hiphotos.baidu.com/praisejesus/pic/item/e8df7df89fac869eb68f316d.jpg", @"http://pic39.nipic.com/20140226/18071023_162553457000_2.jpg", @"http://file27.mafengwo.net/M00/B2/12/wKgB6lO0ahWAMhL8AAV1yBFJDJw20.jpeg"];
    
    LZBFocusScrollView *focusView3 = [[LZBFocusScrollView alloc]initWithFrame:CGRectZero WithImageArray:imageUrl2 imageCilckBlock:^(NSInteger index) {
         NSLog(@"3.点击了第%ld张图片",index);
    }];
    
    focusView3.frame = CGRectMake(0, 400, [UIScreen mainScreen].bounds.size.width, 150);
    [self.view addSubview:focusView3];
    
    focusView3.delegate =self;
    focusView3.style = LZBFocusScrollViewScrollStyle_3DRotation;
    
    [focusView3 setpageControlCurrentColor:[UIColor blueColor] OtherColor:[UIColor whiteColor]];


    
}

- (void)focusScrollView:(LZBFocusScrollView *)focusScrollView didSelectImageAtIndex:(NSInteger)index
{
    NSLog(@"2.点击了第%ld张图片",index);
}

@end
