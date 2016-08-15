//
//  YWColumnTool.h
//  YueSheng
//
//  Created by yellow on 16/7/18.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWColumnParam.h"
#import "YWColumnResult.h"

@interface YWColumnTool : NSObject

/**
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)columnStatusesWithBtid:(NSString *)btid success:(void(^)(NSArray *statuses))success failure:(void(^)(NSError *error))failure;

@end
