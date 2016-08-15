//
//  ArticleCommentCell.m
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ArticleCommentCell.h"

@interface ArticleCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation ArticleCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"articleComment";
    ArticleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleCommentCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setStatus:(ArticleCommentStatus *)status{
    _status = status;
    self.nameLabel.text = status.Ui_Nickname;
    
    self.timeLabel.text = status.Snc_Time;
    
    self.commentLabel.text = status.Snc_Content;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:status.Ui_Img] placeholderImage:[UIImage imageNamed:@"占位图片.jpg"]];
  
    
}

-(void)setFrame:(CGRect)frame{
    
    CGFloat hPadding = 0;
    CGFloat wPadding = 10;
    frame.origin.y += hPadding;
    frame.size.height -= hPadding;
    frame.origin.x += wPadding;
    frame.size.width -= 2*wPadding;
    [super setFrame:frame];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width/2;
    self.iconView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

}

@end
