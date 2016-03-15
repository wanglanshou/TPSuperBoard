//
//  WhiteBoardRightView.h
//  tupo
//
//  Created by wang on 15/8/17.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPSuperBoardRightView : UIView
- (void)showRightView;//每次点击画笔的时候要显示右边的视图
@end


@interface TPSuperBoardRightViewCell : UIButton
{
    UIImageView *_backView;
}
@property (nonatomic,assign) BOOL isSelected;


@end