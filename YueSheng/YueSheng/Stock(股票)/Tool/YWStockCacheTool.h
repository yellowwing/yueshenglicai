//
//  YWStockCacheTool.h
//  通信录
//
//  Created by yellow on 16/7/12.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YWStockStatus;

@interface YWStockCacheTool : NSObject

+ (void)addStatus:(YWStockStatus *)status;

+ (void)addStatuses:(NSArray *)statusArray;

+ (NSArray *)statues;



//删除
+(void)deleteStatus;

@end
