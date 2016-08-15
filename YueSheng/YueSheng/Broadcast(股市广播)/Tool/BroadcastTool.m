//
//  BroadcastTool.m
//  YueSheng
//
//  Created by yellow on 16/8/9.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "BroadcastTool.h"

@implementation BroadcastTool

+(void)broadcastToolWithSuccess:(void (^)(BroadcastStatus *))success failure:(void (^)(NSError *))failure{

    NSString *url = [NSString stringWithFormat:@"%@AppJson/program/Get_Program.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:@{} success:^(id responseObject) {
        
     
        BroadcastStatus *status = [BroadcastStatus objectWithKeyValues:responseObject];
  
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
