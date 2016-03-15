//
//  ImageCropViewController.m
//  tupo
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "ImageCropViewController.h"
#import "ImageCropView.h"
#import "TPSuperboardDefine.h"
@interface ImageCropViewController ()
{
    UIImage *_image;
    ImageCropView *_imageCropView;
}
@end

@implementation ImageCropViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"截图";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishScreenShot)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    ImageCropView *cropView = [[ImageCropView alloc] initWithFrame:CGRectMake(0, 0, self.view.tpWidth, self.view.tpHeight ) image:_image];
    _imageCropView = cropView;
    [self.view addSubview:cropView];
    
    
    
}

- (void)finishScreenShot
{
    UIImage *screenShotImage = [_imageCropView finishScreenShot];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cropWithImage:)]) {
        [self.delegate cropWithImage:screenShotImage];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
