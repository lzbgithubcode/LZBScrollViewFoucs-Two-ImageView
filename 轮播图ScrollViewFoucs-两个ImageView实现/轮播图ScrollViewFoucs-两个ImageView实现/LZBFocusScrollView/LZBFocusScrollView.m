//
//  LZBFocusScrollView.m
//  06-无限滚动轮播图
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LZBFocusScrollView.h"
#import "UIImageView+WebCache.h"

//scrollView的宽度
#define scrollView_Width self.scrollView.frame.size.width
//scrollView的高度
#define scrollView_Height self.scrollView.frame.size.height
//最大的个数用于计算contentSize
#define CONTENTSIZE_COUNT    5
//计算当前contentOffset，位于中间位置
#define CONTENTSIZE_CURRENT_COUNT 2
//pageControl底部间距
#define pageControl_bottom_Margin    10



//默认定时时间
#define NSTimer_Time 2.0

@interface LZBFocusScrollView()<UIScrollViewDelegate>

#pragma mark - propertyUI控件
/**
 *  UIScrollView
 */
@property (nonatomic, strong)  UIScrollView  *scrollView;

/**
 *  当前滚动的到的imageView 中间的imageView
 */
@property (nonatomic, strong) UIImageView *currentImageView;

/**
 *  非当前显示的ImageView，左边或者右边
 */
@property (nonatomic, strong)  UIImageView *otherImageView;

/**
 *  描述文字
 */
@property (nonatomic, strong) UILabel *descLabel;

/**
 *  页码指示
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  自定义页码指示图片大小
 */
@property (nonatomic, assign) CGSize   customPageControlImageSize;


#pragma mark - property数据Data
/**
 *  轮播的图片数组
 */
@property (nonatomic, strong)  NSMutableArray *images;

/**
 *  轮播的图片URL链接
 */
@property (nonatomic, strong) NSMutableArray *imageUrls;

#pragma mark - property使用属性
/**
 *  当前指向的索引
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  下一张图片索引
 */
@property (nonatomic, assign) NSInteger nextIndex;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *Timer;

/**
 *  动画CATration
 */
@property (nonatomic,strong) CATransition *trastiton;


@end



@implementation LZBFocusScrollView



#pragma mark --------------------------实例化-----------------------------------
#pragma mark - 实例化
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self addSubview:self.descLabel];
}

- (instancetype)initWithFrame:(CGRect)frame WithImageArray:(NSArray *)imageArray
{
   if(self = [super initWithFrame:frame])
   {
       self.imageArray = imageArray;
   }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithImageArray:(NSArray *)imageArray imageCilckBlock:(void (^)(NSInteger))imageClickBlock
{
  if(self = [self initWithFrame:frame WithImageArray:imageArray])
  {
      self.clickImage = imageClickBlock;
      
  }
    return self;
}


#pragma mark ----------------------重写属性方法-------------------------------------

- (void)setImageArray:(NSArray *)imageArray
{
    if(imageArray.count == 0)
        return;
    _imageArray = imageArray;
    for (NSInteger i = 0; i < imageArray.count; i++)
    {
       if([imageArray[i] isKindOfClass:[UIImage class]])
       {
           [self.images addObject:imageArray[i]];
       }
        else if ([imageArray[i] isKindOfClass:[NSString class]])
        {
            [self.images addObject:self.placeHoderImage];
            [self.imageUrls addObject:imageArray[i]];

        }
        else
          {
              NSLog(@"暂时不识别这种类型图片，请选择正确的图片格式");
          }
    }
    
  
    //赋值越界问题
    if(self.currentIndex >= imageArray.count)
        self.currentIndex = imageArray.count - 1;
    
    if(self.imageUrls.count > 0)
    {
        [self.currentImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[self.currentIndex]] placeholderImage:self.placeHoderImage];
    }
    else
    {
     self.currentImageView.image = self.images[self.currentIndex];
    }
   
    self.pageControl.numberOfPages = imageArray.count;
    
    [self layoutSubviews];

}

#pragma mark- 设置contentSize大小
/**
 *  设置contentSize大小
 */
