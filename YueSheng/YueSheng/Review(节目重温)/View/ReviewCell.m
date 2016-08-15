//
//  ReviewCell.m
//  YueSheng
//
//  Created by yellow on 16/8/4.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ReviewCell.h"

@interface ReviewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ReviewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"review";
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReviewCell" owner:nil options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(void)setStatus:(ReviewStatus *)status{
    _status = status;
    self.titleLabel.text = status.RadP_Name;
    self.timeLabel.text = status.RadP_Time;

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
}

@end
