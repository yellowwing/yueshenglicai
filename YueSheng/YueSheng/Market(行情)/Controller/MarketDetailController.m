//
//  MarketDetailController.m
//  YueSheng
//
//  Created by yellow on 16/8/10.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "MarketDetailController.h"

@interface MarketDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation MarketDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = self.status.title;
    self.timeLabel.text = self.status.date;
    self.contentLabel.text = self.status.content;
    
    
}

@end
