//
//  TPScrollView.h
//  ScrollPin
//
//  Created by wang on 15/8/10.
//  Copyright (c) 2015年 wp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPSuperBoardCanvasView.h"

@class SuperBoardMainView;
@interface SuperBoardScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic,weak) SuperBoardMainView *mainView;

- (void)selectedWithImage:(UIImage *)image;//选中了图片

- (void)undoPreStep;

- (void)backOneStep;

- (void)clearAll;

- (UIImage *)getImage;//获取图片

@end
