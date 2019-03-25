//
//  TakePhotoResultVC.m
//  cameraDemo
//
//  Created by lufei on 2019/2/18.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import "TakePhotoResultVC.h"
#import "UIColor+NJColorTool.h"
#import <Masonry.h>
#import "MK_Device.h"
#import <UIImageView+WebCache.h>
#import "NetTool.h"
#import "MBProgressHUD+MJ.h"

// 屏幕宽高
#define kAPPH [[UIScreen mainScreen] bounds].size.height
#define kAPPW [[UIScreen mainScreen] bounds].size.width

@interface TakePhotoResultVC ()

{
    // 有水印 图片 url
    NSString *_imageUrlString_wm;
    
    // 有水印 图片
    UIImage *_image_wm;
    
    // 无水印 图片 文件名称
    NSString *_imageFileName;
    
    // 无水印 图片 请求地址（post）
    NSString *_imagePostUrl;
    
    UIView *_bottomView;
    
}

@property (strong, nonatomic) UIImageView *photoImageView;

@property (assign, nonatomic) NJTakePhotoResultType type;

@end

@implementation TakePhotoResultVC

- (instancetype)initWithType:(NJTakePhotoResultType)type
{
    
    if (self = [super init]) {
        
        self.type = type;
        
    }
    
    return self;
    
}

- (UIImageView *)photoImageView
{
    
    if (_photoImageView == nil) {
        
        _photoImageView = [UIImageView new];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_photoImageView];
        
    }
    
    return _photoImageView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor stringTOColor:@"#F4F4F4"];

    self.photoImageView.backgroundColor = [UIColor stringTOColor:@"#F4F4F4"];
    
    // 尾部视图
    [self createFooter];
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.lessThanOrEqualTo(@246);
        
        make.height.lessThanOrEqualTo(@303);
        
        make.centerX.equalTo(self.view);
        
        make.top.equalTo(self.view).with.offset([MK_Device navigationBar_StateBarHeight] + 100);
        
    }];
    
    // 无水印
    _imageFileName = _imageUrlArray.lastObject;
    _imagePostUrl = @"http://apicall.id-photo-verify.com/api/take_cut_pic";
    
    // 有水印
    _imageUrlString_wm = [NSString stringWithFormat:@"http://apicall.id-photo-verify.com/api/take_pic_wm/%@", _wmImageUrlArray.lastObject];
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrlString_wm] placeholderImage:[UIImage imageNamed:@"Image.bundle/等待"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

        if (!error) {

            self->_image_wm = image;
            
            [self -> _photoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(self.view).with.offset([MK_Device navigationBar_StateBarHeight] + 44);
                
            }];

        }

    }];
    
}

- (void)createFooter
{
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor stringTOColor:@"#FBFBFB"];
    [self.view addSubview:bottomView];
    
    _bottomView = bottomView;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.view);
        
        make.height.mas_equalTo(2/7.0 * kAPPH);
        
    }];
    
    if (self.type == NJTakePhotoResultDetectionFailed) {
        
        UIButton *reTakePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reTakePhotoButton addTarget:self action:@selector(pressReTakePhotoButton) forControlEvents:UIControlEventTouchUpInside];
        [reTakePhotoButton setImage:[UIImage imageNamed:@"Image.bundle/分组"] forState:UIControlStateNormal];
        [bottomView addSubview:reTakePhotoButton];
        
        [reTakePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(bottomView);
            
        }];
        
        UILabel *reTakeLabel = [UILabel new];
        reTakeLabel.text = @"重拍";
        reTakeLabel.textColor = [UIColor stringTOColor:@"#14AD7E"];
        [bottomView addSubview:reTakeLabel];
        
        [reTakeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(reTakePhotoButton.mas_bottom).with.offset(5);
            
            make.centerX.equalTo(bottomView);
            
        }];
        
    } else {
        
        UIButton *dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dislikeButton.layer.cornerRadius = 25;
        dislikeButton.layer.masksToBounds = YES;
        dislikeButton.layer.borderColor = [UIColor stringTOColor:@"#14AD7E"].CGColor;
        dislikeButton.layer.borderWidth = 0.5;
        [dislikeButton setTitleColor:[UIColor stringTOColor:@"#14AD7E"] forState:UIControlStateNormal];
        [dislikeButton setTitle:@"不喜欢，再来一张" forState:UIControlStateNormal];
        [dislikeButton addTarget:self action:@selector(pressDislikeButton) forControlEvents:UIControlEventTouchUpInside];
        dislikeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:dislikeButton];
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeButton.layer.cornerRadius = 25;
        likeButton.layer.masksToBounds = YES;
        likeButton.backgroundColor = [UIColor stringTOColor:@"#14AD7E"];
        [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [likeButton setTitle:@"满意，继续" forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(pressLikeButton) forControlEvents:UIControlEventTouchUpInside];
        likeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:likeButton];
        
        [dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(bottomView);
            make.right.equalTo(bottomView.mas_centerX).with.offset(-6);
            
            make.left.equalTo(bottomView).with.offset(12);
            
            make.height.mas_equalTo(50);
            
        }];
        
        [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(bottomView);
            
            make.left.equalTo(bottomView.mas_centerX).with.offset(6);
            
            make.right.equalTo(bottomView).with.offset(-12);
            
            make.height.mas_equalTo(50);
            
        }];
        
    }
    
}

- (void)pressLikeButton
{
    
    if (!_image_wm) {
        
        [MBProgressHUD showError:@"图片未加载好，请稍候～"];
        
        return;
        
    }
    
    //得到当前视图控制器中的所有控制器
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController *vc = array[array.count - 3];
    
    [self.navigationController popToViewController:vc animated:YES];
    
    if (self.FinalImageResult) {
        
        
        self.FinalImageResult(_imagePostUrl, _imageFileName, _imageUrlString_wm, _image_wm);
        
        
    }
    
}

- (void)pressDislikeButton
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)pressReTakePhotoButton
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
