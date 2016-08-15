//
//  YWStockTool.m
//  通信录
//
//  Created by yellow on 16/7/12.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWStockTool.h"
#import "YWHttpTool.h"
#import "MJExtension.h"
#import "YWStockStatus.h"
//#import "YWStockCacheTool.h"

@implementation YWStockTool


#warning - 写入数据库因为数据太多用很长时间，用多线程又会崩溃，所以只能叫后台做分页功能要么不写入数据库

+ (void)stockStatusesWithSuccess:(void(^)(NSArray *statuses))success failure:(void(^)(NSError *error))failure;{

    YWStockStatusParam *param = [[YWStockStatusParam alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/stock/getBlock.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        YWStockStatusResult *result = [YWStockStatusResult objectWithKeyValues:responseObject];
        //转小模型
        result.stock = [YWStockStatus objectArrayWithKeyValuesArray:result.stock] ;
        
        //手动刷新要清空数据库(以防数据重复)
//        [YWStockCacheTool deleteStatus];
//        //串行队列一般只开一个子线程，假如刷新多次也就开了多个任务也要排队
//        dispatch_queue_t queue = dispatch_queue_create("singal", DISPATCH_QUEUE_SERIAL);
//        dispatch_async(queue, ^{
//            YWLog(@"线程：%@",[NSThread currentThread]);
//            // 缓存(加入数据库)
//            [YWStockCacheTool addStatuses:result.stock];
//        });
        
        // 传递了block
        if (success) {
            success(result.stock);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];

}

+ (void)stockStatusesFirstWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    //先从缓存里面加载
//    NSArray *statusArray = [YWStockCacheTool statues];
    
//    if (statusArray.count) {//有缓存
//        //传递block
//        if (success) {
//            success(statusArray);
//        }
//    }
//    else{
        YWStockStatusParam *param = [[YWStockStatusParam alloc] init];
        
        NSString *url = [NSString stringWithFormat:@"%@AppJson/stock/getBlock.ashx",domainURL];
        
        [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
            
            //转大模型
            YWStockStatusResult *result = [YWStockStatusResult objectWithKeyValues:responseObject];
            //转小模型
            result.stock = [YWStockStatus objectArrayWithKeyValuesArray:result.stock] ;
            
            //串行队列一般只开一个子线程，假如刷新多次也就开了多个任务也要排队
//             dispatch_queue_t queue = dispatch_queue_create("singal", DISPATCH_QUEUE_SERIAL);
//            dispatch_async(queue, ^{
//                YWLog(@"线程：%@",[NSThread currentThread]);
//                //一开始就没有数据所以这里也不需要清空数据库
////                [YWStockCacheTool deleteStatus];
//                // 缓存(加入数据库)
//                [YWStockCacheTool addStatuses:result.stock];
//            });
           
            // 传递了block
            if (success) {
                success(result.stock);
            }

   
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
//  }

}


@end
