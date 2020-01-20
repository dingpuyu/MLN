//
//  MLNFileSummary.m
//  LuaNative
//
//  Created by MOMO on 2020/1/20.
//  Copyright © 2020年 liu.xu_1586. All rights reserved.
//

#import "MLNFileSummary.h"

@implementation MLNFileSummary

- (instancetype)init
{
    if (self = [super init]) {
        _summaryType = MLNFileSummaryType_Data;
        _contentType = MLNFileContentType_Undefine;
    }
    return self;
}

- (instancetype)initFileSummaryWithData:(NSData *)aData
                                   name:(NSString *)aName
                                  index:(int)anIndex
                            summaryType:(MLNFileSummaryType)aSummaryType
                            contentType:(MLNFileContentType)aContentType
{
    if (self = [super init]) {
        _name = [aName copy];
        _index = anIndex;
        _summaryType = aSummaryType;
        _contentType = aContentType;
        _data = aData;
    }
    return self;
}

+ (instancetype)fileSummaryWithData:(NSData *)aData
                                             name:(NSString *)aName
                                             index:(int)anIndex
                                 summaryType:(MLNFileSummaryType)aSummaryType
                                   contentType:(MLNFileContentType)aContentType
{
    return [[self alloc] initFileSummaryWithData:aData
                                                         name:aName
                                                         index:anIndex
                                             summaryType:aSummaryType
                                              contentType:aContentType];
}

@end
