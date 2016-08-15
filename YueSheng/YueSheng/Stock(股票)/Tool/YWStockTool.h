//
//  YWStockTool.h
//  通信录
//
//  Created by yellow on 16/7/12.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWStockStatusParam.h"
#import "YWStockStatusResult.h"


@interface YWStockTool : NSObject

/**
 *  加载首页的微博数据
 *
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)stockStatusesFirstWithSuccess:(void(^)(NSArray *statuses))success failure:(void(^)(NSError *error))failure;



+ (void)stockStatusesWithSuccess:(void(^)(NSArray *statuses))success failure:(void(^)(NSError *error))failure;

@end
