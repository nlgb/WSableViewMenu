//
//  WSTableViewMenuController.m
//  tableView展开显示下拉菜单
//
//  Created by sw on 16/3/19.
//  Copyright © 2016年 sw. All rights reserved.
//

#import "WSTableViewMenuController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width // 屏幕宽度
#define SPACING_MIN 20 // 分隔线左右间距
#define LINE_HEIGHT 2 // 分隔线高度
#define CELL_HEIGHT 40 // cell高度
#define HEADER_HEIGHT 80 // 组头视图高度
#define FOOTER_HEIGHT 60 // 组尾视图高度

@interface WSTableViewMenuController ()
//@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *sectionArray;//section标题
@property(nonatomic, strong)NSMutableArray *rowInSectionArray;//section中的cell个数
@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击
@end

@implementation WSTableViewMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.sectionFooterHeight = 60;
//    self.tableView.sectionHeaderHeight = 60;
    self.tableView.rowHeight = 40;
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    _sectionArray = [NSMutableArray arrayWithObjects:@"标题1",@"标题2",@"标题3",@"标题4", nil];//每个分区的标题
    _rowInSectionArray = [NSMutableArray arrayWithObjects:@"4",@"2",@"5",@"6", nil];//每个分区中cell的个数
    _selectedArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0", nil];//这个用于判断展开还是缩回当前section的cell
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfrowsInSectionArray:(NSInteger)section {
    
    //判断section的标记是否为1,如果是说明为展开,就返回真实个数,如果不是就说明是缩回,返回0.
    if ([_selectedArray[section] isEqualToString:@"1"]) {
        return [_rowInSectionArray[section]integerValue];
    }
    return 0;}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    }
    
    cell.textLabel.text = _sectionArray[indexPath.section];
    
    return cell;
}

#pragma mark - section内容 - 用每组的头部视图来做组标题
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //每个section上面有一个button,给button一个tag值,用于在点击事件中改变_selectedArray[button.tag - 1000]的值
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor cyanColor];
    UIButton *sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionButton.frame = sectionView.frame;
    [sectionButton setTitle:[_sectionArray objectAtIndex:section] forState:UIControlStateNormal];
    [sectionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    sectionButton.tag = 1000 + section;
    [sectionView addSubview:sectionButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SPACING_MIN, HEADER_HEIGHT - LINE_HEIGHT, SCREEN_WIDTH - 2 * SPACING_MIN, LINE_HEIGHT)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [sectionView addSubview:lineView];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

#pragma mark button点击方法
-(void)buttonAction:(UIButton *)button
{
    if ([_selectedArray[button.tag - 1000] isEqualToString:@"0"]) {
        
        //                for (NSInteger i = 0; i < _sectionArray.count; i++) {
        //                    [_selectedArray replaceObjectAtIndex:i withObject:@"0"];
        //                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
        //                }
        
        
        //如果当前点击的section是缩回的,那么点击后就需要把它展开,是_selectedArray对应的值为1,这样当前section返回cell的个数就变为真实个数,然后刷新这个section就行了
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"1"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        //如果当前点击的section是展开的,那么点击后就需要把它缩回,使_selectedArray对应的值为0,这样当前section返回cell的个数变成0,然后刷新这个section就行了
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"0"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FOOTER_HEIGHT)];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

@end