- (void)setupScrollViewContentSize
{
   if(self.images.count > 1)
   {
       switch (self.style) {
           case LZBFocusScrollViewScrollStyle_Fade:
           case LZBFocusScrollViewScrollStyle_3DRotation:
           case LZBFocusScrollViewScrollStyle_pageCurl:
           case LZBFocusScrollViewScrollStyle_pageUnderCurl:
           case LZBFocusScrollViewScrollStyle_rippleEffect:
           case LZBFocusScrollViewScrollStyle_oglFlip:
               {
                   self.currentImageView.frame = CGRectMake(0, 0, scrollView_Width, scrollView_Height);
                   self.otherImageView.frame = self.currentImageView.frame;
                   self.otherImageView.alpha = 0;
                   [self insertSubview:self.currentImageView atIndex:0];
                   [self insertSubview:self.otherImageView atIndex:1];
               }
               break;
               
           default:
               {
                   self.scrollView.contentSize = CGSizeMake(scrollView_Width * CONTENTSIZE_COUNT, scrollView_Height);
                   self.scrollView.contentOffset = CGPointMake(CONTENTSIZE_CURRENT_COUNT *scrollView_Width, 0);
                   self.currentImageView.frame = CGRectMake(CONTENTSIZE_CURRENT_COUNT *scrollView_Width, 0, scrollView_Width, scrollView_Height);
               }
               break;
       }
   
       [self startTimer];
       
   }
    else
    {
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentOffset =CGPointZero;
        self.currentImageView.frame = CGRectMake(0, 0, scrollView_Width, scrollView_Height);
    }
}



#pragma mark - 指示器方法
- (void)setPageControlPosition:(LZBFocusScrollViewPageControllPosition)pageControlPosition
{
    _pageControlPosition = pageControlPosition;
    self.pageControl.hidden = (pageControlPosition == LZBFocusScrollViewPageControllPosition_Hidden);
    
    if(self.pageControl.hidden)  return;
    
    //设置pageControl位置
    CGSize size;
    
    if(self.customPageControlImageSize.width)  //有自定义图片
    {
        size = CGSizeMake(self.customPageControlImageSize.width * (self.pageControl.numberOfPages * 2 -1), self.customPageControlImageSize.height);
    }
    else
    {
      size = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
    }
    
    self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    CGFloat centerY =  scrollView_Height - size.height * 0.5 -  pageControl_bottom_Margin;
    if(_pageControlPosition == LZBFocusScrollViewPageControllPosition_BottomCenter || _pageControlPosition == LZBFocusScrollViewPageControllPosition_None)
    {
        self.pageControl.center = CGPointMake(scrollView_Width * 0.5, centerY);
    }
    
}

- (void)setpageControlCurrentColor:(UIColor *)currentColor OtherColor:(UIColor *)otherColor
{
    if(!currentColor || !otherColor)  return;
    
    self.pageControl.currentPageIndicatorTintColor = currentColor;
    self.pageControl.pageIndicatorTintColor = otherColor;
}

- (void)setPageControlCurrentImage:(UIImage *)currentImage OtherImage:(UIImage *)otherImage
{
    if(!currentImage  || !otherImage)  return;
    self.customPageControlImageSize = currentImage.size;
    [self.pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [self.pageControl setValue:otherImage forKey:@"_pageImage"];
}


#pragma mark - 布局子控件
- (void)layoutSubviews
{
  [super layoutSubviews];
  self.scrollView.frame = self.bounds;
  self.scrollView.contentInset = UIEdgeInsetsZero;
    //设置指示器默认位置
  self.pageControlPosition = self.pageControlPosition;
  [self setupScrollViewContentSize];
}

#pragma mark - 定时器操作
- (void)startTimer
{    //如果只有一张图片，则直接返回，不开启定时器
    if(self.imageArray.count <= 1) return;
    
      if(self.Timer)
          [self stopTimer];
    
    self.Timer = [NSTimer timerWithTimeInterval:(self.time >=2.0)? self.time : NSTimer_Time target: self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.Timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.Timer invalidate];
    self.Timer = nil;
}

- (void)setTime:(NSTimeInterval)time
{
    _time = time;
    [self startTimer];
}

#pragma mark --------------------UIScrollView代理方法-----------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    [self computeCurrentPageWithOffset:offsetX];
    //加载ImageView
    if(offsetX < scrollView_Width * 2)   //左滚动
    {
        switch (self.style) {
            case LZBFocusScrollViewScrollStyle_Fade:
                {
                    self.currentImageView.alpha = offsetX/scrollView_Width -1;
                    self.otherImageView.alpha = 2 - offsetX/scrollView_Width;
                }
                break;
                
            default:
                {
                  self.otherImageView.frame = CGRectMake(scrollView_Width, 0, scrollView_Width, scrollView_Height);
                }
                break;
        }
        
        
        self.nextIndex = self.currentIndex -1;
        if(self.nextIndex < 0)
            self.nextIndex = self.images.count -1;
        
        if(offsetX <= scrollView_Width)
            [self changeToNextImage];
       
    }
    else  if (offsetX >scrollView_Width * 2)   //右边滑动
    {
        
        switch (self.style) {
            case LZBFocusScrollViewScrollStyle_Fade:
                {
                    self.currentImageView.alpha = offsetX/scrollView_Width -2;
                    self.otherImageView.alpha = 3 - offsetX/scrollView_Width;
                }
                break;
                
            default:
                {
                
                }
                break;
        }
        self.otherImageView.frame = CGRectMake(CGRectGetMaxX(self.currentImageView.frame), 0, scrollView_Width, scrollView_Height);
        self.nextIndex = (self.currentIndex + 1)%self.images.count;
        if (offsetX >=scrollView_Width * 3 ) {
            [self changeToNextImage];
        }
        
    }
    
    if(self.imageUrls.count > 0)
    {
        [self.otherImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[self.nextIndex] ]placeholderImage:self.placeHoderImage];
    }
     else
     {
       self.otherImageView.image = self.images[self.nextIndex];
     }
    
    
}

 -(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}


