//
//  AirscapeView.m
//  ScrollPin
//
//  Created by wang on 15/8/10.
//  Copyright (c) 2015年 wp. All rights reserved.
//

#import "TPMiniMapView.h"

#import "TPSuperboardDefine.h"
@interface TPMiniMapView()
{
    UIView *_showView;
    UIImageView *_imageView;
}

@end

@implementation TPMiniMapView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
        self.layer.borderWidth = 1.0f;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundColor = [UIColor tpColorWithRed:210 green:210 blue:210];
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return self;
}

- (void)initSubView {
    //显示画布的图片相对画布的位置
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView = imageView;
    [self addSubview:imageView];
    
    //当前显示的屏幕相对画布的位置
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(self.tpWidth/4, self.tpHeight/4, self.tpWidth/2, self.tpHeight/2)];
    _showView = showView;
    _showView.backgroundColor = [UIColor whiteColor];
    showView.layer.borderColor = [UIColor grayColor].CGColor;
    showView.layer.borderWidth = 1.0f;
    [self addSubview:showView];
}

- (void)showViewLocatedX:(CGFloat)xPercent y:(CGFloat)yPercent sizeScale:(CGFloat)scale thumbnailImage:(UIImage *)thumbnailImage {
    _showView.frame = CGRectMake(self.tpWidth *xPercent, self.tpHeight * yPercent, self.tpWidth/2 * scale, self.tpHeight/2 * scale);

    self.image = thumbnailImage;
}


@end
