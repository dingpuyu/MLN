//
//  MLNAPIParam.m
//  LuaNative
//
//  Created by MOMO on 2020/1/19.
//  Copyright © 2020年 liu.xu_1586. All rights reserved.
//

#import "MLNAPIParam.h"

@implementation MLNAPIParam

+ (instancetype)apiParamWith:(NSString *)urlString params:(nullable NSDictionary *)params
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)urlString,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    MLNAPIParam *apiParam = [[MLNAPIParam alloc] init];
    apiParam.urlString = encodedString;
    apiParam.params = params;
    return apiParam;
}

+ (instancetype)apiParamWith:(NSString *)urlString appendParams:(NSDictionary *)params
{
    NSString *appendString = urlString;
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSMutableString *paramsM = [NSMutableString string];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
            [paramsM appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
        }];
        if ([urlString hasSuffix:@"?"]) {
            appendString = [appendString stringByAppendingString:paramsM];
        } else {
            appendString = [appendString stringByAppendingString:@"?"];
            appendString = [appendString stringByAppendingString:paramsM];
        }
    }
     MLNAPIParam *apiParam = [MLNAPIParam apiParamWith:appendString params:nil];
    return apiParam;
}

@end
