//
//  TakePhotoResultVC.h
//  cameraDemo
//
//  Created by lufei on 2019/2/18.
//  Copyright © 2019年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum: NSUInteger {
    
    NJTakePhotoResultDetectionFailed, // 检测不通过
    NJTakePhotoResultDetectionSuccessed // 检测通过
    
} NJTakePhotoResultType;

@interface TakePhotoResultVC : UIViewController

- (instancetype)initWithType:(NJTakePhotoResultType)type;

/// 有水印图片数组
@property (strong, nonatomic) NSArray *wmImageUrlArray;

/// 无水印图片数组
@property (strong, nonatomic) NSArray *imageUrlArray;

/**
 获取最终图片
 finalImageUrlString: 最终无水印图片Post请求url
 finalImageFileName: 最终无水印图片 文件名称 (app_key是固定的)
 finalWatermarkImageUrlString: 最终有水印图片url
 finalWatermarkImage: 最终有水印图片
 */
@property (nonatomic, copy) void (^FinalImageResult)(NSString *finalImageUrlString, NSString *finalImageFileName, NSString *finalWatermarkImageUrlString, UIImage *finalWatermarkImage);

/// 检测不通过 列表
@property (strong, nonatomic) NSArray *not_check_result;

/// 返回上一页 打开弹窗
@property (nonatomic, copy) void (^toPop)(BOOL isToPop);

@end

NS_ASSUME_NONNULL_END
