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
+ (void)createAndCheckImage:(NSData *)data success:(void (^)(NSDictionary *dataDic, NSString *fileurl))successBlock fail:(void (^)(NSError *error))failBlock;

/// 发出检测不通过的数据
+ (void)postCheckData:(NSDictionary *)dic withImage:(NSData *)fileData userKey:(NSString *)orderID;

@end
