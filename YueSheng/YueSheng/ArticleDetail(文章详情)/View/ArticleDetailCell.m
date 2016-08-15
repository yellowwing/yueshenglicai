//
//  ArticleDetailCell.m
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ArticleDetailCell.h"

@interface ArticleDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginConstraint;

@end

@implementation ArticleDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"articleDetail";
    ArticleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setStatus:(ArticleDetailStatus *)status{
    _status = status;
    self.titleLabel.text = status.Sn_Title;
    
    self.timeLabel.text = status.Sn_Time;
    
    self.contentLabel.text = status.Sn_Content;
    
   
    
    if (status.Sn_Img != nil && ![status.Sn_Img isEqualToString:@""]) {
         [self.iconView sd_setImageWithURL:[NSURL URLWithString:status.Sn_Img] placeholderImage:[UIImage imageNamed:@"占位图片.jpg"]];
        self.iconHeightConstraint.constant = 150;
        
        self.marginConstraint.constant = 10;
        
    }
    else{
        
        self.iconHeightConstraint.constant = 0;
        
        self.marginConstraint.constant = 0;
        
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
     self.iconView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
}

@end
