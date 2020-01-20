//
//  MLNChunkDelegate.h
//  LuaNative
//
//  Created by MOMO on 2020/1/20.
//  Copyright © 2020年 liu.xu_1586. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MLNChunkDelegate <NSObject>

@required
@property (nonatomic, strong) NSData *chunkData;
@property (nonatomic, copy) NSString *chunkFileName;
@property (nonatomic, copy) NSString *chunkContentType;

@end

NS_ASSUME_NONNULL_END
