//
//  TakeIDPhotoVC.m
//  cameraDemo
//
//  Created by lufei on 2019/2/18.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import "TakeIDPhotoVC.h"
#import "TakeIDPhotoAttentionInfoPopView.h"
#import <Masonry.h>
#import <LLSimpleCamera.h>
#import "MK_Device.h"
#import "UIColor+NJColorTool.h"
#import "TakePhotoResultVC.h"
#import "NetTool.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+ImageTool.h"
#import <PhotosUI/PhotosUI.h>
#import "TZImagePickerController.h"

static CGFloat scanTime = 3.0;
static CGFloat scanLineWidth = 42;
static NSString *const scanLineAnimationName = @"scanLineAnimation";

// 屏幕宽高
#define kAPPH [[UIScreen mainScreen] bounds].size.height
#define kAPPW [[UIScreen mainScreen] bounds].size.width

@interface TakeIDPhotoVC () <UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *scanLine;

@property (strong, nonatomic) LLSimpleCamera *camera;

@property (strong, nonatomic) UILabel *errorLabel;

// 预览图片
@property (nonatomic, strong) UIImageView *previewImageView;

// 拍照按钮
@property (strong, nonatomic) UIButton *snapButton;

// 相册按钮
@property (strong, nonatomic) UIButton* albumBu;

// 切换前后置
@property (strong, nonatomic) UIButton *changeCameraBtn;

@end

@implementation TakeIDPhotoVC

- (void)closeButtonEnable:(BOOL)enable
{
    
    _albumBu.enabled = enable;
    
    _snapButton.enabled = enable;
    
    _changeCameraBtn.enabled = enable;
    
}

- (UIView *)scanLineWithframe: (CGRect)frame{
    if (!_scanLine) {
        _scanLine = [[UIView alloc]initWithFrame:frame];
        _scanLine.hidden = YES;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.startPoint = CGPointMake(0.5, 0);
        gradient.endPoint = CGPointMake(0.5, 1);
        gradient.frame = _scanLine.layer.bounds;
        gradient.colors = @[(__bridge id)[[UIColor stringTOColor:@"#2CD5F8"] colorWithAlphaComponent:0].CGColor,(__bridge id)[[UIColor stringTOColor:@"#2CD5F8"] colorWithAlphaComponent:0.4f].CGColor,(__bridge id)[UIColor stringTOColor:@"#2CD5F8"].CGColor];
        gradient.locations = @[@0,@0.96,@0.97];
        [_scanLine.layer addSublayer:gradient];
    }
    return _scanLine;
}

- (void)addScanLineAnimationWith:(CGRect)frame{
    self.scanLine.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = @(- scanLineWidth);
    animation.toValue = @(frame.size.height - 32 - scanLineWidth);
    animation.duration = scanTime;
    animation.repeatCount = OPEN_MAX;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.scanLine.layer addAnimation:animation forKey:scanLineAnimationName];
}

- (UIImageView *)previewImageView
{
    
    if (_previewImageView == nil) {
        
        _previewImageView = [[UIImageView alloc] init];
        _previewImageView.contentMode = UIViewContentModeScaleAspectFit;
        _previewImageView.backgroundColor = [UIColor stringTOColor:@"#2E2E2E"];
        [self.camera.view addSubview:_previewImageView];
        [_previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.edges.equalTo(self.camera.view);

        }];

        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"Image.bundle/分组 4"];
        [_previewImageView addSubview:imageView];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerX.equalTo(self->_previewImageView);
            make.centerY.equalTo(self->_previewImageView).with.offset(-fabs(2/7.0 * kAPPH - [MK_Device navigationBar_StateBarHeight])/2.0);

        }];

        [_previewImageView layoutIfNeeded];

        [_previewImageView insertSubview:[self scanLineWithframe:CGRectMake(imageView.frame.origin.x + 5, imageView.frame.origin.y + 16, imageView.frame.size.width - 10, scanLineWidth)] belowSubview:imageView];

        [self addScanLineAnimationWith:imageView.frame];
        
    }
    
    return _previewImageView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.camera start];
    
}

