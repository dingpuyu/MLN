//
//  MLNFileSummary.h
//  LuaNative
//
//  Created by MOMO on 2020/1/20.
//  Copyright © 2020年 liu.xu_1586. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 图片、音频、视频
typedef NS_ENUM(NSInteger, MLNFileContentType) {
    MLNFileContentType_Undefine = 0,
    MLNFileContentType_Image,
    MLNFileContentType_Audio,
    MLNFileContentType_Video,
    MLNFileContentType_Log
};

// 是二进制数据还是GUID
typedef NS_ENUM(NSInteger, MLNFileSummaryType) {
    MLNFileSummaryType_Undefine = 0,
    MLNFileSummaryType_Data,
    MLNFileSummaryType_Guid,
};

@interface MLNFileSummary : NSObject

@property (nonatomic, assign) MLNFileContentType contentType;
@property (nonatomic, assign) MLNFileSummaryType summaryType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *guid;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *md5;

@property (nonatomic, strong) NSString *uploadFileName;
@property (nonatomic, strong) NSString *uploadContentType;

+ (instancetype)fileSummaryWithData:(NSData *)aData
                               name:(NSString *)aName
                              index:(int)anIndex
                        summaryType:(MLNFileSummaryType)aSummaryType
                        contentType:(MLNFileContentType)aContentType;

@end

NS_ASSUME_NONNULL_END
