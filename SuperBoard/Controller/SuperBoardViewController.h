//
//  WhiteBoardViewController.h
//  tupo
//
//  Created by wang on 15/8/17.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SuperBoardViewControllerDelegate <NSObject>

- (void)selectedWithImage:(UIImage *)image;

@end

@interface SuperBoardViewController : UIViewController

@property (nonatomic,weak) id<SuperBoardViewControllerDelegate> delegate;




@end
