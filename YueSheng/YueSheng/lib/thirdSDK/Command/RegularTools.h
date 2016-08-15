//
//  HomeRightVC.h
//  InvestmentExpress
//
//  Created by UncleLi on 15/7/15.
//  Copyright (c) 2015年 YSLC. All rights reserved.
//

/**
 *  正则表达式
 */
#import <Foundation/Foundation.h>

@interface RegularTools : NSObject

/**
 *  验证邮箱
 *
 *  @param email 邮箱字符串
 *
 *  @return 是否邮箱
 *
 *  [A-Z0-9a-z] 表示 A-Z 与 0-9 与 a-z 任意一个
 *  {2,4}       表示 字符位大于2个，小于4个
 */
+ (BOOL) validateEmail:(NSString *)email;

/**
 *  手机号码验证
 *
 *  @param NSString 手机号码字符串
 *
 *  @return 是否手机号
 *
 *  (13[0-9]) 13开头
 */
+ (BOOL) validateMobile:(NSString *)mobile;

/**
 *  用户名验证
 *
 *  @param NSString 用户名字符串
 *
 *  @return 是否用户名
 *  {6,20}  6到20位
 */
+ (BOOL) validateUserName:(NSString *)name;

/**
 *  验证昵称
 *
 *  @param NSString 昵称字符串
 *
 *  @return 是否昵称
 *  {4,8}  4到8位
 */
+ (BOOL) validateNickname:(NSString *)nickname;

/**
 *  密码认证
 *
 *  @param NSString 密码字符串
 *
 *  @return 是否密码
 *  {6,20}  6到20位
 */
+ (BOOL) validatePassword:(NSString *)passWord;

/**
 *  身份证号
 *
 *  @param NSString 身份证号字符串
 *
 *  @return 是否身份证号
 *  d{14} 14位数字
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**
 *  MD5
 *
 *  @param 密码字符串
 */
+ (NSString *)md5:(NSString *)str;


@end
