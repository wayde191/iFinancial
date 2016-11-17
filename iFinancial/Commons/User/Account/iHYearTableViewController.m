//
//  iHYearTableViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHYearTableViewController.h"
#import "iHYearModel.h"
#import "LPLoginViewController.h"
#import "iHAnalyseTableViewController.h"
#import "MobClick.h"

@interface iHYearTableViewController (){
    NSString *_selectedYear;
}

@end

@implementation iHYearTableViewController

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
    [MobClick beginLogPageView:@"YearTableView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"YearTableView"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataModel = [[iHYearModel alloc] init];
    _dataModel.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[User sharedInstance] isUserLoggedIn]) {
        [_dataModel doCallServiceGetAnalyseYear];
    } else {
        [self gotoLoginViewController];
    }
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
    return _dataModel.yearsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", [[_dataModel.yearsArr objectAtIndex:indexPath.row] integerValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    iHAnalyseTableViewController* view = (iHAnalyseTableViewController *)segue.destinationViewController;
    if ([view respondsToSelector:@selector(setYear:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        _selectedYear = [NSString stringWithFormat:@"%d", [[_dataModel.yearsArr objectAtIndex:indexPath.row] integerValue]];
        [view setYear:_selectedYear];
    }
}


@end
