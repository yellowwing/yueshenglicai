//
//  ReviewDetailHeaderView.m
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ReviewDetailHeaderView.h"

@interface ReviewDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *compereLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ReviewDetailHeaderView

+(instancetype)headerView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"ReviewDetailHeaderView" owner:nil options:nil].lastObject;
    
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = 5;
    self.iconView.clipsToBounds = YES;
}

-(void)setStatus:(ReviewDetailStatus *)status{
    _status = status;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:status.RadP_Img] placeholderImage:[UIImage imageNamed:@"right_img"]];
    
    self.nameLabel.text = status.RadP_Name;
    
    self.compereLabel.text = [NSString stringWithFormat:@"主持人：%@",status.RadP_Compere];
    
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@",status.RadP_Time];

    
}



@end
