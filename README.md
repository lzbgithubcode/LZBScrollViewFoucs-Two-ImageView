# LZBScrollViewFoucs-Two-ImageView
两个imageView实现轮播滚动，支持多种滚动动画

#使用方法
1.导入#import "LZBFocusScrollView.h"

2.实例化LZBFocusScrollView

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

#参数设置
imageArray： 必选参数。轮播的图片数组，可以是本地图片（UIImage，不能是图片名称），也可以是网络路径，可以是String图片链接(必须已http://开头)

style： 可选参数。默认是LZBFocusScrollViewScrollStyle_Defalut, //默认普通滚动，支持多种动画效果

placeHoderImage：可选参数，设置占位图片

clickImage：可选参数。轮播图点击参数

delegate: 可选参数。轮播图点击参数

#实现原理
设置scrollViewContentSize的滚动范围是5 * scrollView_Width并且把currentImageView增加到scrollView中，并且设置currentImageView的offset.x = scrollView_Width(相当于是把currentImageView放在中间位置)，让后通过- (void)scrollViewDidScroll:(UIScrollView *)的scrollView.contentOffset.x判断滚动方向
scrollView.contentOffset.x  < scrollView_Width * 2 左边滚动  otherImageView增加在右边
scrollView.contentOffset.x  > scrollView_Width * 2 右边滚动  otherImageView增加在左边
滚动otherImageView之后，赋值并且设置 self.currentImageView.image = self.otherImageView.image;，在把currentView放在中间 self.scrollView.contentOffset = CGPointMake(scrollView_Width * 2, 0);

#备注
本文参照连接：https://github.com/codingZero/XRCarouselView 

