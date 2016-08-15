//
//  YWColumnTool.m
//  YueSheng
//
//  Created by yellow on 16/7/18.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWColumnTool.h"
#import "YWColumnStatus.h"
@implementation YWColumnTool
+ (void)columnStatusesWithBtid:(NSString *)btid success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    
    YWColumnParam *param = [[YWColumnParam alloc] init];
    
    param.btid = btid;
        
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Get_SmallType.ashx",domainURL];
        
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
            //转模型
            NSArray *statusArray = [YWColumnStatus objectArrayWithKeyValuesArray:responseObject] ;
        
        //默认选中第一个
        if (statusArray.count) {
            YWColumnStatus *status = statusArray[0];
            status.selected = YES;

        }
        
            // 传递了block
            if (success) {
                success(statusArray);
            }
            
            
        } failure:^(NSError *error) {
            
            if (failure) {
                failure(error);
            }
            
        }];

    
}

@end
