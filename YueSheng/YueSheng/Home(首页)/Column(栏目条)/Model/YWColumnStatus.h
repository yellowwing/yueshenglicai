//
//  YWColumnStatus.h
//  YueSheng
//
//  Created by yellow on 16/7/18.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWColumnStatus : NSObject


@property(nonatomic,copy)NSString *StID;

@property(nonatomic,copy)NSString *StName;

@property(nonatomic,copy)NSString *StOrder;

@property(nonatomic,assign,getter = isSelected)BOOL selected;

@end
