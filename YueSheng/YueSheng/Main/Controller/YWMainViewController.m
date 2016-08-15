//
//  YWMainViewController.m
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWMainViewController.h"

@interface YWMainViewController ()
- (IBAction)leftMenuClick:(UIBarButtonItem *)sender;
- (IBAction)rightMenuClick:(id)sender;

@end

@implementation YWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左边返回按钮不显示文字
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    
//    [GiFHUD setGifWithImageName:@"pika.gif"];
}


- (IBAction)leftMenuClick:(UIBarButtonItem *)sender {
    //在这里发送通知，叫YWRootViewController显示策划栏
    NSNotification *notification=[NSNotification notificationWithName:@"LeftMenuNotification" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (IBAction)rightMenuClick:(id)sender {
    //在这里发送通知，叫YWRootViewController显示策划栏
    NSNotification *notification=[NSNotification notificationWithName:@"RightMenuNotification" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}



@end
