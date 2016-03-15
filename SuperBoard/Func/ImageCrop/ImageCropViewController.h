//
//  ImageCropViewController.h
//  tupo
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCropDelegate <NSObject>

- (void)cropWithImage:(UIImage *)cropImage;

@end

@interface ImageCropViewController : UIViewController
@property (nonatomic,weak) id<ImageCropDelegate> delegate;

- (instancetype) initWithImage:(UIImage *)image;
@end
