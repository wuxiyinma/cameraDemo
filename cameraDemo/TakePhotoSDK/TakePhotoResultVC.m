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
    
    /// 是否需要pop
    BOOL _isPop;
    
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
        
    }
    
    return _photoImageView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isPop = true;
    
    /// 初始化不合格数组
    _unqualifiedArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.view.backgroundColor = [UIColor stringTOColor:@"#F4F4F4"];

    self.photoImageView.backgroundColor = [UIColor stringTOColor:@"#F4F4F4"];
    
    /// 尾部视图
    [self createFooter];
    
    /// 顶部背景视图
    UIView *backTopView = [UIView new];
    [self.view addSubview:backTopView];
    
    [backTopView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).offset([MK_Device navigationBar_StateBarHeight]);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self -> _bottomView.mas_top);
        
    }];
    
    /// 顶部视图
    UIView *topView = [UIView new];
    [backTopView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        make.center.equalTo(backTopView);
        
    }];
    
    CGFloat w = 200/375.0 * kAPPW;
    CGFloat h = 246/200.0 * w;
    
    [topView addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.lessThanOrEqualTo(@(w));
        make.height.lessThanOrEqualTo(@(h));
        make.centerX.top.equalTo(topView);
        
    }];
    
    // 无水印
    _imageFileName = _imageUrlArray.lastObject;
    _imagePostUrl = @"http://apicall.id-photo-verify.com/api/take_cut_pic";
    
    // 有水印
    _imageUrlString_wm = [NSString stringWithFormat:@"http://apicall.id-photo-verify.com/api/take_pic_wm/%@", _wmImageUrlArray.lastObject];
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrlString_wm] placeholderImage:[UIImage imageNamed:@"Image.bundle/等待"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

        if (!error) {

            self->_image_wm = image;
            
        }

    }];
    
    if (self.type == NJTakePhotoResultDetectionFailed) {
        
        /// 请调整以下姿态，重新拍照
        UILabel *adjustLabel = [UILabel new];
        adjustLabel.text = @"请调整以下姿态，重新拍照";
        adjustLabel.textColor = [UIColor stringTOColor:@"#333333"];
        adjustLabel.font = [UIFont boldSystemFontOfSize:16];
        [topView addSubview:adjustLabel];
        
        [adjustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.photoImageView.mas_bottom).with.offset(20);
            make.centerX.equalTo(self.view);
            
        }];
        
        UIView *leftLine = [UIView new];
        leftLine.backgroundColor = [UIColor stringTOColor:@"#C1C1C1"];
        [topView addSubview:leftLine];
        
        UIView *rightLine = [UIView new];
        rightLine.backgroundColor = [UIColor stringTOColor:@"#C1C1C1"];
        [topView addSubview:rightLine];
        
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
        [self.not_check_result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dic = (NSDictionary *)obj;
            
            if (self->_unqualifiedArr.count < 6) {
                
                [self->_unqualifiedArr addObject:dic[@"param_message"]];
                
            }
            
        }];
        
        static UIView *lastView;
        
        CGFloat insetLeftRight;
        CGFloat lineSpace;
        CGFloat checkItemH;
        
        if (kAPPH < 667) {
            
            insetLeftRight = 22/375.0 * kAPPW;
            lineSpace = 10;
            checkItemH = 15;
            
        } else {
            
            insetLeftRight = 42/375.0 * kAPPW;
            lineSpace = 13;
            checkItemH = 15;
            
        }
        
        [_unqualifiedArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *checkItem = obj;
            UIView *view = [self createCheckView:checkItem];
            [topView addSubview:view];
            
            lastView = view;
            
            if (idx == 0) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(topView).with.offset(insetLeftRight);
                    make.height.mas_equalTo(checkItemH);
                    make.right.equalTo(topView.mas_centerX);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(lineSpace);
                    
                }];
                
            }
            
            if (idx == 1) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(topView.mas_centerX);
                    make.right.equalTo(topView).with.offset(-insetLeftRight);
                    make.height.mas_equalTo(checkItemH);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(lineSpace);
                    
                }];
                
            }
            
            if (idx == 2) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(topView).with.offset(insetLeftRight);
                    make.right.equalTo(topView.mas_centerX);
                    make.height.mas_equalTo(checkItemH);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(lineSpace * 2 + checkItemH);
                    
                }];
                
            }
            
            if (idx == 3) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(topView.mas_centerX);
                    make.right.equalTo(topView).with.offset(-insetLeftRight);
                    make.height.mas_equalTo(checkItemH);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(lineSpace * 2 + checkItemH);
                    
                }];
                
            }
            
            if (idx == 4) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(topView).with.offset(insetLeftRight);
                    make.right.equalTo(topView.mas_centerX);
                    make.height.mas_equalTo(checkItemH);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(lineSpace * 3 + checkItemH + checkItemH);
                    
                }];
                
            }
            
            if (idx == 5) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(topView.mas_centerX);
                    make.right.equalTo(topView).with.offset(-insetLeftRight);
                    make.height.mas_equalTo(checkItemH);
                    make.top.equalTo(adjustLabel.mas_bottom).with.offset(lineSpace * 3 + checkItemH + checkItemH);
                    
                }];
                
            }
            
            
        }];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(lastView);
            
        }];
        
    } else {
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.photoImageView);
            
        }];
        
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    /// 返回上一页
    if (self.toPop) {
        
        self.toPop(_isPop);
        
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
        
        make.left.centerY.equalTo(view);
        make.centerY.equalTo(view);
        make.width.height.mas_equalTo(14);
        
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
            
            make.height.mas_equalTo(140 + [MK_Device safeArea].bottom);
            
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
    
    _isPop = false;
    
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
