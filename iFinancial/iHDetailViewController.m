//
//  iHDetailViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 2/20/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHDetailViewController.h"
#import "iHValidationKit.h"
#import "Fund.h"
#import "LPLoginModel.h"
#import "JFeedbackViewController.h"
#import "JAboutUsViewController.h"
#import "JProudViewController.h"
#import "iHFundsViewController.h"
#import "iHSureGoldViewController.h"
#import "iHAnnualRateViewController.h"

@interface iHDetailViewController (){
    UITableViewCell *_userCell;
    LPLoginModel *_dm;
}

- (void)updateUserInfo;
- (void)gotoFeedbackViewController;
- (void)gotoAboutUSViewController;
- (void)gotoFundsViewController;
- (void)onFiveStarBtnClicked;
- (void)gotoConfirmGoldViewController:(NSIndexPath *)indexPath;
- (void)gotoIncomeHistoryViewController:(NSIndexPath *)indexPath;
- (void)gotoAnnualRateViewController:(NSIndexPath *)indexPath;
@end

@implementation iHDetailViewController
- (void)awakeFromNib
{
    _dm = [[LPLoginModel alloc] init];
    _dm.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0.0;
    if (indexPath.section == 0) {
        cellHeight = 78.00;
    } else if (indexPath.section == 1) {
        cellHeight = 44.00;
        if (!IH_IS_IPHONE) {
            cellHeight = 60.00;
        }
    } else {
        cellHeight = 44.00;
        if (!IH_IS_IPHONE) {
            cellHeight = 60.00;
        }
    }
    
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if (section == 0) {
        row = 1;
    } else if (section == 1) {
        row = [iHValidationKit isValueEmpty:[User sharedInstance].purchasedFundsArr] ? 1 : [User sharedInstance].purchasedFundsArr.count + 1;
    } else {
        row = 4;
    }
    
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        _userCell = cell;
        [self updateUserInfo];
        
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FundDetail" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"总资产";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f¥", [User sharedInstance].getMyTotalAssests];
        } else {
            NSArray *pFundsArr = [User sharedInstance].purchasedFundsArr;
            NSDictionary *fdic = [pFundsArr objectAtIndex:indexPath.row - 1];
            Fund *f = [[User sharedInstance] getFundById: [[fdic allKeys] firstObject]];
            float fmoney = [[[fdic allValues] firstObject] floatValue];
            cell.textLabel.text = f.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f¥", fmoney];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BasicAccess" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"意见反馈";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"赏个好评";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"产品列表";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"关于我们";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (2 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                [self gotoFeedbackViewController];
                break;
            case 1:
                [self onFiveStarBtnClicked];
                break;
            case 2:
                [self gotoOurProuds];
                break;
            case 3:
                [self gotoAboutUSViewController];
                break;
            default:
                
                break;
        }
    } else if (1 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                [self gotoFundsViewController];
                break;
            default:
                [self gotoAnnualRateViewController:indexPath];
                break;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section) {
        if (0 != indexPath.row) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.section) {
        if (0 != indexPath.row) {
            return @"确认金";
        }
    }
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self gotoConfirmGoldViewController:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (IBAction)onLogBtnClicked:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认要退出吗？" selectedBlock:^(NSInteger index){
        if (1 == index) {
            [_dm doCallLogoutService];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
    [alert show];
    
}

#pragma mark - Public Methods
- (void)logoutSuccess
{
    [self updateUserInfo];
}

#pragma mark - Private Methods
- (void)onFiveStarBtnClicked
{
    NSString *appId = nil;
    if (IH_FREE) {
        appId = @"850057760"; // free
    } else {
        appId = @"855131175"; // charge
    }
    
    NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];    
}

- (void)updateUserInfo
{
    UILabel *nameLabel = (UILabel *)[_userCell viewWithTag:1];
    UILabel *emailLabel = (UILabel *)[_userCell viewWithTag:2];
    UIButton *logBtn = (UIButton *)[_userCell viewWithTag:3];
    UIButton *quitBtn = (UIButton *)[_userCell viewWithTag:4];
    
    if ([[User sharedInstance] isUserLoggedIn]) {
        nameLabel.text = [[User sharedInstance] getUserName];
        emailLabel.text = [[User sharedInstance] getUserEmail];
        quitBtn.hidden = NO;
        logBtn.hidden = YES;
    } else {
        nameLabel.text = @"游客";
        emailLabel.text = @"登录后将方便我们为您提供更优质服务";
        quitBtn.hidden = YES;
        logBtn.hidden = NO;
    }
}

- (void)gotoFundsViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"iHFundsViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoFeedbackViewController
{
    
    if (!IH_IS_IPHONE) {
        JFeedbackViewController *vc2 = [[JFeedbackViewController alloc]initWithNibName:@"JFeedbackView" bundle:nil];
        [self.navigationController pushViewController:vc2 animated:YES];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
   
   
}

- (void)gotoAboutUSViewController
{
    if (!IH_IS_IPHONE) {
        JAboutUsViewController *vc1 = [[JAboutUsViewController alloc] initWithNibName:@"AboutUsView" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
        return;
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AboutUSViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoOurProuds
{
    JProudViewController *vc = [[JProudViewController alloc] initWithNibName:@"JProudViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoConfirmGoldViewController:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"iHSureGoldViewController"];
    
    NSArray *pFundsArr = [User sharedInstance].purchasedFundsArr;
    NSDictionary *fdic = [pFundsArr objectAtIndex:indexPath.row - 1];
    NSString *fid = [[fdic allKeys] firstObject];
    [(iHSureGoldViewController *)vc setFundId:fid];
    
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoAnnualRateViewController:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"iHAnnualRateViewController"];
    
    NSArray *pFundsArr = [User sharedInstance].purchasedFundsArr;
    NSDictionary *fdic = [pFundsArr objectAtIndex:indexPath.row - 1];
    NSString *fid = [[fdic allKeys] firstObject];
    [(iHAnnualRateViewController *)vc setFundId:fid];
    
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoIncomeHistoryViewController:(NSIndexPath *)indexPath
{}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
