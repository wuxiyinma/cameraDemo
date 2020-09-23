//
//  ViewController.m
//  cameraDemo
//
//  Created by lufei on 2019/2/18.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import "ViewController.h"
#import "TakeIDPhotoVC.h"

@interface ViewController ()

{
    
    UIImageView *_imageView;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"demo";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"打开相机" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressButton) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    
    UIImageView *imageView = [UIImageView new];
    imageView.frame = CGRectMake(100, 300, 100, 100);
    [self.view addSubview:imageView];
    
    _imageView = imageView;
    
}

- (void)pressButton
{
    
    NSLog(@"打开相机Demo");
    
    TakeIDPhotoVC *takePhoto = [[TakeIDPhotoVC alloc] init];
    
    takePhoto.orderID = @"20170904300100002911";
    
    takePhoto.title = @"证件照拍摄";
    
    [takePhoto setFinalImageResult:^(NSString * _Nonnull finalImageUrlString, NSString * _Nonnull finalImageFileName, NSString * _Nonnull finalWatermarkImageUrlString, UIImage * _Nonnull finalWatermarkImage) {
       
        /// 此处获得所需数据
        self->_imageView.image = finalWatermarkImage;
        
        NSLog(@"finalImageUrlString: %@\n finalImageFileName: %@\n finalWatermarkImageUrlString: %@\n", finalImageUrlString, finalImageFileName, finalWatermarkImageUrlString);
        
    }];
    
    [self.navigationController pushViewController:takePhoto animated:YES];
    
}

@end
