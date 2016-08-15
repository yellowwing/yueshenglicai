//
//  ArticleListHeaderView.m
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ArticleListHeaderView.h"

@interface ArticleListHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;

@end


@implementation ArticleListHeaderView

+(instancetype)headerView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"ArticleListHeaderView" owner:nil options:nil].lastObject;
    
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width/2;
    self.iconView.clipsToBounds = YES;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconView.layer.borderWidth = 3;
    
    self.backgroundColor = [UIColor clearColor];
    
}


-(void)setStatus:(StarInfoStatus *)status{
    _status = status;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:status.Sif_Img] placeholderImage:[UIImage imageNamed:@"right_img"]];

    self.nameLabel.text = status.Sif_Name;

    self.attentionLabel.text = [NSString stringWithFormat:@"关注：%@",status.Sif_Relation];

}

@end
