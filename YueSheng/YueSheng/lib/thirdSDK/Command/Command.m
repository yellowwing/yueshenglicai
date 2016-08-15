//
//  Command.m
//  InvestmentExpress
//
//  Created by UncleLi on 16/1/11.
//  Copyright © 2016年 YSLC. All rights reserved.
//

#import "Command.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Command

#pragma mark 字符串转换为日期时间对象
+(NSDate*)dateFromString:(NSString*)str{
    // 创建一个时间格式化对象
    NSDateFormatter *datef = [[NSDateFormatter alloc] init];
    // 设定时间的格式
    [datef setDateFormat:@"yyyy-MM-dd"];
    // 将字符串转换为时间对象
    NSDate *tempDate = [datef dateFromString:str];
    return tempDate;
}

#pragma mark 时间对象转换为时间字段信息
+(NSDateComponents*)dateComponentsWithDate:(NSDate*)date{
    if (date==nil) {
        date = [NSDate date];
    }
    // 获取代表公历的Calendar对象
    NSCalendar *calenar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 定义一个时间段的旗标，指定将会获取指定的年，月，日，时，分，秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段信息
    NSDateComponents *dateComp = [calenar components:unitFlags fromDate:date];
    return dateComp;
}

+(bool)isEqualWithFloat:(float)f1 float2:(float)f2 absDelta:(int)absDelta
{
    int i1, i2;
    i1 = (f1>0) ? ((int)f1) : ((int)f1 - 0x80000000);
    i2 = (f2>0) ? ((int)f2)  : ((int)f2 - 0x80000000);
    return ((abs(i1-i2))<absDelta) ? true : false;
}

+(NSObject *) getUserDefaults:(NSString *) name{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:name];
}

+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:defaults forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// MD5 16位加密
+ (NSString *)md5HexDigest:(NSString*)password
{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    return mdfiveString;
}

// 数值变化
+(NSString*)changePrice:(CGFloat)price{
    CGFloat newPrice = 0;
    NSString *danwei = @"万";
    if ((int)price>10000) {
        newPrice = price / 10000 ;
    }
    if ((int)price>10000000) {
        newPrice = price / 10000000 ;
        danwei = @"千万";
    }
    if ((int)price>100000000) {
        newPrice = price / 100000000 ;
        danwei = @"亿";
    }
    NSString *newstr = [[NSString alloc] initWithFormat:@"%.0f%@",newPrice,danwei];
    return newstr;
}


/**
 *  获取沙盒Document路径
 */
+ (NSString *)getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDiretory = [paths firstObject];
    return documentDiretory;
}

//创建本地文件
+(BOOL)createFileOnPath:(NSString *)plist_Path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plist_Path]) {
        return YES;
    }
    BOOL isSuccess = NO;
    [fileManager createFileAtPath:plist_Path contents:nil attributes:nil];
    NSMutableDictionary *dic = @{}.mutableCopy;
    isSuccess = [dic writeToFile:plist_Path atomically:YES];
    if (isSuccess) {
        NSLog(@"创建文件%@成功",plist_Path);
    }
    return isSuccess;
}

//时间戳
+(double)getTimeformattor{
    NSDate *datenow = [NSDate date];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return [datenow timeIntervalSince1970];
}

//获取当前日期
+(NSString *)getCurrentTime{

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    return [dateFormatter stringFromDate:currentDate];
}

+(NSString *)getCurrentDate{

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:currentDate];
}

+(NSString *)getYesterdayDate{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *yesterday = [NSDate dateWithTimeInterval:-60 * 60 * 24 sinceDate:currentDate];
    return [dateFormatter stringFromDate:yesterday];
}


@end
