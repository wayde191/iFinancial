//
//  iHAnalyseTableViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHAnalyseTableViewController.h"
#import "iHAnalyseModel.h"
#import "LPLoginViewController.h"
#import "iHAnalyseDetailViewController.h"
#import "MobClick.h"

@interface iHAnalyseTableViewController () {
    NSIndexPath *_selectedIndexPath;
}

@end

@implementation iHAnalyseTableViewController

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
    [MobClick beginLogPageView:@"AnalyseTableView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AnalyseTableView"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataModel = [[iHAnalyseModel alloc] init];
    _dataModel.delegate = self;
    
    self.title = self.year;
    [_dataModel doCallServiceGetAnalyseForYear:self.year];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (void)showMessage:(NSString *)msg {
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = msg;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
        }];
    }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataModel getMonthCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSArray *objArr = [_dataModel getTextForRow:indexPath.row];
    cell.textLabel.text = objArr[0];
    cell.detailTextLabel.text = objArr[1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    iHAnalyseDetailViewController* view = (iHAnalyseDetailViewController *)segue.destinationViewController;
    if ([view respondsToSelector:@selector(setDeatilsArr:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSArray *details = [_dataModel getDetailsForSelectedIndexPath:indexPath];
        [view setDeatilsArr:details];
    }
}

@end
