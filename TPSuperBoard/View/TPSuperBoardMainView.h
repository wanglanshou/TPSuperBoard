//
//  WhiteBoardMainView.h
//  tupo
//
//  Created by wang on 15/8/17.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TPSuperBoardMainView : UIView

- (void)showViewLocatedX:(CGFloat)xPercent y:(CGFloat)yPercent sizeScale:(CGFloat)scale thumbnailImage:(UIImage *)thumbnailImage;


- (void)selectedWithImage:(UIImage *)image;

- (void)undoPreStep;

- (void)backOneStep;

- (void)clearAll;

- (UIImage *)getImage;

@end
