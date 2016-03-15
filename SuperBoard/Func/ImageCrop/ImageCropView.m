//
//  ImageCropView.m
//  ScrollPin
//
//  Created by wang on 15/8/12.
//  Copyright (c) 2015年 wp. All rights reserved.
//

#import "ImageCropView.h"


#import "TPSuperboardDefine.h"
@interface ImageCropView()
{
    UIImage *_image;
    
    CGPoint _prePoint;
    
    UIImageView *_showingImageView;//要被裁切的图片
    
    UIImageView *_leftTopImageView;
    UIImageView *_rightTopImageView;
    UIImageView *_leftBottomImageView;
    UIImageView *_rightBottomImageView;
    
    ImageCropViewFraming *_framingView;//取景器
}

@end

@implementation ImageCropView


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _image = image;
        self.userInteractionEnabled = YES;
        [self initSubview];
    }
    return self;
}


- (UIImage *)finishScreenShot
{
    CGPoint imageViewLeftTopPoint = _showingImageView.frame.origin;
    
    CGSize imageViewSize = _showingImageView.frame.size;
    
    CGPoint leftTopPoint = _leftTopImageView.center;
    CGPoint rightBottomPoint = _rightBottomImageView.center;
    
    UIImage *screenShotImage = [UIImage tpGetPartOfImage:_image rect:CGRectMake((leftTopPoint.x - imageViewLeftTopPoint.x)/imageViewSize.width * _image.size.width, (leftTopPoint.y - imageViewLeftTopPoint.y)/imageViewSize.height * _image.size.height, (rightBottomPoint.x - imageViewLeftTopPoint.x)/imageViewSize.width * _image.size.width, (rightBottomPoint.y - imageViewLeftTopPoint.y)/imageViewSize.height * _image.size.height)];
    return screenShotImage;
}

- (void)initSubview
{
    //压缩图片到合适显示的尺寸
    CGSize showSize = [self getSuitableSizeWithMaximumWidth:TPScreenWidth - 60 minimumHeight:TPScreenHeight - 60 withImage:_image];
    //计算出图片应该显示的frame
    CGRect showFrame = CGRectMake((TPScreenWidth -showSize.width)/2, (TPScreenHeight - showSize.height)/2, showSize.width, showSize.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:showFrame];
    imageView.image = _image;
    _showingImageView = imageView;
    [self addSubview:imageView];
    
    
    //取景视图
    ImageCropViewFraming *framingView = [[ImageCropViewFraming alloc] initWithFrame:[UIScreen mainScreen].bounds];
    framingView.backgroundColor = [UIColor clearColor];
    _framingView = framingView;
    [self addSubview:framingView];
    
    //左上角的图片
    UIImageView *leftTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftTopImageView.image = [UIImage imageNamed:@"TPWhiteBoard.bundle/cropArrowTopLeft"];
    [self addSubview:leftTopImageView];
    leftTopImageView.userInteractionEnabled = YES;
    _leftTopImageView = leftTopImageView;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paned:)];
    [leftTopImageView addGestureRecognizer:panGesture];
    
    //右上角的图片
    UIImageView *rightTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightTopImageView.image = [UIImage imageNamed:@"TPWhiteBoard.bundle/cropArrowTopRight"];
    [self addSubview:rightTopImageView];
    rightTopImageView.userInteractionEnabled = YES;
    _rightTopImageView = rightTopImageView;
    
    UIPanGestureRecognizer *rightTopPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paned:)];
    [rightTopImageView addGestureRecognizer:rightTopPanGesture];
    
    //左下角的图片
    UIImageView *leftDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftDownImageView.image = [UIImage imageNamed:@"TPWhiteBoard.bundle/cropArrowBottomLeft"];
    [self addSubview:leftDownImageView];
    leftDownImageView.userInteractionEnabled = YES;
    _leftBottomImageView = leftDownImageView;
    
    UIPanGestureRecognizer *leftBottomPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paned:)];
    [leftDownImageView addGestureRecognizer:leftBottomPanGesture];
    
    //右下角的图片
    UIImageView *rightDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightDownImageView.userInteractionEnabled = YES;
    rightDownImageView.image = [UIImage imageNamed:@"TPWhiteBoard.bundle/cropArrowBottomRight"];
    [self addSubview:rightDownImageView];
    _rightBottomImageView = rightDownImageView;
    
    UIPanGestureRecognizer *rightBottomPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paned:)];
    [rightDownImageView addGestureRecognizer:rightBottomPanGesture];
    
    leftTopImageView.center = imageView.frame.origin;
    rightTopImageView.center = CGPointMake(imageView.tpRight, imageView.tpTop);
    leftDownImageView.center = CGPointMake(imageView.tpLeft, imageView.tpBottom);
    rightDownImageView.center = CGPointMake(imageView.tpRight, imageView.tpBottom);

    [_framingView resetPointAtLeftTop:_leftTopImageView.center rightTop:_rightTopImageView.center leftBottom:_leftBottomImageView.center rightBottom:_rightBottomImageView.center];
    
    
}

