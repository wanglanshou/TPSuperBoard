//
//  UIImage+TPCategory.h
//  TinyVideo
//
//  Created by wang on 16/3/14.
//  Copyright © 2016年 wp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TPCategory)

/**
 *  将图片缩放
 *
 *  @param MBCount 要缩放到大小数目 单位是兆B
 *
 *  @return 缩放后到图片
 */
- (UIImage *)tpScaleToLength:(NSInteger)MBCount;

- (UIImage*)tpScaleToSize:(CGSize)size;

#pragma mark - color
- (UIImage *) tpImageWithTintColor:(UIColor *)tintColor;

- (UIImage *) tpImageWithGradientTintColor:(UIColor *)tintColor;

+ (UIImage *)tpGetPartOfImage:(UIImage *)img rect:(CGRect)partRect;

@end
