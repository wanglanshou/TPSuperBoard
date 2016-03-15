//
//  WhiteBoardBottomView+Function.h
//  tupo
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "TPSuperBoardBottomView.h"
#import "TPSuperBoardImageCropViewController.h"
@interface TPSuperBoardBottomView (Function)<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ImageCropDelegate>

- (void)inputImage;

- (void)undoPreStep;

- (void)backOneStep;

- (void)clearAll;
@end
