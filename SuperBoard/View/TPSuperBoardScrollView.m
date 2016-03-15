//
//  TPScrollView.m
//  ScrollPin
//
//  Created by wang on 15/8/10.
//  Copyright (c) 2015年 wp. All rights reserved.
//

#import "TPSuperBoardScrollView.h"

#import "TPSuperBoardMainView.h"

#import "TPSuperboardDefine.h"

#define SCREEN_SHOT_SEP 20

@interface TPSuperBoardScrollView()<UIScrollViewDelegate>
{
    UIView *_backView;
    UIImageView *_imageView;//背景图片
    TPSuperBoardCanvasView *_canvasView;
}
@end

@implementation TPSuperBoardScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.maximumZoomScale = 5.0f;
        self.minimumZoomScale  = 0.5;
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.contentSize = CGSizeMake(self.tpWidth *2, self.tpHeight *2);
        self.contentOffset = CGPointMake(self.tpWidth/2, self.tpHeight /2);
        self.scrollEnabled = NO;
        self.bouncesZoom = NO;
        self.bounces = NO;
        [self initSubview];
        [self updateAirscapeView];
    }
    return self;
}
- (void)initSubview
{
    //用来放置背景图片的
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    _backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];

    //用来绘画的视图
    TPSuperBoardCanvasView *canvasView = [[TPSuperBoardCanvasView alloc] initWithFrame:backView.bounds];
    canvasView.scrollView = self;
    canvasView.backgroundColor = [UIColor clearColor];
    _canvasView = canvasView;
    [_backView addSubview:canvasView];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _backView;
}


- (void)selectedWithImage:(UIImage *)image
{
    //禁止屏幕的滑动
    //1 获取图片的大小
    CGSize imageSize = image.size;
    //2 如果图片的宽大于屏幕的大小，则缩小图片的显示
    CGSize imageViewSize = [self getAdapedSizeFromSize:imageSize];
    
    //3 创建一个imageview放到scrollview上面
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - imageViewSize.width/2, self.bounds.size.height - imageViewSize.height/2, imageViewSize.width, imageViewSize.height)];
    imageView.image = image;
    imageView.backgroundColor = [UIColor grayColor];
    imageView.userInteractionEnabled = YES;
    _imageView = imageView;
    [_backView addSubview:imageView];
    [_backView bringSubviewToFront:_canvasView];
}
- (CGSize)getAdapedSizeFromSize:(CGSize)source_size
{
    //1 如果图片的大小小于屏幕的大小，则直接返回
    if (source_size.width < TPScreenWidth && source_size.height < TPScreenHeight) {
        return source_size;
    }
    
    //图片太大，缩小显示
    if (source_size.width/source_size.height > TPScreenWidth/TPScreenHeight) {
        //图片的宽高比大  缩小图片的宽到屏幕的宽大小
        CGFloat newWidth = TPScreenWidth;
        CGFloat newHeight = TPScreenWidth * source_size.height/source_size.width;
        return CGSizeMake(newWidth, newHeight);
    }else{
        //图片的宽高比小 缩小图片的高到屏幕的高大小
        CGFloat newHeight = TPScreenHeight;
        CGFloat newWidth = source_size.width * TPScreenHeight / source_size.height;
        return CGSizeMake(newWidth, newHeight);
    }
}


- (void)imageViewPaned:(UIPanGestureRecognizer *)panGes
{
    UIView *gestureView = panGes.view;
#pragma unused(gestureView)
    
}

- (void)undoPreStep
{
    [_canvasView undoPreStep];
}

- (void)backOneStep
{
    [_canvasView backOneStep];
}
- (void)clearAll
{
    [_canvasView clearAll];
    
    [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_backView addSubview:_canvasView];
    self.contentOffset = CGPointMake(self.tpWidth/2, self.tpHeight/2);
    [self updateAirscapeView];
}


