//
//  YWStockCacheTool.m
//  通信录
//
//  Created by yellow on 16/7/12.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWStockCacheTool.h"
#import "FMDB.h"
#import "YWStockStatus.h"

@implementation YWStockCacheTool


static FMDatabaseQueue *_queue;

+ (void)setup
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 2.创表 （两个字段 一个ID 一个模型就够了）
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_status (id integer primary key autoincrement,status blob);"];
    }];
}

+ (void)addStatuses:(NSArray *)statusArray
{
    for (YWStockStatus *status in statusArray) {
        [self addStatus:status];
    }
}

+ (void)addStatus:(YWStockStatus *)status
{
    [self setup];
    
    [_queue inDatabase:^(FMDatabase *db) {
        // 1.获得需要存储的数据
      
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:status];
        
        // 2.存储数据
       [db executeUpdate:@"insert into t_status (status) values(?)", data];
 
        
    }];
    
    [_queue close];
}

+(NSArray *)statues{
    
    [self setup];
    
    // 1.定义数组
    __block NSMutableArray *statusArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        statusArray = [NSMutableArray array];
        
        FMResultSet *rs = nil;
        
        rs = [db executeQuery:@"select * from t_status;"];
       
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"status"];
            YWStockStatus *status = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [statusArray addObject:status];
        }
    }];
    [_queue close];
    
    // 3.返回数据
    return statusArray;

}

//删除
+(void)deleteStatus
{
    [self setup];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from t_status";
        
        [db executeUpdate:deleteSql];
        
    }];
    
    [_queue close];
}

@end
