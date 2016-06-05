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


