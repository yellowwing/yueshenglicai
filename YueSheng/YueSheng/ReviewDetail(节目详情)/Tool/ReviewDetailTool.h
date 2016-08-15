//
//  ReviewDetailTool.h
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReviewDetailParam.h"
#import "ReviewDetailStatus.h"

@interface ReviewDetailTool : NSObject

/**
 *  @param param   请求参数,请求参数应该由外面决定
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)reviewDetailStatusesWithParameters:(ReviewDetailParam *)param success:(void(^)(ReviewDetailStatus *status))success failure:(void(^)(NSError *error))failure;

@end
