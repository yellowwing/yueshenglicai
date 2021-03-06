//
//  MJSettingViewControllerMJBaseSettingViewController00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJBaseSettingViewController.h"
#import "MJSettingArrowItem.h"
#import "MJSettingSwitchItem.h"
#import "MJSettingGroup.h"
#import "MJSettingCell.h"

@interface MJBaseSettingViewController ()
@end

@implementation MJBaseSettingViewController

- (id)init
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (NSArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MJSettingGroup *group = self.data[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    MJSettingCell *cell = [MJSettingCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    MJSettingGroup *group = self.data[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    MJSettingGroup *group = self.data[indexPath.section];
    MJSettingItem *item = group.items[indexPath.row];
    
    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[MJSettingArrowItem class]]) { // 箭头
        MJSettingArrowItem *arrowItem = (MJSettingArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        
        UIViewController *vc = [[arrowItem.destVcClass alloc] init];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc  animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MJSettingGroup *group = self.data[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    MJSettingGroup *group = self.data[section];
    return group.footer;
}
@end
