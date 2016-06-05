//
//  LZBFocusScrollView.h
//  06-无限滚动轮播图
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZBFocusScrollView;

typedef void(^imageClickBlock)(NSInteger index);

typedef NS_ENUM(NSInteger,LZBFocusScrollViewPageControllPosition){
    LZBFocusScrollViewPageControllPosition_None,    //默认底部中心
    LZBFocusScrollViewPageControllPosition_Hidden,   //隐藏
    LZBFocusScrollViewPageControllPosition_BottomCenter,  //底部中心
    
};

typedef NS_ENUM(NSInteger,LZBFocusScrollViewScrollStyle)
{
   LZBFocusScrollViewScrollStyle_Defalut, //默认普通滚动
   LZBFocusScrollViewScrollStyle_Fade,    //淡入淡出
   LZBFocusScrollViewScrollStyle_3DRotation,  //3D旋转
   LZBFocusScrollViewScrollStyle_pageCurl,    //向上翻页效果
   LZBFocusScrollViewScrollStyle_pageUnderCurl,    //向下翻页效果
   LZBFocusScrollViewScrollStyle_rippleEffect,  //水滴效果
   LZBFocusScrollViewScrollStyle_oglFlip,   //上下翻转效果

};


@protocol LZBFocusScrollViewDeledate <NSObject>

/**
 *  代理方法实现选择imageView调用，代理/block都可以用，block优先
 *
 *  @param focusScrollView  focusScrollView
 *  @param index           index
 */
- (void)focusScrollView:(LZBFocusScrollView *)focusScrollView didSelectImageAtIndex:(NSInteger)index;

@end


@interface LZBFocusScrollView : UIView

#pragma mark - 实例化
/**
 *  实例化LZBFocusScrollView
 *
 *  @param frame      尺寸大小
 *  @param imageArray 图片数组
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame WithImageArray:(NSArray *)imageArray;

/**
 *  实例化图片
 *
 *  @param frame      尺寸大小
 *  @param imageArray 图片数组
 *  @param imageClickBlock 点击图片回调
 *
 *  @return 
 */
- (instancetype)initWithFrame:(CGRect)frame WithImageArray:(NSArray *)imageArray  imageCilckBlock:(void(^)(NSInteger index))imageClickBlock;



#pragma mark - LZBFocusScrollView属性操作


/**
 *  轮播的图片数组，可以是本地图片（UIImage，不能是图片名称），也可以是网络路径，可以是String图片链接(必须已http://开头)
 */
@property (nonatomic, strong) NSArray  *imageArray;

/**
 *  设置滚动的样式
 */
@property (nonatomic, assign) LZBFocusScrollViewScrollStyle style;

/**
 *  设置占位图片
 */
@property (nonatomic, strong) UIImage *placeHoderImage;

/**
 *  点击轮播图片，代理/block都可以用，block优先
 */
@property (nonatomic, copy) imageClickBlock clickImage;
- (void)setClickImage:(imageClickBlock)clickImage;

/**
 *  点击图片的代理
 */
@property (nonatomic, weak) id<LZBFocusScrollViewDeledate> delegate;










#pragma mark - 定时器操作方法


/**
 *  开启定时器,
 */
- (void)startTimer;

/**
 *  停止定时器,如果滚动后，会在自动再次触发
 */
- (void)stopTimer;

/**
 *  设置定时时间，设置完成自动开启定时器，默认 time = 1s
 */
@property (nonatomic, assign) NSTimeInterval time;





#pragma mark - 指示器的属性和方法

/**
 *  分页指示器的位置
 */
@property (nonatomic, assign) LZBFocusScrollViewPageControllPosition pageControlPosition;

/**
 *  自定义设置分页指示器的图片
 *
 *  @param currentImage 选择图片
 *  @param otherImage   其他图片
 */
- (void)setPageControlCurrentImage:(UIImage *)currentImage OtherImage:(UIImage *)otherImage;

/**
 *  自定义设置分页指示器的颜色
 *
 *  @param currentColor 选中得颜色
 *  @param otherColor   其他颜色
 */
- (void)setpageControlCurrentColor:(UIColor *)currentColor OtherColor:(UIColor *)otherColor;



@end

