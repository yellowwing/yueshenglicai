//
//  CheckCodeTool.m
//  YueSheng
//
//  Created by yellow on 16/8/1.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "CheckCodeTool.h"

@implementation CheckCodeTool
+(void)checkCodeStatusesWithParameters:(CheckCodeParam *)param success:(void (^)(CheckCodeStatus *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Users_AppJson/SendCheckNumber.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        CheckCodeStatus *status = [CheckCodeStatus objectWithKeyValues:responseObject];
        
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
