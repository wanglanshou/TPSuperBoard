//
//  UIColor+TPColor.h
//  tupo
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TPColor)
+ (UIColor *)tpColorWithHex:(long)hexColor;
+ (UIColor *)tpColorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor *)tpColorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)tpColorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
+ (UIColor *)tpColorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)tpColorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;
@end
