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
#import "RSA+SHA1WithRSA.h"

@implementation NetTool

+ (void)postCheckData:(NSDictionary *)dic withImage:(NSData *)fileData userKey:(NSString *)orderID {
    
    NSMutableDictionary *toPostDic = [NSMutableDictionary dictionary];
    
    NSString *currentDate = [[NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970 * 1000] substringToIndex:12];
    
    NSString *mchntid = @"100000000066";
    NSString *txntype = @"6006";
    
    NSString *postUrlString = @"https://ypay.96225.com/mcappserv/pushfaceinfo";
    
    [toPostDic setValue:mchntid forKey:@"mchntid"];
    [toPostDic setValue:currentDate forKey:@"mchntseq"];
    [toPostDic setValue:txntype forKey:@"txntype"];
    
    NSString *encodedImageStr = [fileData base64EncodedStringWithOptions:0];
    [toPostDic setValue:encodedImageStr forKey:@"base64file"];
    
    /// 获取 fileurl
    NSMutableDictionary *reqstrDic = [NSMutableDictionary dictionary];
    
    /// 用户标志 orderid
    [reqstrDic setValue:orderID forKey:@"orderid"];
    [reqstrDic setValue:@([specInfo spec_id]) forKey:@"spec_id"];
    
    NSMutableArray *errlistArr = [NSMutableArray array];
    
    for (NSDictionary *res in dic[@"not_check_result"]) {
        
        NSMutableDictionary *errDic = [NSMutableDictionary dictionary];
        [errDic setValue:res[@"check_param"] forKey:@"check_param"];
        [errDic setValue:res[@"param_message"] forKey:@"param_desc"];
        [errDic setValue:res[@"check_value"] forKey:@"param_value"];
        
        [errlistArr addObject:errDic];
        
    }
    
    [reqstrDic setValue:errlistArr forKey:@"errlist"];
    
    NSString *reqstr = [NetTool convertToJsonData:reqstrDic];
    
    [toPostDic setValue:reqstr forKey:@"reqstr"];
    
    NSString *signString = [NSString stringWithFormat:@"%@%@%@%@", txntype, mchntid, currentDate, reqstr];
    
    NSString *sign = [RSA signSHA1WithRSA:signString privateKey:@"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmiCXPOwyFl4mT5KnZJ8iPL/nzt48ep4r/ovUpsNJO9YQ5ve6bBzmZFQpNzKWLirZwveJcQLhyW8/51gwBevwhqrGF4bTA0W9hmCdVpPt4qX6blrUehM6Uqu3YU30PFn1RruiziGf84cKpv3k3g/4doZa2rFa4DurKztpoH7XnehxAfXej3ffVzt7P4LVtZ64UT/9VOsZORUk6KN33xfE8xFTvV4a9eO+udtDCrD3Jy3tjT8N0TOKrl0ZL/Q/AZ1CDC8IRNTkV9QgbF7wxUE4l2HoU5aoAYfbuVoD3nLO542W7fz9PnK4Zv5k3wQBRUn1So0TkGJGQGS2fmvUVl+XrAgMBAAECggEAQCamWgQnOLc9eklV3J9ktTQIF4iYi3iDJSMDSkIhYeVWQGAYMIRB/eSLCZlSFEUlLp0XO+56nyMbJOT9zvwvcFCu/iIKXVTQkUnprSZW8Q5qBUmzD8SdR8vov7K5tDw3nmXAophjZpkZQgbOjUI9e/CpfEk7RsAIVoQEwqOkkTxrIkXawx8Q/c1Kj9K4PI4imq0YLuZmBrO1RaQu5Tnf3FJUw9J/It/AudTWmHKf1MDM5uEsjZdqbGAXhXfdYqA5NLKMtqA8zORPOaIKc3VlXrGJzgbHH5peyK+H53V7usjCjw0TPc+QyTqO/P8J/8U4pIx3Plsi13l6PxncMU95cQKBgQDjQRJrywHfsKK2RmvCybIgdAE1UaJ4K71rSj2JTFnBvMU+RmoaxQinINxJwnnH69pSOeo66PWOcH8bi9gzYcN5pHniyBDtZZgHv913SdrNv4X2tzGzK+dMIf5GnDyWRcaipTmJ9MYyZEcPi0e8hgn9MFPSLiTTmd/XIo94a9+67QKBgQC7mMTROgucORCSwSyq72mM+BB1Z3Muv/hxpW9KRZEA+YPQH3leC0+I2Kp71V9rWQSDBw+hlTfQJX2R+4LU6/p1c/+izCoAEm2hUqLawupJyJeVUZHCe3kz/BTkEutt/Abi2Rw2L/9SbhxSB1meA3fKUnxFHKsvz10IxJfa5PERNwKBgFMSlX5L/opb0o8ZHQlem7vbTBnGlsKhEqQmxmnrPCBjNiM2sFDK2AfoLj7UVZoscGmAfEw+no0MOJrEOytFQKS16ExrYCy356Rlkbqqh86QhZMTkppxoSKmhoIfWNKB/UO1bFwu20jOeV+IRZf306z3Ppzle1bSuA23t4SIwoddAoGANSieJRfIsHUvMBbTXIDJLSwiJdKxvf6iHToe5jH+XANYicJRdwfHeuTCsqKNDnNEJwj6MfSBw1bMVXCq60EPUPcU6oHmKO0P6dXr1gfDsjLIWYSqxCyO9N8q4FJIKntvTBrvtp81P5t6JPh2OaOL72YeVss/6yVcnJ5w1ZNoiFMCgYEAx3Sh+MfgB3O4Rlccts84FZW0liA2btMRn70nGxO/GRpHWf0t5SNcR3koOQVbT/2aeg8+0v9sxdkOEziFfPT4374ybQTJa+lLc4y5KN5EHOb9VsLkClcdO06d35JdMmUtkDqAhMezRm6JODLzwlN2X68qs0hRSd3VYCKO5zoYQMw="];
    
    [toPostDic setValue:sign forKey:@"sign"];
    
    [NetTool postWithUrl:postUrlString para:toPostDic success:^(NSDictionary *dataDic) {
//        NSLog(@"上传数据成功-----%@", dataDic);
    } fail:^(NSError *error) {
//        NSLog(@"%@", error.localizedDescription);
    }];
        
}

// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (void)createAndCheckImage:(NSData *)data success:(void (^)(NSDictionary *dataDic, NSString *fileurl))successBlock fail:(void (^)(NSError *error))failBlock;
{
    [NetTool getWithUrl:@"http://apicall.id-photo-verify.com/api/get_upload_policy" param:@{@"file_name":@"image.jpg"} success:^(NSDictionary *dataDic) {
        if ([dataDic[@"code"] intValue] == 200) {
            NSDictionary *resultDic = dataDic[@"result"];
            NSDictionary *dic = @{
                @"key":resultDic[@"key"],
                @"OSSAccessKeyId":resultDic[@"OSSAccessKeyId"],
                @"signature":resultDic[@"signature"],
                @"policy":resultDic[@"policy"],
                @"success_action_status":@(200),
            };
            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:resultDic[@"host"] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFormData:data name:@"file"];
                } error:nil];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionUploadTask *uploadTask;
            uploadTask = [manager
                          uploadTaskWithStreamedRequest:request
                          progress:^(NSProgress * _Nonnull uploadProgress) {
                          }
                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                              if (error) {
                                  /// error
                                  failBlock(error);
                              } else {
                                  /// success
                                  NSDictionary *dic = @{
                                                        @"file":resultDic[@"key"],
                                                        @"spec_id":@([specInfo spec_id]),
                                                        @"app_key":[specInfo app_key],
                                                        @"is_fair":@([specInfo isFair])
                                                        };
                                  [NetTool postWithUrl:@"http://apicall.id-photo-verify.com/api/cut_check_pic" para:dic success:^(NSDictionary *dataDic) {
                                      successBlock(dataDic, resultDic[@"origin_pic_url"]);
                                  } fail:^(NSError *error) {
                                      failBlock(error);
                                  }];
                              }
                          }];
            [uploadTask resume];
        } else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:600 userInfo:@{NSLocalizedDescriptionKey:@"未知错误"}];
            failBlock(error);
        }
    } fail:^(NSError *error) {
        failBlock(error);
    }];
}

+ (void)getWithUrl:(NSString *)urlString param:(NSDictionary *)dict success:(void (^)(NSDictionary *dataDic))successBlock fail:(void (^)(NSError *error))failBlock
{
    NSString *urlStr;
    if (![NSURL URLWithString:urlString]) {
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLFragmentAllowedCharacterSet];
        urlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    } else {
        urlStr = urlString;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}

+ (void)postWithUrl:(NSString *)urlString para:(NSDictionary *)dict success:(void (^)(NSDictionary *dataDic))successBlock fail:(void (^)(NSError *error))failBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}




@end