- (UIImage *)getImage
{
    CGRect canvasEffectiveFrame = [_canvasView getEffectiveRect];
    CGRect screenshotFrame;
    if (_imageView) {
        CGRect imageFrame = _imageView.frame;
        
        CGFloat minX = MIN(canvasEffectiveFrame.origin.x, imageFrame.origin.x);
        minX = MAX(minX - SCREEN_SHOT_SEP, 0);
        CGFloat minY = MIN(canvasEffectiveFrame.origin.y, imageFrame.origin.y);
        minY = MAX(minY - SCREEN_SHOT_SEP, 0);
        
        CGFloat maxX = MAX(canvasEffectiveFrame.size.width, imageFrame.size.width + imageFrame.origin.x);
        maxX = MIN(maxX + SCREEN_SHOT_SEP, self.contentSize.width);
        
        CGFloat maxY = MAX(canvasEffectiveFrame.size.height, imageFrame.size.height + imageFrame.origin.y);
        maxY = MIN(maxY + SCREEN_SHOT_SEP, self.contentSize.height);
        screenshotFrame = CGRectMake(minX, minY, maxX - minX, maxY -minY);
    }else{
        screenshotFrame = CGRectMake(canvasEffectiveFrame.origin.x, canvasEffectiveFrame.origin.y, canvasEffectiveFrame.size.width - canvasEffectiveFrame.origin.x,canvasEffectiveFrame.size.height - canvasEffectiveFrame.origin.y);
    }
    
    return [_backView tpImageFromView:self atFrame:screenshotFrame];
}
//
//- (void)TPPaletteViewChangePoint:(CGPoint)point
//{
//    CGPoint  offset = self.contentOffset;
//    
//    CGFloat newOffsetX = offset.x - point.x;
//    newOffsetX =MIN(newOffsetX, self.contentSize.width/2);
//    newOffsetX = MAX(newOffsetX, 0);
//    
//    CGFloat newOffsetY = offset.y -  point.y;
//    newOffsetY = MIN(newOffsetY, self.contentSize.height/2);
//    newOffsetY = MAX(newOffsetY, 0);
//    
//    CGPoint newOffSet = CGPointMake(newOffsetX,newOffsetY);
//    self.contentOffset = newOffSet;
//    [self resetShowViewInPaletteView];
//}
////每次scrollview的contentSize变化的时候，都重新设置相对位置
- (void)updateAirscapeView
{
//    UIImage *thumbnailImage = [_backView screenShot];
    [self.mainView showViewLocatedX:self.contentOffset.x/self.contentSize.width y:self.contentOffset.y/self.contentSize.height sizeScale:self.tpWidth *2/_backView.tpWidth thumbnailImage:nil];
}
//滑动的时候，重新设置鸟瞰图
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateAirscapeView];
}
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return _backView;
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    [self resetShowViewInPaletteView];
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
////    NSLog(@"scale   %f   %f",scale,view.sizeHeight);
//}
//
//
//
////切换到移动模式
//- (void)changeToMoveStyle
//{
//    self.scrollEnabled = YES;
//}
////切换到绘画模式
//- (void)changeToDrawStyle
//{
//    self.scrollEnabled = NO;
//}
//
//- (void)addImageView:(UIImageView *)imageView
//{
//    [_imageView removeFromSuperview];
//    _imageView = imageView;
//    [_backView addSubview:imageView];
//    [_backView sendSubviewToBack:imageView];
//}
//
//- (void)undo
//{
//    [_canvasView undo];
//}
//
//- (void)clearAll
//{
//    [_canvasView clearAll];
//}
////截图
//- (UIImage *)screenShot
//{
//    CGRect canvasEffectiveFrame = [_canvasView getEffectiveRect];
//    CGRect imageFrame = _imageView.frame;
//
//    CGFloat minX = MIN(canvasEffectiveFrame.origin.x, imageFrame.origin.x);
//    minX = MAX(minX - SCREEN_SHOT_SEP, 0);
//    CGFloat minY = MIN(canvasEffectiveFrame.origin.y, imageFrame.origin.y);
//    minY = MAX(minY - SCREEN_SHOT_SEP, 0);
//    
//    CGFloat maxX = MAX(canvasEffectiveFrame.size.width, imageFrame.size.width + imageFrame.origin.x);
//    maxX = MIN(maxX + SCREEN_SHOT_SEP, self.contentSize.width);
//    
//    CGFloat maxY = MAX(canvasEffectiveFrame.size.height, imageFrame.size.height + imageFrame.origin.y);
//    maxY = MIN(maxY + SCREEN_SHOT_SEP, self.contentSize.height);
//    
//    CGRect screenshotFrame = CGRectMake(minX, minY, maxX - minX, maxY -minY);
//    return [_backView imageFromView:_backView atFrame:screenshotFrame];
//}


@end