- (void)paned:(UIPanGestureRecognizer *)panGes
{
    UIView *gestureView = panGes.view;
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        _prePoint = [panGes locationInView:gestureView];
        
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        CGPoint newPoint = [panGes locationInView:gestureView];
        CGFloat deltaX = newPoint.x - _prePoint.x;
        CGFloat deltaY = newPoint.y - _prePoint.y;
        
        CGPoint _preCenter = gestureView.center;
        CGPoint newCenter = CGPointMake(_preCenter.x + deltaX, _preCenter.y + deltaY );
        
        if (gestureView == _leftTopImageView) {
            
            if (_rightTopImageView.center.x - newCenter.x < 40 || _leftBottomImageView.center.y - newCenter.y < 40) {
                return;
            }
        }else if (gestureView == _rightTopImageView){
            if (newCenter.x - _leftTopImageView.center.x < 40 || _leftBottomImageView.center.y - newCenter.y < 40) {
                return;
            }
        }else if (gestureView == _leftBottomImageView){
            if (_rightTopImageView.center.x - newCenter.x < 40 || newCenter.y - _leftTopImageView.center.y < 40) {
                return;
            }
        }else if (gestureView == _rightBottomImageView){
            if (newCenter.x - _leftBottomImageView.center.x < 40 || newCenter.y - _leftTopImageView.center.y < 40) {
                return;
            }
        }
        
        if (!CGRectContainsPoint(_showingImageView.frame, newCenter)) {
            return;
        }
        
        gestureView.center = newCenter;
        
    }else if (panGes.state == UIGestureRecognizerStateEnded){
    
    }
    if (gestureView == _leftTopImageView) {
        
        _leftBottomImageView.tpLeft = _leftTopImageView.tpLeft;
        _rightTopImageView.tpTop = _leftTopImageView.tpTop;
    
    }else if (gestureView == _rightTopImageView){
        _leftTopImageView.tpTop = _rightTopImageView.tpTop;
        _rightBottomImageView.tpLeft = _rightTopImageView.tpLeft;
    }else if (gestureView == _leftBottomImageView){
        _leftTopImageView.tpLeft = _leftBottomImageView.tpLeft;
        _rightBottomImageView.tpTop = _leftBottomImageView.tpTop;
    }else if (gestureView == _rightBottomImageView){
        _rightTopImageView.tpLeft = _rightBottomImageView.tpLeft;
        _leftBottomImageView.tpTop = _rightBottomImageView.tpTop;
    }
    [_framingView resetPointAtLeftTop:_leftTopImageView.center rightTop:_rightTopImageView.center leftBottom:_leftBottomImageView.center rightBottom:_rightBottomImageView.center];
}

- (CGSize)getSuitableSizeWithMaximumWidth:(CGFloat)maxWidth minimumHeight:(CGFloat)maxHeight withImage:(UIImage *)image
{
    if (image.size.width < maxWidth && image.size.height < maxHeight) {
        //1 图片没超过最大范围，直接返回图片的大小
        return image.size;
    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    //图片的宽高比
    CGFloat imageAspectRatio = image.size.width / image.size.height;
    //屏幕的宽高比
    CGFloat deviceAspectRatio = screenWidth / screenHeight;
    
    if (imageAspectRatio > deviceAspectRatio) {
        //图片的宽高比大，图片宽度压缩到最大的宽度
        CGFloat imageWith = maxWidth;
        CGFloat imageHeight = image.size.height * maxWidth / image.size.width;
        return CGSizeMake(imageWith, imageHeight);
    }else{
        //图片的宽高比小，图片高度压缩到最大的宽度
        CGFloat imageHeight = maxHeight;
        CGFloat imageWidth = image.size.width * maxHeight / image.size.height;
        return CGSizeMake(imageWidth, imageHeight);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@interface ImageCropViewFraming()
{
    CGPoint _leftTopPoint;
    CGPoint _rightTopPoint;
    CGPoint _leftBottomPoint;
    CGPoint _rightBottomPoint;
}
@end

@implementation ImageCropViewFraming


- (void)resetPointAtLeftTop:(CGPoint)leftTopPoint rightTop:(CGPoint)rightTopPoint leftBottom:(CGPoint)leftBottomPoint rightBottom:(CGPoint)rightBottomPoint
{
    _leftTopPoint = leftTopPoint;
    _rightTopPoint = rightTopPoint;
    
    _leftBottomPoint = leftBottomPoint;
    _rightBottomPoint = rightBottomPoint;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10);
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextMoveToPoint(context, _leftTopPoint.x, _leftTopPoint.y);
    CGContextAddLineToPoint(context, _rightTopPoint.x, _rightTopPoint.y);
    CGContextAddLineToPoint(context, _rightBottomPoint.x, _rightBottomPoint.y);
    CGContextAddLineToPoint(context, _leftBottomPoint.x, _leftBottomPoint.y);
    CGContextAddLineToPoint(context, _leftTopPoint.x, _leftTopPoint.y);
    CGContextStrokePath(context);
    
}


@end
