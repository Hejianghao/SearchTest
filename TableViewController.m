//
//  TableViewController.m
//  SearchTest
//
//  Created by Johannes on 15/11/9.
//  Copyright © 2015年 何江浩. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"

@interface TableViewController ()<AddProtocol,UISearchResultsUpdating>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *reorderBtn;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *filteredData;

- (IBAction) reorderTableView:(id)sender;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataList = [[NSMutableArray alloc] initWithObjects:@"长安遇冯着",@"寄全椒山中道士",@"初发扬子寄元搭校书",@"郡斋雨中与诸文士燕集", nil];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    [_searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    self.definesPresentationContext = YES;//这样pushviewController 的时候searchBar才会在下面
}

/*
- (void) loadView {
    [super loadView];
    if (self.searchController.isActive) {
        [self.navigationController setNavigationBarHidden:YES];
        [self.searchController.view setHidden:NO];
    }
}
*/

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.searchController.isActive) {
        [self.navigationController setNavigationBarHidden:YES];
        [self.searchController.view setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) reorderTableView:(id)sender{
    if (!self.tableView.editing) {
        self.tableView.editing = YES;
        _reorderBtn.title = NSLocalizedString(@"Cancel", nil);
    } else {
        self.tableView.editing = NO;
        _reorderBtn.title = NSLocalizedString(@"Edit", <#comment#>);
    }
}

#pragma mark - AddTangshiDelegate
- (void) addTangshi:(NSString *)tangshi{
    [_dataList addObject:tangshi];
    [self.tableView reloadData];
}

- (void) updateTangshiWithIndex:(NSInteger)index andContent:(NSString *)content{
    if (index >= 0) {
        _dataList[index] = content;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.isActive) {
        return _dataList.count;
    } else {
        return _filteredData.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (!self.searchController.isActive) {
        cell.textLabel.text = _dataList[indexPath.row];
    } else {
        cell.textLabel.text = _filteredData[indexPath.row];
    }
    
    return cell;
}

- (nullable NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"Delete", nil);
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;//似乎必须先提出来才能使用
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTangShiViewController"];
    vc.delegate = self;
    
    NSString *tangShiCtn = nil;
    if (self.searchController.isActive) {
        tangShiCtn = _filteredData[index];
        vc.index = -1;
        [self.searchController.searchBar resignFirstResponder];
        //[self.searchController.view setHidden:YES];
    } else {
        tangShiCtn = _dataList[index];
        vc.index = index;//此时可以修改内容
    }
    vc.tangshiCtn = tangShiCtn;
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable NSArray<UITableViewRowAction *> *) tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Mark as no read", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"标记为未读");
    }];
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [_dataList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    NSArray *array = [[NSArray alloc] initWithObjects:action1,action, nil];
    return array;
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_dataList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }  else if (editingStyle == UITableViewRowActionStyleNormal) {
        NSLog(@"normal");
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

    [_dataList exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


//自定义继承方法
/*
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}


- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}*/
//以上方法取消编辑的时候删除

#pragma mark - UISearchResultsUpdating
- (void) updateSearchResultsForSearchController:(UISearchController *)searchController{
    [_filteredData removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",_searchController.searchBar.text];
    _filteredData = [[_dataList filteredArrayUsingPredicate:predicate] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%@",segue.identifier);
    //((ViewController *)segue.destinationViewController).delegate = self;
    ViewController *addViewController = segue.destinationViewController;
    addViewController.index = _dataList.count;
    [addViewController setValue:self forKey:@"delegate"];
    
}


@end
