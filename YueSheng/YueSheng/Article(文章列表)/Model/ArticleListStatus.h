//
//  ArticleListStatus.h
//  YueSheng
//
//  Created by yellow on 16/7/27.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleListStatus : NSObject

@property(nonatomic,copy)NSString *Sn_Id;

@property(nonatomic,copy)NSString *Sn_Title;

@property(nonatomic,copy)NSString *Sn_Content;

@property(nonatomic,copy)NSString *Sn_Time;

@property(nonatomic,copy)NSString *Sn_Praise;

@property(nonatomic,copy)NSString *ComNumber;

@property(nonatomic,assign)BOOL isPraised;

@end
