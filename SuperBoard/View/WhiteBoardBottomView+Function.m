//
//  WhiteBoardBottomView+Function.m
//  tupo
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "WhiteBoardBottomView+Function.h"
#import "SuperBoardMainView.h"

#import "TPSuperboardDefine.h"
@implementation SuperBoardBottomView (Function)


#pragma mark - 选择图片
//加载图片
- (void)inputImage
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    imagePicker.allowsEditing = YES;
    [[self tpGetViewController] presentViewController:imagePicker animated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].statusBarHidden = NO;
        });
    }];
    
    
}

#pragma mark - 选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    ImageCropViewController *cropViewController = [[ImageCropViewController alloc] initWithImage:image];
    cropViewController.delegate = self;
    [[self tpGetViewController].navigationController pushViewController:cropViewController animated:YES];
    
}
//截图成功
- (void)cropWithImage:(UIImage *)cropImage
{
    [self.mainView selectedWithImage:cropImage];
}


#pragma mark - 撤销上一步
- (void)undoPreStep
{
    [self.mainView undoPreStep];
}

#pragma mark - 回退一步

- (void)backOneStep
{
    [self.mainView backOneStep];
}

#pragma mark - 清空

- (void)clearAll
{
    [self.mainView clearAll];
}
@end
