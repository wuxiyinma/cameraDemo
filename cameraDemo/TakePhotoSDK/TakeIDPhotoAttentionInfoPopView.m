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

@interface TakeIDPhotoAttentionInfoPopView()

@property (strong, nonatomic) UIView *popBackView;

@property (strong, nonatomic) UIImageView *verbImageView;

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
        
        _verbImageView.image = [UIImage imageNamed:@"Image.bundle/举例照片"];
        
    }
    
    return _verbImageView;
    
}

- (UIView *)popBackView
{
    
    if (_popBackView == nil) {
        
        _popBackView = [[UIView alloc] init];
        _popBackView.backgroundColor = [UIColor whiteColor];
        _popBackView.layer.cornerRadius = 10;
        _popBackView.layer.masksToBounds = YES;
        
        // 示例图片
        [_popBackView addSubview:self.verbImageView];
        [self.verbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(self->_popBackView);
            
            make.top.equalTo(self->_popBackView).with.offset(15);
            
        }];
        
        // 文字
        [_popBackView addSubview:self.verbLabel];
        [self.verbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self->_popBackView);
            make.top.equalTo(self.verbImageView.mas_bottom).with.offset(15);
            
        }];
        
        // 注意事项
        UILabel *attentionInfo1 = [self attentionInfoLabelWith:@"• 头部摆正"];
        [_popBackView addSubview:attentionInfo1];
        
        [attentionInfo1 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self->_popBackView).with.offset(20);
            make.top.equalTo(self.verbLabel.mas_bottom).with.offset(20);
            
        }];
        
        UILabel *attentionInfo2 = [self attentionInfoLabelWith:@"• 不戴帽子、露出耳朵和额头"];
        [_popBackView addSubview:attentionInfo2];
        
        [attentionInfo2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(attentionInfo1);
            make.top.equalTo(attentionInfo1.mas_bottom).with.offset(15);
            
        }];
        
        UILabel *attentionInfo3 = [self attentionInfoLabelWith:@"• 深色衣服"];
        [_popBackView addSubview:attentionInfo3];
        
        [attentionInfo3 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(attentionInfo1);
            make.top.equalTo(attentionInfo2.mas_bottom).with.offset(15);
            
        }];
        
        UILabel *attentionInfo4 = [self attentionInfoLabelWith:@"• 不超出人物示意线"];
        [_popBackView addSubview:attentionInfo4];
        
        [attentionInfo4 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(attentionInfo1);
            make.top.equalTo(attentionInfo3.mas_bottom).with.offset(15);
            
        }];
        
        UILabel *attentionInfo5 = [self attentionInfoLabelWith:@"• 站在白墙前"];
        [_popBackView addSubview:attentionInfo5];
        
        [attentionInfo5 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(attentionInfo1);
            make.top.equalTo(attentionInfo4.mas_bottom).with.offset(15);
            
        }];
        
        // 去拍摄
        [_popBackView addSubview:self.takePhotoButton];
        [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self->_popBackView);
            make.top.equalTo(attentionInfo5.mas_bottom).with.offset(20);
            
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
        
        self.backgroundColor = [UIColor stringTOColor:@"#363636" alpha:0.3];
        
    }
    
    return self;
    
}

- (void)open
{
    
    [self.popBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        
        make.width.mas_equalTo(320);
        
        make.height.mas_equalTo(470);
        
    }];
    
    [self layoutIfNeeded];
    
    self.popBackView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.popBackView.alpha = 0;
    
    // 淡入动画
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:10.0f
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         
                         self.popBackView.transform = CGAffineTransformMakeScale(1, 1);
                         self.popBackView.alpha = 1;
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
    
}

- (void)close
{
    
    [self removeFromSuperview];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//
//
//}

// 点击去拍摄
- (void)pressTakePhotoButton
{
    
    [self close];
    
}

@end
