//
//  TakeIDPhotoAttentionInfoPopView.h
//  cameraDemo
//
//  Created by lufei on 2019/2/18.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakeIDPhotoAttentionInfoPopView : UIView

- (void)open;

/// 去相册
@property (nonatomic, copy) void (^toAlbum)(void);

@end

NS_ASSUME_NONNULL_END
