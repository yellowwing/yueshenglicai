//
//  MarketCell.m
//  YueSheng
//
//  Created by yellow on 16/8/9.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "MarketCell.h"

@interface MarketCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MarketCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"market";
    MarketCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MarketCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setStatus:(MarketStatus *)status{
    
    _status = status;
    
    self.titleLabel.text = status.title;
    
    self.timeLabel.text = status.date;
    self.contentLabel.text = status.content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
}

@end
