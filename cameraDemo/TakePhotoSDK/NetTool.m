//
//  NetTool.m
//  IDPhotoVerify
//
//  Created by lufei on 2017/2/14.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "NetTool.h"
#import <UIKit+AFNetworking.h>
#import "specInfo.h"

@implementation NetTool

+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [AFHTTPSessionManager manager];
        
    });
    
    return _sharedManager;
}

+ (void)createAndCheckImage:(NSData *)data success:(void (^)(NSDictionary *dataDic))successBlock fail:(void (^)(NSError *error))failBlock;
{
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:1.0f];
    
    NSDictionary *dic = @{
                          
                          @"file":encodedImageStr,
                          @"spec_id":@([specInfo spec_id]),
                          @"app_key":[specInfo app_key],
                          @"is_fair":@([specInfo isFair])
                          
                          };
    
    [NetTool postWithUrl:@"http://apicall.id-photo-verify.com/api/cut_check_pic" para:dic success:^(NSDictionary *dataDic) {
        
        
        successBlock(dataDic);
        
        
    } fail:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)getWithUrl:(NSString *)urlString param:(NSDictionary *)dict success:(void (^)(NSDictionary *dataDic))successBlock fail:(void (^)(NSError *error))failBlock
{
    NSString *urlStr;
    
    if (![NSURL URLWithString:urlString]) {
        //        urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLFragmentAllowedCharacterSet];
        
        urlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        
    } else {
        urlStr = urlString;
    }
    
    AFHTTPSessionManager *manager = [self sharedManager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json" , @"text/html", nil];
    
    
    [manager GET:urlStr parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock(error);
        
    }];
}

+ (void)postWithUrl:(NSString *)urlString para:(NSDictionary *)dict success:(void (^)(NSDictionary *dataDic))successBlock fail:(void (^)(NSError *error))failBlock {
    
    AFHTTPSessionManager *manager = [self sharedManager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock(error);
        
    }];
}




@end