#pragma mark --------------------业务逻辑处理-----------------------------

#pragma mark - 滚动到下一张
/**
 *  滚动到下一张
 */
- (void)changeToNextImage
{
    switch (self.style) {
        case LZBFocusScrollViewScrollStyle_Fade:
            {
                self.currentImageView.alpha = 1;
                self.otherImageView.alpha = 0;
            }
            break;
            
        case LZBFocusScrollViewScrollStyle_3DRotation:
            {
                [self loadCurrentImage];
            }
            break;
        case LZBFocusScrollViewScrollStyle_pageCurl:
            {
                [self loadCurrentImage];
            
            }
            break;
        case LZBFocusScrollViewScrollStyle_pageUnderCurl:
            {
                [self loadCurrentImage];
                
            }
            break;
        case LZBFocusScrollViewScrollStyle_oglFlip:
            {
                [self loadCurrentImage];
                
            }
            break;
            
        case LZBFocusScrollViewScrollStyle_rippleEffect:
        {
            [self loadCurrentImage];
            
        }
            break;
        default:
            break;
    }
    
    self.currentImageView.image = self.otherImageView.image;
    self.scrollView.contentOffset = CGPointMake(scrollView_Width * 2, 0);
    self.currentIndex =self.nextIndex;
    self.pageControl.currentPage =self.currentIndex;
}

#pragma mark - 计算当前页码
/**
 *计算当前页码
 */
- (void)computeCurrentPageWithOffset:(CGFloat)offsetX
{
    //左滑
     if (offsetX < scrollView_Width * 1.5)
     {
         NSInteger index = self.currentIndex -1;
         if(index < 0)
             index = self.images.count - 1;
         self.pageControl.currentPage = index;
     }
    //右滑
    else if (offsetX > scrollView_Width * 2.5)
    {
        self.pageControl.currentPage = (self.currentIndex + 1)%self.images.count;
            
    }
    //没有动
    else
        self.pageControl.currentPage = self.currentIndex;
}

#pragma mark - 手势点击imageView
/**
 *  手势点击imageView
 */
- (void)imageClick
{
   if(self.clickImage)
       self.clickImage(self.currentIndex);
    
    if([self.delegate respondsToSelector:@selector(focusScrollView:didSelectImageAtIndex:)])
    {
        [self.delegate focusScrollView:self didSelectImageAtIndex:self.currentIndex];
    }
    
}

#pragma mark - 加载当前页的图片 - 动画
/**
 *  加载当前页的图片
 */
- (void)loadCurrentImage
{
    if(self.imageUrls.count > 0)
    {
        [self.currentImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[self.nextIndex] ]placeholderImage:self.placeHoderImage];
    }
    else
    {
        self.currentImageView.image = self.images[self.nextIndex];
    }
    
}
#pragma mark - 加载下一张图片 - 动画
/**
 *   加载下一张图片
 */
- (void)loadNextImage
{
    self.nextIndex = (self.currentIndex + 1)%self.imageArray.count;
    if(self.imageUrls.count > 0)
    {
        [self.otherImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[self.nextIndex] ]placeholderImage:self.placeHoderImage];
    }
    else
    {
        self.otherImageView.image = self.images[self.nextIndex];
    }
     self.pageControl.currentPage = self.nextIndex;
   
}
#pragma mark  - 下一张图片处理
/**
 *  下一张图片
 */
