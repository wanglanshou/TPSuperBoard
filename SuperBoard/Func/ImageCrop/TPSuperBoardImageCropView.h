//
//  ImageCropView.h
//  ScrollPin
//
//  Created by wang on 15/8/12.
//  Copyright (c) 2015年 wp. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ImageCropViewDelegate <NSObject>

- (void)ImageCropViewDidSelectedWithImage:(UIImage *)image;

@end

@interface TPSuperBoardImageCropView : UIView

@property (nonatomic,weak) id<ImageCropViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

- (UIImage *)finishScreenShot;
@end


@interface ImageCropViewFraming : UIView

- (void)resetPointAtLeftTop:(CGPoint)leftTopPoint rightTop:(CGPoint)rightTopPoint leftBottom:(CGPoint)leftBottomPoint rightBottom:(CGPoint)rightBottomPoint;

@end
