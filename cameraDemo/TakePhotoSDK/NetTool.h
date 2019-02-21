//
//  NetTool.h
//  IDPhotoVerify
//
//  Created by lufei on 2017/2/14.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetTool : NSObject

/// 制作并检测图片
+ (void)createAndCheckImage:(NSData *)data success:(void (^)(NSDictionary *dataDic))successBlock fail:(void (^)(NSError *error))failBlock;

@end
