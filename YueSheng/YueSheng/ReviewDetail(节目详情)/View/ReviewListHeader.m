//
//  ReviewListHeader.m
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ReviewListHeader.h"

@interface ReviewListHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation ReviewListHeader

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)setTitle:(NSString *)title{
    _title = [title copy];
    self.titleLabel.text = title;
}

+(instancetype)sectionHeader{
    
    return [[NSBundle mainBundle] loadNibNamed:@"ReviewListHeader" owner:nil options:nil].lastObject;
    
}
@end
