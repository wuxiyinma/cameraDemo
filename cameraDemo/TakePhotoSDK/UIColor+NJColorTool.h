//
//  UIColor+NJColorTool.h
//  snapshotTool
//
//  Created by lufei on 2018/10/31.
//  Copyright © 2018年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (NJColorTool)

+ (UIColor *) stringTOColor:(NSString *)str;

+ (UIColor *) stringTOColor:(NSString *)str alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
