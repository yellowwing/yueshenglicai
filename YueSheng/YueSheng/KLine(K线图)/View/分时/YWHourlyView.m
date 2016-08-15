//
//  YWHourlyView.m
//  通信录
//
//  Created by yellow on 16/7/13.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWHourlyView.h"

@implementation YWHourlyView

+(instancetype)hourlyView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"YWHourlyView" owner:nil options:nil].lastObject;
    
}


@end
