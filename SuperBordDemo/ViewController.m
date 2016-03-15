//
//  ViewController.m
//  SuperBordDemo
//
//  Created by wang on 16/3/15.
//  Copyright © 2016年 wp. All rights reserved.
//

#import "ViewController.h"
#import "TPSuperBoardViewController.h"
@interface ViewController ()<SuperBoardViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;

@end

@implementation ViewController
- (IBAction)btnCicked:(id)sender {
 
    TPSuperBoardViewController *superBoardViewController = [[TPSuperBoardViewController alloc] init];
    superBoardViewController.delegate = self;
    superBoardViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:superBoardViewController animated:YES];
    
    
    
    
    
    self.imageVIew.image = [UIImage imageNamed:@"TPWhiteBoard/WB_DrawIconSelected"];
    
}

- (void)selectedWithImage:(UIImage *)image{
    self.imageVIew.image = image;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"TPWhiteBoard.bundle/WB_DrawIconSelected"];;
    self.imageVIew.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
