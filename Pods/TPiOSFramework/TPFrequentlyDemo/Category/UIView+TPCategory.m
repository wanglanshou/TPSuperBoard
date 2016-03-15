//
//  UIView+TPCategory.m
//  TPFrequentlyDemo
//
//  Created by wang on 16/3/15.
//  Copyright © 2016年 wp. All rights reserved.
//

#import "UIView+TPCategory.h"

#import <objc/runtime.h>

static char SG_ShowBlur ;
static char SG_ShowBlurImage;


@implementation UIView (TPCategory)

- (void)setTpLeft:(CGFloat)tpLeft
{
    CGRect frame = self.frame;
    frame.origin.x = tpLeft;
    self.frame = frame;
}

- (CGFloat)tpLeft
{
    return self.frame.origin.x;
}

- (CGFloat)tpRight
{
    return self.tpLeft + self.tpWidth;
}

- (void)setTpWidth:(CGFloat)tpWidth
{
    CGRect frame = self.frame;
    frame.size.width =tpWidth;
    self.frame = frame;
}

- (CGFloat)tpWidth
{
    return self.frame.size.width;
}

- (void)setTpHeight:(CGFloat)tpHeight
{
    CGRect frame = self.frame;
    frame.size.height = tpHeight;
    self.frame = frame;
}
- (CGFloat)tpHeight
{
    return self.frame.size.height;
}
- (void)setTpTop:(CGFloat)tpTop
{
    CGRect frame = self.frame;
    frame.origin.y = tpTop;
    self.frame = frame;
}

- (CGFloat)tpTop
{
    return self.frame.origin.y;
}

- (CGFloat)tpBottom
{
    return self.tpTop + self.tpHeight;
}

- (UIViewController *)tpGetViewController
{
    UIResponder *responder = self;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (UIView *)tpGetSuperViewWithClassName:(NSString *)className
{
    
    UIResponder *responder = self;
    while (responder) {
        Class class = [responder class];
        NSString *tempClassName = NSStringFromClass(class);
        if ([tempClassName isEqualToString:className]) {
            return (UIView *)responder;
        }
    }
    return nil;
}

- (BOOL)sg_isBlur{
    NSNumber *number = objc_getAssociatedObject(self, &SG_ShowBlur);
    if (!number) {
        return NO;
    }
    return [number boolValue];
}

- (void)setSg_isBlur:(BOOL)sg_isBlur{
    NSNumber *number = objc_getAssociatedObject(self, &SG_ShowBlur);
    if (!number) {
        objc_setAssociatedObject(self, &SG_ShowBlur, @(sg_isBlur), OBJC_ASSOCIATION_RETAIN);
        //  创建需要的毛玻璃特效类型
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        //  毛玻璃view 视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        effectView.frame = self.bounds;
        [self insertSubview:effectView atIndex:0];
        if (!sg_isBlur) {
            effectView.hidden = YES;
        }
        objc_setAssociatedObject(self, &SG_ShowBlurImage, effectView, OBJC_ASSOCIATION_RETAIN);
        return;
    }
    UIVisualEffectView *effectView = objc_getAssociatedObject(self, &SG_ShowBlurImage);
    effectView.hidden = NO;
}



- (UIImage *)tpScreenShot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return uiImage;
}
- (UIImage *)tpImageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    CGRect rect =self.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage],r);
    UIImage * imgeee = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    return imgeee;
}

- (void)tpCornerWidth:(CGFloat)cornerWidth topLeftCorner:(BOOL)topLeft topRightCorner:(BOOL)topRight bottomLeftCorner:(BOOL)bottomLeft bottomRightCorner:(CGFloat)bottomRight{
    UIRectCorner corner = 0;
    if (topLeft) {
        corner = corner | UIRectCornerTopLeft;
    }
    if (topRight) {
        corner = corner | UIRectCornerTopRight;
    }
    if (bottomLeft) {
        corner = corner | UIRectCornerBottomLeft;
    }
    if (bottomRight) {
        corner = corner | UIRectCornerBottomRight;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(cornerWidth, cornerWidth)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
