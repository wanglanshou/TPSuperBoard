//
//  UIImage+TPCategory.m
//  TinyVideo
//
//  Created by wang on 16/3/14.
//  Copyright © 2016年 wp. All rights reserved.
//

#import "UIImage+TPCategory.h"

@implementation UIImage (TPCategory)

- (UIImage *)tpScaleToLength:(NSInteger)MBCount{
    
    CGSize imageSize = self.size;
    NSData *data = UIImagePNGRepresentation(self);
    if (data.length > MBCount * 1000 * 1000) {
        //超过最大限制
        CGFloat scale = MBCount * 1000 * 1000 /(CGFloat)data.length;
        CGSize newSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale);
        UIImage *scaleImage = [self tpScaleToSize:newSize];
        return scaleImage;
    }
    return self;
}
-(UIImage*)tpScaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

#pragma mark - color
- (UIImage *) tpImageWithTintColor:(UIColor *)tintColor{
    return [self tpImageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) tpImageWithGradientTintColor:(UIColor *)tintColor{
    return [self tpImageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}
- (UIImage *) tpImageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


+ (UIImage *)tpGetPartOfImage:(UIImage *)img rect:(CGRect)partRect
{
    CGImageRef imageRef = img.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return retImg;
}



@end
