//
//  UIView+TPCategory.h
//  TPFrequentlyDemo
//
//  Created by wang on 16/3/15.
//  Copyright © 2016年 wp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TPCategory)
@property (nonatomic,assign) CGFloat tpLeft;
@property (nonatomic,readonly) CGFloat tpRight;
@property (nonatomic,assign) CGFloat tpWidth;
@property (nonatomic,assign) CGFloat tpHeight;
@property (nonatomic,assign) CGFloat tpTop;
@property (nonatomic,readonly) CGFloat tpBottom;

@property (nonatomic) BOOL sg_isBlur;

- (UIViewController *)tpGetViewController;//获取当前视图所在的视图控制器
- (UIView *)tpGetSuperViewWithClassName:(NSString *)className;//获取父视图，直到父视图是指定的类

- (UIImage *)tpScreenShot;
- (UIImage *)tpImageFromView: (UIView *) theView   atFrame:(CGRect)r;
- (void)tpCornerWidth:(CGFloat)cornerWidth topLeftCorner:(BOOL)topLeft topRightCorner:(BOOL)topRight bottomLeftCorner:(BOOL)bottomLeft bottomRightCorner:(CGFloat)bottomRight;




@end
