//
//  YWVedioTool.h
//  YueSheng
//
//  Created by yellow on 16/7/25.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWVedioParam.h"
#import "YWVedioResult.h"
@interface YWVedioTool : NSObject
/**
 *  @param param   请求参数,请求参数应该由外面决定
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)vedioStatusesWithParameters:(YWVedioParam *)param success:(void(^)(YWVedioResult *result))success failure:(void(^)(NSError *error))failure;

@end
