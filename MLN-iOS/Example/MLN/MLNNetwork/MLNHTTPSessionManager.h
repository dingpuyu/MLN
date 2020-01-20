//
//  MLNHTTPSessionManager.h
//  LuaNative
//
//  Created by MOMO on 2020/1/19.
//  Copyright © 2020年 liu.xu_1586. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MLNAPIParam, AFHTTPSessionManager;

@protocol AFMultipartFormData;

typedef NS_ENUM(NSUInteger, MLNRequestSerializer) {
    /// 设置请求数据为JSON格式
    MLNRequestSerializerJSON,
    /// 设置请求数据为二进制格式
    MLNRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, MLNResponseSerializer) {
    /// 设置响应数据为JSON格式
    MLNResponseSerializerJSON,
    /// 设置响应数据为二进制格式
    MLNResponseSerializerHTTP,
};

@interface MLNHTTPSessionManager : NSObject


+ (instancetype)sharedSessionManager;

// **
//* 发起Post请求
//**
- (NSURLSessionDataTask *)POSTWithParam:(MLNAPIParam *)param
                                   success:(void(^)(NSURLSessionDataTask *task, id responseData))success
                                   failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

// **
//* 发起Get请求
//**
- (NSURLSessionDataTask *)GETWithParam:(MLNAPIParam *)param
                                   success:(void(^)(NSURLSessionDataTask *task, id responseData))success
                                   failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

// **
//* 数据上传
//**
- (NSURLSessionDataTask *)requestWithAPIPara:(MLNAPIParam *)param
                   constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                     success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

// **
//* 数据上传
//**
- (NSURLSessionDataTask *)requestWithAPIPara:(MLNAPIParam *)param
                   constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                     progress:(nullable void (^)(NSProgress * progress))progress
                                     success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

// **
//* 数据下载
//**
- (NSURLSessionDataTask *)downloadWithAPIParam:(MLNAPIParam *)param
                                     progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                      success:(nullable void (^)(NSURLSessionDataTask *task, NSURLResponse *response, id responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask *task, NSURLResponse *response, NSError *error))failure;

// **
//* 数据下载
//**
- (NSURLSessionDownloadTask *)downloadWithAPIParam:(MLNAPIParam *)param
                                   destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                      progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                       success:(nullable void (^)(NSURLSessionDownloadTask *task, NSURLResponse *response, NSString *filePath))success
                                         failure:(nullable void (^)(NSURLSessionDownloadTask *task, NSURLResponse *response, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
