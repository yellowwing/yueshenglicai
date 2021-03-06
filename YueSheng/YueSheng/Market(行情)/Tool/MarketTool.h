//
//  MarketTool.h
//  YueSheng
//
//  Created by yellow on 16/8/9.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarketStatus.h"
#import "MarketParam.h"
#import "MarketResult.h"

@interface MarketTool : NSObject


/**
 *  @param param   请求参数,请求参数应该由外面决定
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)marketStatusesWithParameters:(MarketParam *)param success:(void(^)(MarketResult *result))success failure:(void(^)(NSError *error))failure;


@end
