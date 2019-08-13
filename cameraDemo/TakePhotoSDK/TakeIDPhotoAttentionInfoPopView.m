//
//  TakeIDPhotoAttentionInfoPopView.m
//  cameraDemo
//
//  Created by lufei on 2019/2/18.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import "TakeIDPhotoAttentionInfoPopView.h"
#import "UIColor+NJColorTool.h"
#import <Masonry.h>
#import "MK_Device.h"

// 屏幕宽高
#define kAPPH [[UIScreen mainScreen] bounds].size.height
#define kAPPW [[UIScreen mainScreen] bounds].size.width

@interface TakeIDPhotoAttentionInfoPopView()

{
    
    UILabel *_attentionInfo4;
    
    UILabel *_attentionInfo5;
    
}

@property (strong, nonatomic) UIView *popBackView;

@property (strong, nonatomic) UIImageView *verbImageView;
@property (strong, nonatomic) UIImageView *centerImageView;

@property (strong, nonatomic) UILabel *verbLabel;

@property (strong, nonatomic) UIButton *takePhotoButton;

@end

@implementation TakeIDPhotoAttentionInfoPopView

- (UIButton *)takePhotoButton
{
    
    if (_takePhotoButton == nil) {
        
        _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _takePhotoButton.layer.cornerRadius = 22;
        _takePhotoButton.layer.masksToBounds = YES;
        
        _takePhotoButton.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:125/255.0 alpha:1.0f];
        [_takePhotoButton setTitle:@"知道了，去拍照" forState:UIControlStateNormal];
        [_takePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_takePhotoButton setTitleColor:[UIColor colorWithRed:0 green:179/255.0 blue:125/255.0 alpha:1.0f] forState:UIControlStateHighlighted];
        [_takePhotoButton addTarget:self action:@selector(pressTakePhotoButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _takePhotoButton;
    
}

- (UILabel *)attentionInfoLabelWith:(NSString *)text
{
    
    UILabel *attentionInfo = [[UILabel alloc] init];
    attentionInfo.text = text;
    attentionInfo.textColor = [UIColor stringTOColor:@"#333333"];
    attentionInfo.font = [UIFont systemFontOfSize:16];
    return attentionInfo;
    
}

- (UILabel *)verbLabel
{
    
    if (_verbLabel == nil) {
        
        _verbLabel = [[UILabel alloc] init];
        
        _verbLabel.text = @"最佳证件照拍摄姿势";
        
        _verbLabel.textColor = [UIColor stringTOColor:@"#333333"];
        
        _verbLabel.font = [UIFont boldSystemFontOfSize:18];
        
    }
    
    return _verbLabel;
    
}

- (UIImageView *)verbImageView
{
    
    if (_verbImageView == nil) {
        
        _verbImageView = [[UIImageView alloc] init];
        _verbImageView.contentMode = UIViewContentModeScaleAspectFit;
        _verbImageView.image = [UIImage imageNamed:@"Image.bundle/topImage"];
        
    }
    
    return _verbImageView;
    
}

- (UIImageView *)centerImageView
{
    
    if (_centerImageView == nil) {
        
        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        _centerImageView.image = [UIImage imageNamed:@"Image.bundle/centerImage"];
        
    }
    
    return _centerImageView;
    
}

- (UIView *)popBackView
{
    
    if (_popBackView == nil) {
        
        _popBackView = [[UIView alloc] init];
        _popBackView.backgroundColor = [UIColor stringTOColor:@"#F7F7F7"];
        _popBackView.layer.cornerRadius = 10;
        _popBackView.layer.masksToBounds = YES;
        
        // 顶部图片
        [_popBackView addSubview:self.verbImageView];
        [self.verbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.equalTo(self->_popBackView).with.inset(15);
            make.top.equalTo(self->_popBackView).with.offset(30);
            make.height.equalTo(self.verbImageView.mas_width).with.multipliedBy(612.0/692.0);
            
        }];
        
        [_popBackView addSubview:self.centerImageView];
        /// 中间图片
        [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.right.equalTo(self->_popBackView).with.inset(15);
            make.top.equalTo(self.verbImageView.mas_bottom).with.offset(18);
            make.height.equalTo(self.centerImageView.mas_width).with.multipliedBy(300.0/690.0);

        }];
        
        // 去拍摄
        [_popBackView addSubview:self.takePhotoButton];
        [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self->_popBackView);
            make.bottom.equalTo(self->_popBackView).with.offset(-(35 + [MK_Device safeArea].bottom));
            make.width.mas_equalTo(270);
            make.height.mas_equalTo(44);
            
        }];
        
        [self addSubview:_popBackView];
        
    }
    
    return _popBackView;
    
}

- (instancetype)init
{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor stringTOColor:@"#000000" alpha:0.5];
        
    }
    
    return self;
    
}

- (void)open
{
    
    CGFloat topOffSet = 71.0/667.0 * kAPPW;
    
    [self addSubview:self.popBackView];
    [_popBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).with.offset(topOffSet + [MK_Device safeArea].top);
        
    }];
    
}

- (void)close
{
    
    [self removeFromSuperview];
    
}

// 点击去拍摄
- (void)pressTakePhotoButton
{
    
    [self close];
    
}

@end
