//
//  MLNMyHttpHandler.m
//  MLN_Example
//
//  Created by MoMo on 2019/9/2.
//  Copyright © 2019 MoMo. All rights reserved.
//

#import "MLNMyHttpHandler.h"
#import <AFNetworking.h>
#import "MLNAPIBase.h"
#import "MLNFileSummary.h"

@interface MLNMyHttpHandler ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation MLNMyHttpHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        NSMutableSet *myContentTypes = [NSMutableSet setWithSet: _manager.responseSerializer.acceptableContentTypes];
        [myContentTypes addObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = myContentTypes.copy;
    }
    return self;
}

- (void)dealloc
{
    [_manager invalidateSessionCancelingTasks:YES];
    _manager = nil;
}

- (void)http:(MLNHttp *)http download:(NSString *)urlString params:(NSDictionary *)params progressHandler:(void (^)(float, float))progressHandler completionHandler:(void (^)(BOOL, NSDictionary *, id, NSDictionary *))completionHandler {
    [MLNAPIBase downloadFile:urlString params:params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressHandler) {
            progressHandler(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount, downloadProgress.totalUnitCount);
        }
    } completion:^(BOOL success, NSString * _Nonnull filePath, NSError * _Nonnull error) {
        if (completionHandler) {
            if (error) {
                NSDictionary *errorDict = @{
                                                   @"em":error.localizedDescription,
                                                   @"ec":@(error.code)
                                                   };
                completionHandler(NO, nil, nil, errorDict);
            } else {
                NSDictionary *resultDict = @{
                                             @"__path": filePath,
                                             };
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                completionHandler(YES, resultDict, data, nil);
            }
        }
    }];
}

- (void)http:(MLNHttp *)http get:(NSString *)urlString params:(NSDictionary *)params completionHandler:(void (^)(BOOL, NSDictionary *, NSDictionary *))completionHandler {
    [MLNAPIBase get:urlString params:params completion:^(BOOL success, id  _Nonnull responseData) {
        if (success) {
            completionHandler(YES, responseData, nil);
        } else {
            completionHandler(NO, nil, responseData);
        }
    }];
    
    return;
    // Mock数据
    if ([urlString hasPrefix:@"https://www.apiopen.top/femaleNameApi"]) {
        NSString *messagePath = [[NSBundle mainBundle] pathForResource:@"gallery.bundle/json/message.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:messagePath];
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        if (completionHandler) {
            completionHandler(YES, info, @{@"error":@"wrong"});
        }
        return;
    }else if ([urlString hasPrefix:@"https://api.apiopen.top/musicRankingsDetails"]) {
        NSString *musicRankPath = [[NSBundle mainBundle] pathForResource:@"gallery.bundle/json/musicRank.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:musicRankPath];
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        if (completionHandler) {
            completionHandler(YES, info, @{@"error":@"wrong"});
        }
        return;
    } else if ([urlString hasPrefix:@"http://v2.api.haodanku.com/itemlist/apikey/fashion/cid/1/back/20"]) {
        NSString *fashionlistPath = [[NSBundle mainBundle] pathForResource:@"gallery.bundle/json/fashion.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:fashionlistPath];
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        if (completionHandler) {
            completionHandler(YES, info, @{@"error":@"wrong"});
        }
        return;
    }
    
    [self.manager GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionHandler) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                completionHandler(YES, responseObject, nil);
            } else if ([responseObject isKindOfClass:[NSArray class]]) {
                completionHandler(YES, @{@"result":responseObject}, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionHandler) {
            completionHandler(NO, nil, @{@"errmsg":error.localizedDescription,@"errcode":@(error.code)});
        }
    }];
}

- (void)http:(MLNHttp *)http post:(NSString *)urlString params:(NSDictionary *)params completionHandler:(void (^)(BOOL, NSDictionary *, NSDictionary *))completionHandler {
    [MLNAPIBase post:urlString params:params completion:^(BOOL success, id  _Nonnull responseData) {
        if (success) {
            completionHandler(YES, responseData, nil);
        } else {
            completionHandler(NO, nil, responseData);
        }
    }];
//    [self.manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (completionHandler) {
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                completionHandler(YES, responseObject, nil);
//            } else if ([responseObject isKindOfClass:[NSArray class]])
//            {
//                completionHandler(YES, @{@"result":responseObject}, nil);
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (completionHandler) {
//            completionHandler(NO, nil, @{@"errmsg":error.localizedDescription,@"errcode":@(error.code)});
//        }
//    }];
    
}

- (void)http:(MLNHttp *)http upload:(NSString *)urlString params:(NSDictionary *)params filePaths:(NSArray *)filePaths fileNames:(NSArray *)fileNames completionHandler:(void (^)(BOOL, NSDictionary *, NSDictionary *))completionHandler
{
    
    NSMutableArray *dataArray = @[].mutableCopy;
    
    for (int i = 0; i < filePaths.count;i++) {
        NSString *filePath = [filePaths objectAtIndex:i];
        NSString *fileKey = [fileNames objectAtIndex:i];
        
        if (!fileKey && !filePath) {
            if (completionHandler) {
                completionHandler(NO, nil, @{@"em":@"filePath、fileKey n不能为空串",@"ec":@10010});
            }
            return;
        }
        
        NSData *imgData = [NSData dataWithContentsOfFile:filePath];
        
        MLNFileSummary *fileSummary = [MLNFileSummary fileSummaryWithData:imgData
                                                                   name:fileKey
                                                                  index:i
                                                            summaryType:MLNFileSummaryType_Data
                                                            contentType:MLNFileContentType_Image];
        fileSummary.uploadFileName = filePath.lastPathComponent;
        [dataArray addObject:fileSummary];
    }

    [MLNAPIBase upload:urlString params:params dataArray:dataArray progress:nil completion:^(BOOL success, id  _Nonnull responseData) {
        if (completionHandler) {
            if (success) {
                completionHandler(YES, responseData, nil);
            } else  {
                completionHandler(NO, nil, responseData);
            }
        }
    }];
}

@end
