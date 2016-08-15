//
//  ArticleCommentHeaderView.m
//  YueSheng
//
//  Created by yellow on 16/7/29.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ArticleCommentHeaderView.h"

@interface ArticleCommentHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

@end

@implementation ArticleCommentHeaderView

+(instancetype)headerView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"ArticleCommentHeaderView" owner:nil options:nil].lastObject;
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.leftLine.layer.cornerRadius = 5;
    self.rightLine.layer.cornerRadius = 5;
    

}

@end
