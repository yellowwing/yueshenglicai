//
//  ReviewDetailTool.m
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ReviewDetailTool.h"

@implementation ReviewDetailTool
+(void)reviewDetailStatusesWithParameters:(ReviewDetailParam *)param success:(void (^)(ReviewDetailStatus *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/program/Get_ProgramDetails.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        ReviewDetailStatus *status = [ReviewDetailStatus objectWithKeyValues:responseObject];
      
        
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
