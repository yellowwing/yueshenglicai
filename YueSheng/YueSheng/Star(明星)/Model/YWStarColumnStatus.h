//
//  YWStarColumnStatus.h
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWStarColumnStatus : NSObject

@property(nonatomic,copy)NSString *St_Id;

@property(nonatomic,copy)NSString *St_Name;


@property(nonatomic,assign,getter = isSelected)BOOL selected;

@end
