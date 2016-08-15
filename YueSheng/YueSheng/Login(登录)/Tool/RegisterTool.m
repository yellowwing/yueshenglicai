//
//  RegisterTool.m
//  YueSheng
//
//  Created by yellow on 16/8/1.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "RegisterTool.h"

@implementation RegisterTool
+(void)registerStatusesWithParameters:(RegisterParam *)param success:(void (^)(RegisterStatus *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Users_AppJson/Post_Users_Info_Registration.ashx",domainURL];
    
    [YWHttpTool Post:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        RegisterStatus *status = [RegisterStatus objectWithKeyValues:responseObject];
        
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
