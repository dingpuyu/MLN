//
//  MLNAPIBase.m
//  LuaNative
//
//  Created by MOMO on 2020/1/19.
//  Copyright © 2020年 liu.xu_1586. All rights reserved.
//

#import "MLNAPIBase.h"
#import "MLNHTTPSessionManager.h"
#import "MLNAPIParam.h"
#import "MLNChunkDelegate.h"
#import "AFURLRequestSerialization.h"
#import "MLNFileSummary.h"

@implementation MLNAPIBase

+ (void)post:(NSString *)urlString
      params:(NSDictionary *)params
 completion:(void (^)(BOOL success, id responseData))completion {
     MLNAPIParam *apiParam = [MLNAPIParam apiParamWith:urlString params:params];
     NSURLSessionDataTask *dataTask = [[MLNHTTPSessionManager sharedSessionManager] POSTWithParam:apiParam success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseData) {
         if (completion) {
             completion(YES, responseData);
         }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (completion) {
            NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
            [errorDict setObject:@(error.code) forKey:@"ec"];
            [errorDict setObject:error.localizedDescription forKey:@"em"];
            completion(NO, errorDict);
        }
    }];
    [dataTask resume];
}

+ (void)get:(NSString *)urlString
     params:(NSDictionary *)params
 completion:(void (^)(BOOL, id _Nonnull))completion
{
    MLNAPIParam *apiParam = [MLNAPIParam apiParamWith:urlString appendParams:params];
    NSURLSessionDataTask *dataTask = [[MLNHTTPSessionManager sharedSessionManager] GETWithParam:apiParam success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseData) {
        if (completion) {
            completion(YES, responseData);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (completion) {
            NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
            [errorDict setObject:@(error.code) forKey:@"ec"];
            [errorDict setObject:error.localizedDescription forKey:@"em"];
            completion(NO, errorDict);
        }
    }];
    [dataTask resume];
}

+ (void)upload:(NSString *)urlString
        params:(NSDictionary *)params
          name:(NSString *)name
      filePath:(NSString *)filePath
      progress:(void (^)(NSProgress * _Nonnull))progress
    completion:(void (^)(BOOL, id _Nonnull))completion
{
    MLNAPIParam *apiParam = [MLNAPIParam apiParamWith:urlString params:params];
    NSURLSessionDataTask *task = [[MLNHTTPSessionManager sharedSessionManager] requestWithAPIPara:apiParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        if (error && completion) {
            NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
            [errorDict setObject:@(error.code) forKey:@"ec"];
            [errorDict setObject:error.localizedDescription forKey:@"em"];
            completion(NO, errorDict);
        }
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (completion) {
            completion(YES, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (completion) {
            NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
            [errorDict setObject:@(error.code) forKey:@"ec"];
            [errorDict setObject:error.localizedDescription forKey:@"em"];
            completion(NO, errorDict);
        }
    }];
    [task resume];
}

+ (void)upload:(NSString *)urlString
        params:(NSDictionary *)params
     dataArray:(nonnull NSArray<MLNFileSummary *> *)dataArray
      progress:(void (^)(NSProgress * _Nonnull))progress completion:(void (^)(BOOL, id _Nonnull))completion
{
    MLNAPIParam *apiParam = [MLNAPIParam apiParamWith:urlString params:params];
    NSURLSessionDataTask *task = [[MLNHTTPSessionManager sharedSessionManager] requestWithAPIPara:apiParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        for (MLNFileSummary *aFileSummary in dataArray) {
            if (aFileSummary.summaryType == MLNFileSummaryType_Data) {
                NSData *sendData = aFileSummary.data;
                NSString *name = aFileSummary.name;
                NSString *uploadFileName = aFileSummary.uploadFileName ?: name;
                NSString *uploadContentType = aFileSummary.uploadContentType ?: @"image/jpeg";
                if ([sendData length] > 0 && name != nil) {
                    [formData appendPartWithFileData:sendData name:name fileName:uploadFileName mimeType:uploadContentType];
                }
            }
        }
        if (error && completion) {
            NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
            [errorDict setObject:@(error.code) forKey:@"ec"];
            [errorDict setObject:error.localizedDescription forKey:@"em"];
            completion(NO, errorDict);
        }
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (completion) {
            completion(YES, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (completion) {
            NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
            [errorDict setObject:@(error.code) forKey:@"ec"];
            [errorDict setObject:error.localizedDescription forKey:@"em"];
            completion(NO, errorDict);
        }
    }];
    [task resume];
}

+ (void)download:(NSString *)urlString
          params:(NSDictionary *)params
        progress:(nonnull void (^)(NSProgress * _Nonnull))progress
      completion:(nonnull void (^)(BOOL, id _Nonnull))completion
{
    MLNAPIParam *apiParam = [MLNAPIParam apiParamWith:urlString params:params];
    NSURLSessionDataTask *dataTask = [[MLNHTTPSessionManager sharedSessionManager] downloadWithAPIParam:apiParam progress:progress success:^(NSURLSessionDataTask * _Nonnull task, NSURLResponse * _Nonnull response, id  _Nonnull responseObject) {
        if (completion) {
            completion(YES, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (completion) {
            NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
            [errorDict setObject:@(error.code) forKey:@"ec"];
            [errorDict setObject:error.localizedDescription forKey:@"em"];
            completion(NO, errorDict);
        }
    }];
    [dataTask resume];
}

+ (void)downloadFile:(NSString *)urlString
              params:(NSDictionary *)params
            progress:(void (^)(NSProgress * _Nonnull))progress
          completion:(void (^)(BOOL, NSString * , NSError * ))completion
{
    MLNAPIParam *apiParam = [MLNAPIParam apiParamWith:urlString params:params];
    NSURLSessionDownloadTask *task = [[MLNHTTPSessionManager sharedSessionManager] downloadWithAPIParam:apiParam destination:nil progress:progress success:^(NSURLSessionDownloadTask * _Nonnull task, NSURLResponse * _Nonnull response, NSString * filePath) {
        if (completion) {
            completion(YES, filePath, nil);
        }
    } failure:^(NSURLSessionDownloadTask * _Nonnull task, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (completion) {
            completion(NO, nil, error);
        }
    }];
    [task resume];
}

@end
