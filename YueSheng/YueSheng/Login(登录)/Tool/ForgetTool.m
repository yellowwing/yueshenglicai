//
//  ForgetTool.m
//  YueSheng
//
//  Created by yellow on 16/8/1.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ForgetTool.h"

@implementation ForgetTool
+(void)forgetStatusesWithParameters:(ForgetParam *)param success:(void (^)(ForgetStatus *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Users_AppJson/GetUsers_Info_Password.ashx",domainURL];
    
    [YWHttpTool Post:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        ForgetStatus *status = [ForgetStatus objectWithKeyValues:responseObject];
        
        // 传递了block
        if (success) {
            success(status);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}
@end
