//
//  MLNAPIParam.h
//  LuaNative
//
//  Created by MOMO on 2020/1/19.
//  Copyright © 2020年 liu.xu_1586. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLNAPIParam : NSObject

+ (instancetype)apiParamWith:(NSString *)urlString params:(nullable NSDictionary *)params;
//追加参数param，get请求使用
+ (instancetype)apiParamWith:(NSString *)urlString appendParams:(NSDictionary *)params;


@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) id otherPara;

@end

NS_ASSUME_NONNULL_END
