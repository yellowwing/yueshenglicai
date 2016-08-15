//
//  YWHourlyTool.h
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWHourlyStatusParam.h"
#import "YWHourlyStatusResult.h"

@interface YWHourlyTool : NSObject

/**
 *  加载首页的微博数据
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)hourlyStatusesWithSuccess:(void(^)(NSArray *statuses))success failure:(void(^)(NSError *error))failure;

#warning -  数据层还没做好，因为没有数据所以先不做了
#warning - 假如返回的值成功还是失败应该是数据层处理，不应交给controller,只把请求成功还是失败交给controller

@end
