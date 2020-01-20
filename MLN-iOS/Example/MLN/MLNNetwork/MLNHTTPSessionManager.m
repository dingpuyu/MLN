//
//  MLNHTTPSessionManager.m
//  LuaNative
//
//  Created by MOMO on 2020/1/19.
//  Copyright © 2020年 liu.xu_1586. All rights reserved.
//

#import "MLNHTTPSessionManager.h"
#import "MLNAPIParam.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

static NSURLSessionConfiguration *configuration;
static AFHTTPSessionManager *_sessionManager;
static NSMutableArray *_allSessionTask;

@implementation MLNHTTPSessionManager

+ (instancetype)sharedSessionManager
{
    static MLNHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[MLNHTTPSessionManager alloc] init];
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    });
    return sessionManager;
}

+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
}

/**
 存储着所有的请求task数组
 */
- (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
    sessionManager ? sessionManager(_sessionManager) : nil;
}

+ (void)setRequestSerializer:(MLNRequestSerializer)requestSerializer {
    _sessionManager.requestSerializer = requestSerializer==MLNRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(MLNResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = responseSerializer==MLNResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}

- (NSURLSessionDataTask *)POSTWithParam:(MLNAPIParam *)param success:(void(^)(NSURLSessionDataTask *task, id responseData))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [_sessionManager POST:param.urlString parameters:param.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf mln_successWithTask:task responseData:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf mln_failureWithTask:task error:error failure:failure];
    }];
    [[self allSessionTask] addObject:task];
    return task;
}

- (NSURLSessionDataTask *)GETWithParam:(MLNAPIParam *)param success:(void (^)(NSURLSessionDataTask * task, id responseData))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [_sessionManager GET:param.urlString parameters:param.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf mln_successWithTask:task responseData:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf mln_failureWithTask:task error:error failure:failure];
    }];
    [[self allSessionTask] addObject:task];
    return task;
}

#pragma mark - 大文件上传
- (NSURLSessionDataTask *)requestWithAPIPara:(MLNAPIParam *)param
                   constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self requestWithAPIPara:param constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)requestWithAPIPara:(MLNAPIParam *)param
                   constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                                    progress:(void (^)(NSProgress *))progress
                                     success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                                     failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure
{
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [_sessionManager POST:param.urlString parameters:param.params constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(uploadProgress);
            });
        }
    }  success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf mln_successWithTask:task responseData:responseObject success:success];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf mln_failureWithTask:task error:error failure:failure];
    }];
    [[self allSessionTask] addObject:task];
    return task;
}

- (NSURLSessionDataTask *)downloadWithAPIParam:(MLNAPIParam *)param
                                      progress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock
                                       success:(void (^)(NSURLSessionDataTask * _Nonnull, NSURLResponse * _Nonnull, id _Nonnull responseData))success
                                       failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSURLResponse * _Nonnull, NSError * _Nonnull))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:param.urlString]];
    __weak typeof(self) weakSelf = self;
    __block NSURLSessionDataTask * task = [_sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                downloadProgressBlock(downloadProgress);
            });
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            [strongSelf mln_failureWithTask:task error:error failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failure) {
                    failure(task, response, error);
                }
            }];
        } else {
            [strongSelf mln_successWithTask:task responseData:responseObject success:^(NSURLSessionDataTask *task, id responseData) {
                if (success) {
                    success(task, response, responseData);
                }
            }];
        }
    }];
    [[self allSessionTask] addObject:task];
    return task;
}

- (NSURLSessionDownloadTask *)downloadWithAPIParam:(MLNAPIParam *)param
                                   destination:(nullable NSURL * (^)(NSURL *, NSURLResponse *))destination
                                      progress:(void (^)(NSProgress *))downloadProgressBlock
                                       success:(void (^)(NSURLSessionDownloadTask * _Nonnull, NSURLResponse * _Nonnull, NSString * _Nonnull))success
                                       failure:(void (^)(NSURLSessionDownloadTask * _Nonnull, NSURLResponse * _Nonnull, NSError * _Nonnull))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:param.urlString]];
    __block NSURLSessionDownloadTask *task = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            downloadProgressBlock ? downloadProgressBlock(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //有处理则不管，没有则按照默认处理方式存储
        if (destination) {
            return destination(targetPath, response);
        }
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"mln_download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error && failure) {
            failure(task, response, error);
        } else if(!error && success) {
            success(task, response, filePath.absoluteString);
        }
    }];

    [[self allSessionTask] addObject:task];
    return task;
}

- (void)mln_successWithTask:(NSURLSessionDataTask *)task responseData:(id)responseData success:(void(^)(NSURLSessionDataTask *task, id responseData))success
{
//    do something
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(task, responseData);
        });
    }
    [[self allSessionTask] removeObject:task];
}

- (void)mln_failureWithTask:(NSURLSessionDataTask *)task error:(NSError *)error failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
//    do something
    if (failure) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(task, error);
        });
    }
    [[self allSessionTask] removeObject:task];
}

@end
