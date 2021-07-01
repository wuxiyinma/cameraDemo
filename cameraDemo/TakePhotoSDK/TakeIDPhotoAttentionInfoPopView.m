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

@property (strong, nonatomic) UIButton *toAlbumButtom;

@end

@implementation TakeIDPhotoAttentionInfoPopView

- (UIButton *)takePhotoButton
{
    
    if (_takePhotoButton == nil) {
        
        _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _takePhotoButton.layer.cornerRadius = 22;
        _takePhotoButton.layer.masksToBounds = YES;
        _takePhotoButton.layer.borderColor = [UIColor stringTOColor:@"#14AD7E"].CGColor;
        _takePhotoButton.layer.borderWidth = 1;
        
        _takePhotoButton.backgroundColor = UIColor.whiteColor;
        [_takePhotoButton setImage:[UIImage imageNamed:@"Image.bundle/拍照"] forState:UIControlStateNormal];
        [_takePhotoButton setTitle:@"去拍照" forState:UIControlStateNormal];
        [_takePhotoButton setTitleColor:[UIColor stringTOColor:@"#14AD7E"] forState:UIControlStateNormal];
        _takePhotoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_takePhotoButton addTarget:self action:@selector(pressTakePhotoButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _takePhotoButton;
    
}

/// 去相册
- (UIButton *)toAlbumButtom
{
    
    if (_toAlbumButtom == nil) {
        
        _toAlbumButtom = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _toAlbumButtom.layer.cornerRadius = 22;
        _toAlbumButtom.layer.masksToBounds = YES;
        
        _toAlbumButtom.backgroundColor = [UIColor stringTOColor:@"#14AD7E"];
        [_toAlbumButtom setImage:[UIImage imageNamed:@"Image.bundle/219相册"] forState:UIControlStateNormal];
        [_toAlbumButtom setTitle:@"去相册添加电子证件照" forState:UIControlStateNormal];
        [_toAlbumButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _toAlbumButtom.titleLabel.font = [UIFont systemFontOfSize:14];
        [_toAlbumButtom addTarget:self action:@selector(pressAlbumButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _toAlbumButtom;
    
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
        _verbImageView.image = [UIImage imageNamed:@"Image.bundle/topImage"];
        
    }
    
    return _verbImageView;
    
}

- (UIImageView *)centerImageView
{
    
    if (_centerImageView == nil) {
        
        _centerImageView = [[UIImageView alloc] init];
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
            make.top.equalTo(self->_popBackView).with.offset(25);
            make.height.equalTo(self.verbImageView.mas_width).with.multipliedBy(306/346.0);
        }];
        
        [_popBackView addSubview:self.centerImageView];
        /// 中间图片
        [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_popBackView).with.inset(15);
            make.top.equalTo(self.verbImageView.mas_bottom).with.offset(14);
            make.height.equalTo(self.centerImageView.mas_width).with.multipliedBy(200/346.0);
        }];
        
        /// 底部
        UIView *bottomView = [self bottomView];
        [_popBackView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self->_centerImageView.mas_bottom);
            make.left.right.bottom.equalTo(self->_popBackView);
            
        }];
        
        [self addSubview:_popBackView];
        
    }
    
    return _popBackView;
    
}

- (UIView *)bottomView
{
    
    UIView *bottomView = [UIView new];
    
    CGFloat lastW = (kAPPW - 2 * 15 - 10);
    CGFloat takeW = lastW * 130/330.0;
    CGFloat albumW = lastW * 200/330.0;
    
    // 去拍摄
    [bottomView addSubview:self.takePhotoButton];
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bottomView).with.offset(15);
        make.centerY.equalTo(bottomView);
        make.width.mas_equalTo(takeW);
        make.height.mas_equalTo(44);
        
    }];
    
    /// 去相册
    [bottomView addSubview:self.toAlbumButtom];
    [self.toAlbumButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(bottomView).with.offset(-15);
        make.centerY.equalTo(bottomView);
        make.width.mas_equalTo(albumW);
        make.height.mas_equalTo(44);
        
    }];
    
    return bottomView;
    
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
    
    CGFloat topOffSet = 42.0/667.0 * kAPPW;
    
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

// 点击去拍照
- (void)pressAlbumButton
{
    
    [self close];
    
    if (self.toAlbum) {
        
        self.toAlbum();
        
    }
    
}

@end
