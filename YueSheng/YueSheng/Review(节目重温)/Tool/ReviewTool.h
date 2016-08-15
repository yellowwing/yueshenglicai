//
//  ReviewTool.h
//  YueSheng
//
//  Created by yellow on 16/8/4.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReviewParam.h"
#import "ReviewStatus.h"
@interface ReviewTool : NSObject

/**
 *  @param param   请求参数,请求参数应该由外面决定
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)reviewStatusesWithParameters:(ReviewParam *)param success:(void(^)(NSArray *statusArray))success failure:(void(^)(NSError *error))failure;

@end
