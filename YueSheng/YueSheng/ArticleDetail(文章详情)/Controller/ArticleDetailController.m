//
//  ArticleDetailController.m
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ArticleDetailController.h"
#import "ArticleDetailStatus.h"
#import "ArticleDetailParam.h"
#import "ArticleDetailCell.h"
#import "ArticleDetailTool.h"
#import "ArticleDetailResult.h"
#import "ArticleCommentCell.h"
#import "ArticleCommentStatus.h"
#import "ArticleCommentHeaderView.h"
#import "LoginViewController.h"
#import "YWNavigationController.h"
#import "PostCommentStatus.h"
#import "PostCommentParam.h"
#import "PostCommentTool.h"

@interface ArticleDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)NSArray *articleArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *commentBar;
- (IBAction)commentClick;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;


@property(nonatomic,copy)NSString *pageIndex;

@property(nonatomic,assign)BOOL isAnimation;

@end
@implementation ArticleDetailController

-(NSArray*)articleArray{
    if (_articleArray == nil) {
        _articleArray = [NSArray array];
    }
    return _articleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //xib还要加多这句，estimatedRowHeight和xib的cell高度是一样的
    self.tableView.estimatedRowHeight = 150;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadArticleData];
    
    self.commentBtn.layer.cornerRadius = 5;
    self.commentBtn.enabled = NO;
    
    // 监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.commentTextField.delegate = self;
    
    // 添加上拉加载更多控件
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    self.isAnimation = YES;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.isComment) {
        [self.commentTextField becomeFirstResponder];
    }
    self.isComment = NO;//防止dismiss又一次弹键盘
}

-(void)loadMoreData{
    
    NSInteger pageindex = self.pageIndex.integerValue;
    
    pageindex++;
    
    ArticleDetailParam *param = [[ArticleDetailParam alloc] init];
    param.Sn_Id = self.status.Sn_Id;
    param.pageSize = @"10";
    param.pageIndex = [NSString stringWithFormat:@"%ld",pageindex];
    
    [ArticleDetailTool detailArticleStatusesWithParameters:param success:^(ArticleDetailResult *result) {
        
        [self.tableView footerEndRefreshing];
        
        self.pageIndex = [NSString stringWithFormat:@"%ld",pageindex];
        
        NSArray *commentArray = self.articleArray[1];
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:commentArray];
        
        [mutableArray addObjectsFromArray:result.CommentList];
        
        NSArray *newCommentArray = mutableArray;
        
        NSMutableArray *articleArray = [NSMutableArray arrayWithArray:self.articleArray];
        
        [articleArray replaceObjectAtIndex:1 withObject:newCommentArray];
        
        self.articleArray = articleArray;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView footerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];

}

#pragma mark - 文本框代理
/**
 *  点击了return按钮(键盘最右下角的按钮)就会调用
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self commentClick];
    
    return YES;
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.tableView.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}



-(void)loadArticleData{
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    
    ArticleDetailParam *param = [[ArticleDetailParam alloc] init];
    param.Sn_Id = self.status.Sn_Id;
    param.pageSize = @"10";
    param.pageIndex = @"1";
    
    self.pageIndex = @"1";
    
    [ArticleDetailTool detailArticleStatusesWithParameters:param success:^(ArticleDetailResult *result) {
         [MBProgressHUD hideHUDForView:self.view];
        
        NSArray *detailArray = @[result.StarNews];
        self.articleArray = @[detailArray,result.CommentList];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.articleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.articleArray[section];
    
    return array.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *array = self.articleArray[indexPath.section];
    
if ([array[indexPath.row] isKindOfClass:[ArticleDetailStatus class]]) {
    // 1.创建cell
    ArticleDetailCell *cell = [ArticleDetailCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    cell.status = array[indexPath.row];
    
    return cell;
    
    }else{
        // 1.创建cell
        ArticleCommentCell *cell = [ArticleCommentCell cellWithTableView:tableView];
        
        // 2.给cell传递模型数据
        cell.status = array[indexPath.row];
        
        return cell;

    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        YWNavigationController *nav = [[YWNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
        [self presentViewController:nav animated:YES completion:^{
        }];
    }
    
}

- (IBAction)commentClick {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [defaults boolForKey:loginID];
    if (!isLogin) {//假如还没有登录
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"你还没有登录" message:@"是否现在登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
        return;

    }
    
    //已经登录了
    NSString *uid = [defaults objectForKey:uidID];
    
    PostCommentParam *param = [[PostCommentParam alloc] init];
    param.Sn_Id = self.status.Sn_Id;
    param.Ui_Id = uid;
    param.Snc_Content = self.commentTextField.text;
    
    [PostCommentTool postCommentStatusesWithParameters:param success:^(PostCommentStatus *status) {
        [MBProgressHUD hideHUDForView:self.view];
        
        if ([status.Status isEqualToString:@"0"]) {
            [self addComment:self.commentTextField.text];
            
            [MBProgressHUD showSuccess:@"发表成功"];
        }
        else{
            [MBProgressHUD showError:@"发表失败"];
            
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];
    
    self.commentBtn.enabled = NO;
    
    [self.view endEditing:YES];
    
    // 清空文字
    self.commentTextField.text = nil;
}

/**
 *  发送一条评论
 */
- (void)addComment:(NSString *)text
{
    // 1.数据模型
    ArticleCommentStatus *status = [[ArticleCommentStatus alloc] init];
    status.Ui_Nickname = @"我";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *icon = [defaults objectForKey:iconUrl];
    status.Ui_Img = icon;
    status.Snc_Content = text;
    
    // 2.设置数据模型的时间
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日 HH:mm";
    status.Snc_Time = [fmt stringFromDate:now];
    
    NSArray *commentArray = self.articleArray[1];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:commentArray];
    
    [mutableArray insertObject:status atIndex:0];
    
    NSArray *newCommentArray = mutableArray;
    
    NSMutableArray *articleArray = [NSMutableArray arrayWithArray:self.articleArray];
    
    [articleArray replaceObjectAtIndex:1 withObject:newCommentArray];
    
    self.articleArray = articleArray;
    
    // 3.刷新表格
    [self.tableView reloadData];
    
    // 4.自动滚动表格到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];

}

//这个方法在文本发生改变之前的一刻会被自动调用
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
      NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newText.length > 0) {
        self.commentBtn.enabled = YES;
    }
    else{
        self.commentBtn.enabled = NO;
    }
    return YES;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 1) {
        ArticleCommentHeaderView *header = [ArticleCommentHeaderView headerView];
        return header;
    }
    
    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 1) {
        return 18;
    }
    return 0.1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isAnimation == NO) {
        return;
    }
    
    if (indexPath.section == 0) {
        CATransform3D rotation;
        rotation = CATransform3DMakeRotation( (45.0*M_PI)/180, 0.0, 0.7, 0.4);
        rotation.m34 = 1.0/ -600;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        
        [UIView beginAnimations:@"rotation" context:NULL];
        [UIView setAnimationDuration:0.6];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];

    }
    self.isAnimation = NO;
    
}

@end
