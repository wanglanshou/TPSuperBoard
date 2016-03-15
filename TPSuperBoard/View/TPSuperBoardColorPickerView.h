//
//  TPWhiteBoardColorPickerView.h
//  tupo
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 张珏. All rights reserved.
//  选取颜色

#import <UIKit/UIKit.h>


@interface TPSuperBoardColorPickerView : UIImageView

@end


@interface TPSuperBoardColorPickerViewColorCell : UICollectionViewCell
{
    UIView *_showColorView;
}

@property (nonatomic,assign) BOOL isSelected;

- (void)setColor:(UIColor *)color;

@end