/// 打开注意事项弹窗
- (void)openPopAlert {
    
    // 注意事项弹窗
    TakeIDPhotoAttentionInfoPopView *pop = [[TakeIDPhotoAttentionInfoPopView alloc] init];
    
    [[UIApplication sharedApplication].keyWindow addSubview:pop];
    
    [pop mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
        
    }];
    
    [pop open];
    
    pop.toAlbum = ^{
        
        [self openAlbum];
        
    };
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化相机
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:LLCameraPositionRear
                                             videoEnabled:NO];
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, kAPPW, kAPPH)];
    
    self.camera.fixOrientationAfterCapture = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"需要摄像头权限才能拍照\n请去手机“设置 - 隐私 - 相机”中打开权限";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor blackColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(kAPPW / 2.0f, kAPPH / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
                
            }
        }
    }];
    
    // 提示语
    UILabel *titleAlertLab = [[UILabel alloc] init];
    titleAlertLab.alpha = 0.9;
    titleAlertLab.backgroundColor = [UIColor stringTOColor:@"#FA8C15"];
    titleAlertLab.text = @"站在白墙前拍摄效果最佳~";
    titleAlertLab.textColor = [UIColor whiteColor];
    titleAlertLab.font = [UIFont systemFontOfSize:16];
    titleAlertLab.textAlignment = 1;
    
    titleAlertLab.layer.cornerRadius = 20;
    titleAlertLab.layer.masksToBounds = YES;
    
    [self.camera.view addSubview:titleAlertLab];
    
    [titleAlertLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.camera.view).with.offset(20 + [MK_Device navigationBar_StateBarHeight]);
        make.centerX.equalTo(self.camera.view.mas_centerX);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(240);
    }];
    
    // 背景图片
    UIImageView *cameraBack = [[UIImageView alloc] init];
    cameraBack.image = [UIImage imageNamed:@"Image.bundle/line_img"];
    [self.camera.view addSubview:cameraBack];
    CGFloat imageH = 2548.0/2880 * kAPPW;
    
    [cameraBack mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(imageH);
        
        make.top.equalTo(titleAlertLab.mas_bottom).with.offset(10);
        
        make.left.equalTo(self.camera.view).with.offset(0);
        
        make.right.equalTo(self.camera.view).with.offset(0);
        
    }];
    
    // 尾部视图
    UIView *footer = [self createFooter];
    [self.view addSubview:footer];
    [footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(cameraBack.mas_bottom).with.offset(10);
    }];
    
    [self openPopAlert];
    
}

// 创建尾部视图
- (UIView *)createFooter
{
    UIView *snapBtnView = [[UIView alloc] init];
    snapBtnView.backgroundColor = [UIColor stringTOColor:@"#1c1c1c" alpha:0.8];
    
    // 拍摄按钮
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.snapButton setImage:[UIImage imageNamed:@"Image.bundle/分组"] forState:UIControlStateNormal];
    [snapBtnView addSubview:self.snapButton];
    
    [self.snapButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(snapBtnView.mas_centerX);
        make.centerY.equalTo(snapBtnView.mas_centerY).with.offset(10);
        make.width.height.mas_equalTo(76);
        
    }];
    
    // 切换前后置摄像头
    if([LLSimpleCamera isFrontCameraAvailable] && [LLSimpleCamera isRearCameraAvailable]) {
        
        UIButton *changeCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeCameraBtn setImage:[UIImage imageNamed:@"Image.bundle/反转镜头-线性"] forState:UIControlStateNormal];
        [changeCameraBtn addTarget:self action:@selector(pressChangeCameraBtn) forControlEvents:UIControlEventTouchUpInside];
        [snapBtnView addSubview:changeCameraBtn];
        
        _changeCameraBtn = changeCameraBtn;
        
        [changeCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.snapButton.mas_centerY);
            make.left.equalTo(self.snapButton.mas_right).with.offset(50);
            
        }];
        
    }
    
    // 打开相册
    UIButton *openPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.albumBu = openPhotoBtn;
    [openPhotoBtn setImage:[UIImage imageNamed:@"Image.bundle/相册"] forState:UIControlStateNormal];
    [openPhotoBtn addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
    [snapBtnView addSubview:openPhotoBtn];
    
    [openPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.snapButton.mas_centerY);
        
        make.right.equalTo(self.snapButton.mas_left).with.offset(-50);
        
    }];
    
    /// 电子照证件更易合格
    UIImageView *eleImageView = [UIImageView new];
    eleImageView.image = [UIImage imageNamed:@"Image.bundle/eleCheckAcross"];
    [snapBtnView addSubview:eleImageView];
    
    [eleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(openPhotoBtn.mas_top).with.offset(8);
        make.centerX.equalTo(openPhotoBtn).with.offset(5);
        
    }];
    
    // 卡主本尊请就位
    UILabel *label = [UILabel new];
    label.textAlignment = 1;
    label.text = @"卡主本尊请就位";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor stringTOColor:@"#9b5d18" alpha:0.6];
    label.layer.cornerRadius = 20;
    label.layer.masksToBounds = YES;
    [snapBtnView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(snapBtnView).with.offset(10);
        make.centerX.equalTo(self.snapButton);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(35);
    }];
    
    return snapBtnView;
    
}


