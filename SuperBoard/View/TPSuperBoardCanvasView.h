//
//  TPWhiteBoardCanvasView.h
//  tupo
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SuperBoardScrollView;

@interface TPSuperBoardCanvasView : UIView

@property (nonatomic,weak) SuperBoardScrollView *scrollView;

- (void)undoPreStep;

- (void)backOneStep;

- (void)clearAll;


- (CGRect)getEffectiveRect;
@end
