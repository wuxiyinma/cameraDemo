//
//  MK_Device.m
//  IDphotomaker
//
//  Created by 杨尚达 on 2019/1/17.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import "MK_Device.h"

@implementation MK_Device

///安全区
+(UIEdgeInsets)safeArea{
    
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets res = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        return res;
    } else {
        // Fallback on earlier versions
        return UIEdgeInsetsZero;
    }
}

///导航栏+状态栏
+(CGFloat)navigationBar_StateBarHeight{
    if([self safeArea].bottom == 0){
        return 64.0;
    }else{
        return 88.0;
    }
}

///标签栏+安全区高度
+(CGFloat)tabbar_safeArea {
    return [self safeArea].bottom + 49.0;
}

///状态栏高度
+(CGFloat)stateBarHeight{
    if([self safeArea].bottom == 0){
        return 20.0;
    }else{
        return 44.0;
    }
}

@end
