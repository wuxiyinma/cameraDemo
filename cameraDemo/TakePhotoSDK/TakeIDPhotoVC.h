//
//  TakeIDPhotoVC.h
//  cameraDemo
//
//  Created by lufei on 2019/2/18.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakeIDPhotoVC : UIViewController

/// 用户标识
@property (copy, nonatomic) NSString *orderID;

/**
 获取最终图片
 finalImageUrlString: 最终无水印图片Post请求url
 finalImageFileName: 最终无水印图片 文件名称 (app_key是固定的)
 finalWatermarkImageUrlString: 最终有水印图片url
 finalWatermarkImage: 最终有水印图片
 */
@property (nonatomic, copy) void (^FinalImageResult)(NSString *finalImageUrlString, NSString *finalImageFileName, NSString *finalWatermarkImageUrlString, UIImage *finalWatermarkImage);

@end

NS_ASSUME_NONNULL_END
