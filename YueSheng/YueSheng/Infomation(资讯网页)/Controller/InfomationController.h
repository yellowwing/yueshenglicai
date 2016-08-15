//
//  InfomationController.h
//  YueSheng
//
//  Created by yellow on 16/7/21.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeStatus.h"
#import "YWPagePictureStatus.h"
@interface InfomationController : UIViewController
@property(nonatomic,strong)YWHomeStatus *status;

@property(nonatomic,strong)YWPagePictureStatus *pictureStatus;

@property(nonatomic,assign)BOOL isLoadPagePicture;

@end