// 拍摄
- (void)snapButtonPressed:(UIButton *)button
{
    
    __weak typeof(self) weakSelf = self;
    
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        
        if (!error) {
            
            [weakSelf check_createPhoto:UIImageJPEGRepresentation(image, 1.0)];

            weakSelf.previewImageView.image = image;
            
            [self closeButtonEnable:NO];
            
        }
        
    } exactSeenImage:YES];
    
}

// 打开相册
- (void)openAlbum
{

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowTakePicture = false;
    imagePickerVc.allowPickingOriginalPhoto = true;
    imagePickerVc.isSelectOriginalPhoto = false;
    imagePickerVc.allowPickingVideo = false;
    imagePickerVc.processHintStr = @"";
    imagePickerVc.allowPreview = false;
    imagePickerVc.preferredLanguage = @"zh-Hans";
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        UIImage *original = photos.firstObject;
        NSData *originalData = UIImageJPEGRepresentation([UIImage fixOrientation:original], 1.0);
        [self check_createPhoto:originalData];
        self.previewImageView.image = original;
        [self closeButtonEnable:NO];
            
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

// 切换前后置摄像头
- (void)pressChangeCameraBtn
{
    
    [self.camera togglePosition];
    
}

#pragma TZImagePickerControllerDelegate

#pragma UIImagePickerControllerDelegate
// 获取图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //获取照片的原图数据
    UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *originalData = UIImageJPEGRepresentation([UIImage fixOrientation:original], 1.0);
    
    [self check_createPhoto:originalData];
    
    self.previewImageView.image = original;
    
    [self closeButtonEnable:NO];
    
}

- (void)check_createPhoto:(NSData *)data
{
    
    [NetTool createAndCheckImage:data success:^(NSDictionary *dataDic, NSString *fileurl) {
        
        if (self->_previewImageView) {
            
            [self.previewImageView removeFromSuperview];
            
            self.previewImageView = nil;
            
            [self closeButtonEnable:YES];
            
        }
        
        if ([dataDic[@"code"] intValue] == 200) {
            
            if ([dataDic[@"result"][@"check"] boolValue]) {
                
                TakePhotoResultVC *result = [[TakePhotoResultVC alloc] initWithType:NJTakePhotoResultDetectionSuccessed];
                result.title = @"证件照拍摄";
                result.wmImageUrlArray = dataDic[@"result"][@"file_name_wm"];
                result.imageUrlArray = dataDic[@"result"][@"file_name"];
                [self.navigationController pushViewController:result animated:YES];
                
                [result setFinalImageResult:^(NSString * _Nonnull finalImageUrlString, NSString * _Nonnull finalImageFileName, NSString * _Nonnull finalWatermarkImageUrlString, UIImage * _Nonnull finalWatermarkImage) {
                    
                    if (self.FinalImageResult) {
                        
                        self.FinalImageResult(finalImageUrlString, finalImageFileName, finalWatermarkImageUrlString, finalWatermarkImage);
                        
                    }
                    
                }];
                
                [result setToPop:^(BOOL isToPop) {
                    
                    if (isToPop) {
                        
                        [self openPopAlert];
                        
                    }
                    
                }];
                                
            } else {
                
                TakePhotoResultVC *result = [[TakePhotoResultVC alloc] initWithType:NJTakePhotoResultDetectionFailed];
                result.not_check_result = dataDic[@"not_check_result"];
                result.wmImageUrlArray = dataDic[@"result"][@"file_name_wm"];
                result.imageUrlArray = dataDic[@"result"][@"file_name"];
                result.title = @"证件照拍摄";
                [self.navigationController pushViewController:result animated:YES];
                
                [result setFinalImageResult:^(NSString * _Nonnull finalImageUrlString, NSString * _Nonnull finalImageFileName, NSString * _Nonnull finalWatermarkImageUrlString, UIImage * _Nonnull finalWatermarkImage) {
                    
                    if (self.FinalImageResult) {
                        
                        self.FinalImageResult(finalImageUrlString, finalImageFileName, finalWatermarkImageUrlString, finalWatermarkImage);
                        
                    }
                    
                }];
                
                [result setToPop:^(BOOL isToPop) {
                    
                    if (isToPop) {
                        
                        [self openPopAlert];
                        
                    }
                    
                }];
                
                /// 传递不通过数据
                [NetTool postCheckData:dataDic withImage:data userKey:self.orderID];
                
            }
            
        } else {
            
            if (dataDic[@"result"]) {
                
                [MBProgressHUD showError:dataDic[@"result"]];
                
            }
            
            if (dataDic[@"error"]) {
                
                [MBProgressHUD showError:dataDic[@"error"]];
                
            }
            
        }
        
    } fail:^(NSError *error) {
        
        if (self->_previewImageView) {
            
            [self.previewImageView removeFromSuperview];
            
            self.previewImageView = nil;
            
            [self closeButtonEnable:YES];
            
        }
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
