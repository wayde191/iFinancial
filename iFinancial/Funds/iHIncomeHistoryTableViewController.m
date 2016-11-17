//
//  iHIncomeHistoryTableViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 3/31/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHIncomeHistoryTableViewController.h"
#import "iHIncomeHisModel.h"
#import "MobClick.h"
#import "LPLoginViewController.h"
#import "iHAppDelegate.h"

@interface iHIncomeHistoryTableViewController (){
}
- (void)setupRefreshControl;
@end

@implementation iHIncomeHistoryTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _dataModel = [[iHIncomeHisModel alloc] init];
    _dataModel.delegate = self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HistoryIncomeViewPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HistoryIncomeViewPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRefreshControl];
    [_dataModel doCallGetAllIncome];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (IH_FREE) {
        iHAppDelegate *appD = [iHAppDelegate getSharedAppDelegate];
        [appD showAds];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (IH_FREE) {
        iHAppDelegate *appD = [iHAppDelegate getSharedAppDelegate];
        [appD hideAds];
    }
}

- (void)refreshTableView
{
    [self.indicator stopAnimating];
    [self.tableView reloadData];
}

- (void)serviceCallFailed
{
    //error message show
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoLoginViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LPLoginViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;
    }
    
    return _dataModel.incomeSortedDate.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (0 == indexPath.section) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"totalCell" forIndexPath:indexPath];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f", _dataModel.totalIncome.floatValue];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSString *datekey = [_dataModel.incomeSortedDate objectAtIndex:indexPath.row];
        NSString *income = [NSString stringWithFormat:@"%.02f", [[_dataModel.incomesDic objectForKey:datekey] floatValue]];
        cell.textLabel.text = income;
        cell.detailTextLabel.text = datekey;
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Private Methods
- (void)refreshViewControlEventValueChanged
{
    iHDINFO(@"-- refreshViewControlEventValueChanged");
    
}

- (void)setupRefreshControl
{
//    self.refreshControl = [[UIRefreshControl alloc]init];
//    self.refreshControl.tintColor = [UIColor blueColor];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉加载更多"];
//    [self.refreshControl addTarget:self action:@selector(refreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}

@end
