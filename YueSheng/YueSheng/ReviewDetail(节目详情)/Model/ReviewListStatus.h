//
//  ReviewListStatus.h
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewListStatus : NSObject

@property(nonatomic,copy)NSString *DbId;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *song;

@property(nonatomic,copy)NSString *time;

//下面两个参数app不需要用到
@property(nonatomic,copy)NSString *DbNumber;

@property(nonatomic,copy)NSString *DbPraise;

@end