- (void)nextImage
{
    switch (self.style) {
        case LZBFocusScrollViewScrollStyle_Fade:
            {
              
                [self loadNextImage];
                [UIView animateWithDuration:1.0 animations:^{
                    self.currentImageView.alpha = 0;
                    self.otherImageView.alpha = 1;
                    self.pageControl.currentPage = self.nextIndex;
                } completion:^(BOOL finished) {
                    [self changeToNextImage];
                }];
                
            }
            break;
            
            
        case LZBFocusScrollViewScrollStyle_3DRotation:
            {
                [self loadNextImage];
                [self scrollView3D:self.currentImageView];
             }
             break;
            
        case LZBFocusScrollViewScrollStyle_pageCurl:
            {
                [self loadNextImage];
                [self scrollViewPageCurl:self.currentImageView];
            }
            break;
        case LZBFocusScrollViewScrollStyle_pageUnderCurl:
            {
                [self loadNextImage];
                [self scrollViewPageUnderCurl:self.currentImageView];
            }
            break;
        case LZBFocusScrollViewScrollStyle_oglFlip:
            {
                [self loadNextImage];
                [self scrollViewoglFlip:self.currentImageView];
            }
            break;
        case LZBFocusScrollViewScrollStyle_rippleEffect:
        {
            [self loadNextImage];
            [self scrollViewrippleEffect:self.currentImageView];
        }
            break;
            
        default:
            {
            [self.scrollView setContentOffset:CGPointMake(scrollView_Width * (CONTENTSIZE_CURRENT_COUNT + 1), 0) animated:YES];
               
            }
            break;
    }
}

#pragma mark------------------动画效果----------------------------------------

#pragma mark - 3D滚动效果
- (void)scrollView3D:(UIView *)view
{
    self.trastiton.type = @"cube";
    self.trastiton.subtype = kCATransitionFromRight;
    self.trastiton.duration = 0.5;
    [view.layer addAnimation:self.trastiton forKey:nil];
    [self changeToNextImage];
}

#pragma mark - 向上翻页效果
- (void)scrollViewPageCurl:(UIView *)view
{
    self.trastiton.type = @"pageCurl";
    self.trastiton.subtype = kCATransitionFromTop;
    self.trastiton.duration = 0.5;
    [view.layer addAnimation:self.trastiton forKey:nil];
    [self changeToNextImage];
}

#pragma mark - 向下翻页效果
- (void)scrollViewPageUnderCurl:(UIView *)view
{
    self.trastiton.type = @"pageUnCurl";
    self.trastiton.subtype = kCATransitionFromTop;
    [self scrollViewCommon:view];
}

#pragma mark - 上下翻转效果
- (void)scrollViewoglFlip:(UIView *)view
{
    self.trastiton.type = @"oglFlip";
    self.trastiton.subtype = kCATransitionFromTop;
    [self scrollViewCommon:view];
}

#pragma mark - 水滴效果
- (void)scrollViewrippleEffect:(UIView *)view
{
    self.trastiton.type = @"rippleEffect";
    self.trastiton.subtype = kCATransitionFromTop;
    [self scrollViewCommon:view];
}


#pragma mark - 转场效果公共
- (void)scrollViewCommon:(UIView *)view
{
    self.trastiton.duration = 0.5;
    [view.layer addAnimation:self.trastiton forKey:nil];
    [self changeToNextImage];
}

#pragma mark - 懒加载控件 - 注意懒加载的控件不能使用weak,修饰
- (UIScrollView *)scrollView
{
    if(_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_scrollView addSubview:self.currentImageView];
        [_scrollView addSubview:self.otherImageView];
        //增加手势
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)]];
    }
    return _scrollView;
}

- (UIImageView *)currentImageView
{
    if(_currentImageView == nil)
    {
        _currentImageView = [[UIImageView alloc]init];
        _currentImageView.userInteractionEnabled = YES;
    }
    return _currentImageView;
}

- (UIImageView *)otherImageView
{
    if(_otherImageView == nil)
    {
        _otherImageView = [[UIImageView alloc]init];
        _otherImageView.userInteractionEnabled = YES;
    }
    return _otherImageView;
}

- (UILabel *)descLabel
{
    if(_descLabel == nil)
    {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor redColor];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont systemFontOfSize:14.0];
        _descLabel.hidden = YES;
    }
    return _descLabel;
}
- (UIPageControl *)pageControl
{
    if(_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc] init];;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
    
}
- (NSMutableArray *)images
{
    if(_images == nil)
    {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)imageUrls
{
    if(_imageUrls == nil)
    {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
}

- (CATransition *)trastiton
{
    if(_trastiton == nil)
    {
        _trastiton = [[CATransition alloc]init];
    }
    return _trastiton;
}
- (UIImage *)placeHoderImage
{
    if(_placeHoderImage == nil)
    {
        _placeHoderImage = [UIImage imageNamed:@"LZBFocusScrollView.bundle/placeHoder"];
    }
    return _placeHoderImage;
}


@end
