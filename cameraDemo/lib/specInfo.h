//
//  specInfo.h
//  specInfo
//
//  Created by lufei on 2019/2/21.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface specInfo : NSObject

@property (copy, nonatomic, readonly, class) NSString *app_key;

@property (assign, nonatomic, readonly, class) int spec_id;

@property (assign, nonatomic, readonly,class) BOOL isFair;

@end
