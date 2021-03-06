//
//  YWStarTool.h
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWStarParam.h"
#import "YWStarResult.h"

@interface YWStarTool : NSObject

/**
 *  @param param   请求参数,请求参数应该由外面决定
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)starStatusesWithParameters:(YWStarParam *)param success:(void(^)(YWStarResult *result))success failure:(void(^)(NSError *error))failure;

@end
