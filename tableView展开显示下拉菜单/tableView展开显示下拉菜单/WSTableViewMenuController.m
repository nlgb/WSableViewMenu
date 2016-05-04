//
//  WSTableViewController.m
//  tableView展开显示下拉菜单
//
//  Created by sw on 16/3/20.
//  Copyright © 2016年 sw. All rights reserved.
//

#import "WSTableViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width // 屏幕宽度
#define SPACING_MIN 20 // 分隔线左右间距
#define LINE_HEIGHT 2 // 分隔线高度
#define CELL_HEIGHT 40 // cell高度
#define HEADER_HEIGHT 80 // 组头视图高度
#define FOOTER_HEIGHT 60 // 组尾视图高度

@interface WSTableViewController ()
@property(nonatomic, strong)NSMutableArray *sectionArray;//section标题
@property(nonatomic, strong)NSMutableArray *rowInSectionArray;//section中的cell个数
@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击
@end

@implementation WSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sectionArray = [NSMutableArray arrayWithObjects:@"标题1",@"标题2",@"标题3",@"标题4", nil];//每个分区的标题
    _rowInSectionArray = [NSMutableArray arrayWithObjects:@"4",@"2",@"5",@"6", nil];//每个分区中cell的个数
    _selectedArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0", nil];//这个用于判断展开还是缩回当前section的cell
    
    //    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    //    self.tableView.sectionFooterHeight = FOOTER_HEIGHT;
    
    //    self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //判断section的标记是否为1,如果是说明为展开,就返回真实个数,如果不是就说明是缩回,返回0.
    if ([_selectedArray[section] isEqualToString:@"1"]) {
        return [_rowInSectionArray[section]integerValue];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _sectionArray[indexPath.section];
    return cell;
}
#pragma mark - section内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //每个section上面有一个button,给button一个tag值,用于在点击事件中改变_selectedArray[button.tag   ]的值
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    sectionView.backgroundColor = [UIColor cyanColor];
    UIButton *sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionButton.frame = sectionView.frame;
    [sectionButton setTitle:[_sectionArray objectAtIndex:section] forState:UIControlStateNormal];
    [sectionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    sectionButton.tag = section;
    [sectionView addSubview:sectionButton];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}
#pragma mark button点击方法
-(void)buttonAction:(UIButton *)button
{
    if ([_selectedArray[button.tag] isEqualToString:@"0"]) {
        
        //                for (NSInteger i = 0; i < _sectionArray.count; i++) {
        //                    [_selectedArray replaceObjectAtIndex:i withObject:@"0"];
        //                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
        //                }
        
        
        //如果当前点击的section是缩回的,那么点击后就需要把它展开,是_selectedArray对应的值为1,这样当前section返回cell的个数就变为真实个数,然后刷新这个section就行了
        [_selectedArray replaceObjectAtIndex:button.tag    withObject:@"1"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag   ] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        //如果当前点击的section是展开的,那么点击后就需要把它缩回,使_selectedArray对应的值为0,这样当前section返回cell的个数变成0,然后刷新这个section就行了
        [_selectedArray replaceObjectAtIndex:button.tag    withObject:@"0"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag   ] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
