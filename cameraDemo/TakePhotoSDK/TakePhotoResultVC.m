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
    
    /// 不合格数组
    NSMutableArray *_unqualifiedArr;
    
    /// 映射字典
    NSDictionary *_mappingDic;
    
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
    
    /// 初始化不合格数组
    _unqualifiedArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    _mappingDic = @{
                    
                    @"background_color": @"背景色",
                    @"bg_shadow": @"背景阴影",
                    @"chin_bottom": @"下巴距图像下边缘",
                    @"clothes_similar": @"服装相似度",
                    @"eye_space": @"眼部距离",
                    @"eyes_center_left": @"双眼中心距图像左边缘",
                    @"eyes_close": @"闭眼程度",
                    @"eyes_nature": @"视线",
                    @"eyes_space_bottom": @"双眼中心距图像下边缘",
                    @"face_blur": @"模糊",
                    
                    @"face_center": @"脸部居中",
                    @"face_color": @"脸部颜色",
                    @"face_expression": @"脸部表情",
                    @"face_noise": @"脸部噪音",
                    @"face_unbalance": @"阴阳脸",
                    @"facial_pose": @"脸部姿态",
                    @"facial_shelter": @"脸部遮挡",
                    @"facial_width": @"脸部宽度",
                    @"file_size": @"文件大小",
                    @"glasses": @"眼镜样式",
                    
                    @"glasses_glare": @"眼镜反光",
                    @"hairline_top": @"头顶发际线",
                    @"head_length": @"头部长度",
                    @"shoulder_missed": @"肩膀完整性",
                    @"headpose_pitch": @"头部姿态",
                    @"headpose_roll": @"头部姿态",
                    @"headpose_yaw": @"头部姿态",
                    @"eyebrow_occlusion": @"眉毛遮挡",
                    @"eye_occlusion": @"眼睛遮挡",
                    @"nose_occlusion": @"鼻子遮挡",
                    
                    @"mouth_occlusion": @"嘴巴遮挡",
                    @"cheek_occlusion": @"脸颊遮挡",
                    @"ear_occlusion": @"耳朵遮挡",
                    @"decoration_occlusion": @"饰品遮挡",
                    @"ppi": @"分辨率",
                    @"hat_detection":@"帽子检测",
                    @"id_exist":@"手持证件照检测",
                    @"bare_shouldered":@"光膀检测",
                    @"body_posture":@"身体姿态",
                    @"face_contrast":@"对比度异常",
                    
                    @"face_too_dark":@"照片过暗",
                    @"lower_body_hanging":@"下半身悬空",
                    @"incomplete_head":@"头部完整性",
                    @"missing_shoulder":@"肩膀完整性",
                    @"sight_line":@"视线水平",
                    @"shoulder_equal":@"肩膀自然",
                    @"px_and_mm":@"像素和毫米大小",
                    @"photo_format":@"文件类型"
                    
                    };
    
    self.view.backgroundColor = [UIColor stringTOColor:@"#F4F4F4"];

    self.photoImageView.backgroundColor = [UIColor stringTOColor:@"#F4F4F4"];
    
    // 尾部视图
    [self createFooter];
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.lessThanOrEqualTo(@200);
        
        make.height.lessThanOrEqualTo(@246);
        
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
               
                if (self.type == NJTakePhotoResultDetectionFailed) {
                    
                    make.top.equalTo(self.view).with.offset([MK_Device navigationBar_StateBarHeight] + 25);
                    
                } else {
                    
                    make.top.equalTo(self.view).with.offset([MK_Device navigationBar_StateBarHeight] + 44);
                    
                }
                
            }];

        }

    }];
    
    if (self.type == NJTakePhotoResultDetectionFailed) {
        
        /// 请调整以下姿态，重新拍照
        UILabel *adjustLabel = [UILabel new];
        adjustLabel.text = @"请调整以下姿态，重新拍照";
        adjustLabel.textColor = [UIColor stringTOColor:@"#333333"];
        adjustLabel.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:adjustLabel];
        
        [adjustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.photoImageView.mas_bottom).with.offset(31);
            make.centerX.equalTo(self.view);
            
        }];
        
        UIView *leftLine = [UIView new];
        leftLine.backgroundColor = [UIColor stringTOColor:@"#C1C1C1"];
        [self.view addSubview:leftLine];
        
        UIView *rightLine = [UIView new];
        rightLine.backgroundColor = [UIColor stringTOColor:@"#C1C1C1"];
        [self.view addSubview:rightLine];
        
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(1);
            make.right.equalTo(adjustLabel.mas_left).with.offset(-5);
            make.width.mas_equalTo(30);
            make.centerY.equalTo(adjustLabel);
            
        }];
        
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(1);
            make.left.equalTo(adjustLabel.mas_right).with.offset(5);
            make.width.mas_equalTo(30);
            make.centerY.equalTo(adjustLabel);
            
        }];
        
        /// 处理检测项结果数组
        [self.check_result enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

            if (![obj boolValue]) {

                if (![key isEqual: @"name"]) {

                    if (self->_unqualifiedArr.count <= 6) {

                        [self->_unqualifiedArr addObject:key];

                    }

                }

            }

        }];
        
        [_unqualifiedArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *checkItem = obj;
            UIView *view = [self createCheckView:self->_mappingDic[checkItem]];
            [self.view addSubview:view];
            
            if (idx == 0) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.view);
                    make.width.mas_equalTo(kAPPW/2);
                    make.height.mas_equalTo(32);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(13);
                    
                }];
                
            }
            
            if (idx == 1) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(self.view);
                    make.width.mas_equalTo(kAPPW/2);
                    make.height.mas_equalTo(32);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(13);
                    
                }];
                
            }
            
            if (idx == 2) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.view);
                    make.width.mas_equalTo(kAPPW/2);
                    make.height.mas_equalTo(32);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(13 + 32);
                    
                }];
                
            }
            
            if (idx == 3) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(self.view);
                    make.width.mas_equalTo(kAPPW/2);
                    make.height.mas_equalTo(32);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(13 + 32);
                    
                }];
                
            }
            
            if (idx == 4) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.view);
                    make.width.mas_equalTo(kAPPW/2);
                    make.height.mas_equalTo(32);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(13 + 32 + 32);
                    
                }];
                
            }
            
            if (idx == 5) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(self.view);
                    make.width.mas_equalTo(kAPPW/2);
                    make.height.mas_equalTo(32);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(13 + 32 + 32);
                    
                }];
                
            }
            
            
        }];
        
    }
                             
}

- (UIView *)createCheckView:(NSString *)checkItemString {
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"Image.bundle/chacha"];
    [view addSubview:imageView];
    
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@"%@: 不合格", checkItemString];
    label.textColor = [UIColor stringTOColor:@"#820014"];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    [view addSubview:label];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.centerY.equalTo(view).with.offset(42);
        make.centerY.equalTo(view);
        
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imageView.mas_right).with.offset(5);
        make.centerY.equalTo(view);
        make.right.equalTo(view);
        
    }];
    
    return view;
    
}

- (void)createFooter
{
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor stringTOColor:@"#FBFBFB"];
    [self.view addSubview:bottomView];
    
    _bottomView = bottomView;
    
    if (self.type == NJTakePhotoResultDetectionFailed) {
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.left.right.equalTo(self.view);
            
            make.height.mas_equalTo(150 + [MK_Device safeArea].bottom);
            
        }];
        
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
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.left.right.equalTo(self.view);
            
            make.height.mas_equalTo(2/7.0 * kAPPH);
            
        }];
        
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
