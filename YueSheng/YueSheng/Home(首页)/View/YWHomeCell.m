//
//  YWHomeCell.m
//  YueSheng
//
//  Created by yellow on 16/7/18.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWHomeCell.h"
#import "YWHomeStatus.h"
@interface YWHomeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end


@implementation YWHomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"home";
    YWHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YWHomeCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setStatus:(YWHomeStatus *)status{

    _status = status;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:status.NiImg] placeholderImage:[UIImage imageNamed:@"占位图片.jpg"]];

    self.titleLabel.text = status.NiTitle;
    
    self.contentLabel.text = status.NiContent;
    
    self.timeLabel.text = status.NiTime;
    
    self.sourceLabel.text = status.NiSource;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconView.layer.cornerRadius = 2;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
    
    self.timeLabel.layer.cornerRadius = 3;
    self.timeLabel.clipsToBounds = YES;
    self.sourceLabel.layer.cornerRadius = 2;
    self.sourceLabel.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

}

@end
