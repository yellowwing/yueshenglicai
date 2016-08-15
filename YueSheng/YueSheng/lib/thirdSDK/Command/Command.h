//
//  Command.h
//  InvestmentExpress
//
//  Created by UncleLi on 16/1/11.
//  Copyright © 2016年 YSLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject

+(NSDate*)dateFromString:(NSString*)str;
+(NSDateComponents*)dateComponentsWithDate:(NSDate*)date;
+(bool)isEqualWithFloat:(float)f1 float2:(float)f2 absDelta:(int)absDelta;
+(NSObject *) getUserDefaults:(NSString *) name;
+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key;
+ (NSString *)md5HexDigest:(NSString*)password;
+(NSString*)changePrice:(CGFloat)price;

//创建本地文件
+(BOOL)createFileOnPath:(NSString *)plist_Path;
/**
 *  获取沙盒Document路径
 */
+ (NSString *)getDocumentPath;

//时间转为时间戳
+(double)getTimeformattor;

//获取当前日期
+(NSString *)getCurrentTime;

//获取日期
+(NSString *)getCurrentDate;

//获取当前日期的前一天
+(NSString *)getYesterdayDate;

@end
