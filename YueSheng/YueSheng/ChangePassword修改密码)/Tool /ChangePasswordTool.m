//
//  ChangePasswordTool.m
//  YueSheng
//
//  Created by yellow on 16/8/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ChangePasswordTool.h"

@implementation ChangePasswordTool
+(void)changePasswordStatusesWithParameters:(ChangePasswordParam *)param success:(void (^)(ChangePasswordStatus *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Users_AppJson/Post_Users_Info_Edit.ashx",domainURL];
    //这里不能用mjExtention，只能用手动转为字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"Ui_Id"] = param.Ui_Id;
    dictionary[@"oldPassword"] = param.oldPassword;
    dictionary[@"newPassword"] = param.newsPassword;
    
    [YWHttpTool Post:url parameters:dictionary success:^(id responseObject) {
        
        //转大模型
        ChangePasswordStatus *status = [ChangePasswordStatus objectWithKeyValues:responseObject];
        
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
