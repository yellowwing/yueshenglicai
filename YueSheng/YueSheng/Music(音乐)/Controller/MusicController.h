//
//  MusicController.h
//  YueSheng
//
//  Created by yellow on 16/8/6.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewListStatus.h"
#import "ReviewDetailStatus.h"

@interface MusicController : YWMainViewController

@property(nonatomic,strong)ReviewListStatus *status;

@property(nonatomic,strong)ReviewDetailStatus *detailStatus;

//还要传一个模型数组给它，因为要播放上一首和下一首
@property(nonatomic,strong)NSArray *statusArray;

@end
