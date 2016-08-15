//
//  RegisterTool.h
//  YueSheng
//
//  Created by yellow on 16/8/1.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RegisterParam.h"
#import "RegisterStatus.h"
@interface RegisterTool : NSObject

/**
 *  @param param   请求参数,请求参数应该由外面决定
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)registerStatusesWithParameters:(RegisterParam *)param success:(void(^)(RegisterStatus *status))success failure:(void(^)(NSError *error))failure;

@end
