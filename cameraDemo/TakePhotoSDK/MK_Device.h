//
//  MK_Device.h
//  IDphotomaker
//
//  Created by 杨尚达 on 2019/1/17.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MK_Device : NSObject

///安全区
+(UIEdgeInsets)safeArea;

///导航栏+状态栏
+(CGFloat)navigationBar_StateBarHeight;

///标签栏+安全区高度
+(CGFloat)tabbar_safeArea;

///状态栏高度
+(CGFloat)stateBarHeight;

@end

NS_ASSUME_NONNULL_END
