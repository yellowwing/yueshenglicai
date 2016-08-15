//
//  ChangePasswordParam.h
//  YueSheng
//
//  Created by yellow on 16/8/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangePasswordParam : NSObject

@property(nonatomic,copy)NSString *Ui_Id;

@property(nonatomic,copy)NSString *oldPassword;

@property(nonatomic,copy)NSString *newsPassword;

//这里转为字典不能用MJExtention只能手动的，因为newsPassword不和接口参数对应

@end
