//
//  WhiteBoardViewController.m
//  tupo
//
//  Created by wang on 15/8/17.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "TPSuperBoardViewController.h"
#import "TPSuperboardDefine.h"

#import "TPSuperBoardMainView.h"
@interface TPSuperBoardViewController ()
{
    TPSuperBoardMainView *_mainView;
}
@end

@implementation TPSuperBoardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"超级白板";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    TPSuperBoardMainView *mainView = [[TPSuperBoardMainView alloc] initWithFrame:CGRectMake(0, 64, self.view.tpWidth, self.view.tpHeight - 64)];
    _mainView = mainView;
    mainView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:mainView];
    
}


- (void)send
{
    UIImage *image =  [_mainView getImage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedWithImage:)]) {
        [self.delegate selectedWithImage:image];
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
