//
//  MLNAPIBase.h
//  LuaNative
//
//  Created by MOMO on 2020/1/19.
//  Copyright © 2020年 liu.xu_1586. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MLNFileSummary;

@interface MLNAPIBase : NSObject

+ (void)post:(NSString *)urlString
      params:(NSDictionary *)params
  completion:(void (^)(BOOL success, id responseData))completion;

+ (void)get:(NSString *)urlString
     params:(NSDictionary *)params
 completion:(nullable void (^)(BOOL success, id responseData))completion;

/**
 * 上传单个文件
 **/
+ (void)upload:(NSString *)urlString
        params:(NSDictionary *)params
          name:(NSString *)name
      filePath:(NSString *)filePath
      progress:(nullable void (^)(NSProgress *uploadProgress))progress
    completion:(nullable void (^)(BOOL success, id responseData))completion;

/**
 * 上传多个文件
 * urlString:服务器接口
 * params:参数
 * fileArray:[MLNFileSummary]
 **/
+ (void)upload:(NSString *)urlString
        params:(NSDictionary *)params
      dataArray:(NSArray<MLNFileSummary *> *)dataArray
      progress:(nullable void (^)(NSProgress *uploadProgress))progress
    completion:(nullable void (^)(BOOL success, id responseData))completion;

/**
* 下载小文件
**/
+ (void)download:(NSString *)urlString
          params:(NSDictionary *)params
        progress:(void (^)(NSProgress *downloadProgress))progress
      completion:(void (^)(BOOL success, id responseData))completion;

+ (void)downloadFile:(NSString *)urlString
          params:(NSDictionary *)params
        progress:(void (^)(NSProgress *downloadProgress))progress
      completion:(void (^)(BOOL success,  NSString *filePath, NSError  *error))completion;


@end

NS_ASSUME_NONNULL_END
