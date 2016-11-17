//
//  iHMasterViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 2/20/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#define CHART_VIEW_TAG          10

#import "iHMasterViewController.h"
#import "iHValidationKit.h"

#import "iHMasterModel.h"
#import "Fund.h"

#import "LineChartView.h"
#import "iHDetailViewController.h"

#import "MobClick.h"
#import "iHAccountViewController.h"
extern BOOL g_need_refresh;

@interface iHMasterViewController () {
    LineChartView *chartView_;
}

- (void)setupNavBtns;
- (void)drawChart;
- (void)updateFinancial;
- (void)updateNextIncomDay;
- (void)showEmptyBtn;
- (void)hideEmptyBtn;

@end

@implementation iHMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _dataModel = [[iHMasterModel alloc] init];
    _dataModel.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[User sharedInstance] isUserLoggedIn]) {
        [self refreshFunds];
    } else {
        [self gotoLoginViewController];
    }
    
    if (IH_FREE) {
        [appDelegate showAds];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (IH_FREE) {
        [appDelegate hideAds];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HomeViewPage"];
    if (!IH_IS_IPHONE) {
        self.maskIndicator.origin = CGPointMake(self.view.left-10, self.view.top-10);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HomeViewPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavBtns];
    
    if (IH_FREE) {
        self.accountListBtn.hidden = YES;
        self.addBarButtonItem.enabled = NO;
        self.addBarButtonItem.enabled = YES;

    }
    if(!IH_IS_IPHONE)
    {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc]init];
        [btn setTitle:@"+"];
        [btn setAction:@selector(pushToAccount)];
        self.navigationItem.rightBarButtonItem = btn;
     }
}
-(void)pushToAccount
{
    iHAccountViewController *vc = [[iHAccountViewController alloc] initWithNibName:@"iHAccountViewController_ipad" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods
- (void)gotoLoginViewController {
    [super gotoLoginViewController];
}

- (IBAction)onEmptyBtnClicked:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
    
    [MobClick event:@"fund_setting" label:@"fund_setting"];
}

- (IBAction)onMaskCloseBtnClicked:(id)sender {
    [self.view sendSubviewToBack:self.maskView];
    
    [MobClick event:@"ad" label:@"ad"];
}

- (void)updateTodayIncome
{
    [self hideIndicator];
    [User sharedInstance].observedFundsNumberChanged = NO;
    
    [self updateNextIncomDay];
    [self updateFinancial];
    [self drawChart];
    
    [[User sharedInstance] updateRefreshedDay];
    [[User sharedInstance] syncCachedData];
}

- (void)showIndicator
{
    self.maskIndicator.hidden = NO;
    [self.maskIndicator startAnimating];
    [self.view bringSubviewToFront:self.maskView];
    self.maskCloseBtn.hidden = YES;
}

- (void)hideIndicator
{
    self.maskCloseBtn.hidden = NO;
    [self.maskIndicator stopAnimating];
    self.maskIndicator.hidden = YES;
    [self.view sendSubviewToBack:self.maskView];
}

- (void)showRefreshAlert{
    [self hideIndicator];
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"服务器异常，请重试，或重新登录" selectedBlock:^(NSInteger index) {
        [self refreshFunds];
    } cancelButtonTitle:@"刷新" otherButtonTitles:nil];
    [a show];
}

#pragma mark - Private Methods
- (void)refreshFunds
{
    if (![[User sharedInstance] isUserRefreshedDataToday]) {
        [[User sharedInstance] refreshAllFundsOnceADay:^(){
            [self showIndicator];
            [_dataModel doCallServiceGetUserFunds];
        }];
    } else if ([User sharedInstance].observedFundsNumberChanged) {
        [self showIndicator];
        [_dataModel doCallServiceGetUserFunds];
    } else if (g_need_refresh) {
        [self showIndicator];
        [_dataModel doCallServiceGetUserFunds];
        
        g_need_refresh = NO;
    } else {
        [_dataModel setupFunds:[User sharedInstance].observedFundsDic];
        [self updateNextIncomDay];
        [self updateFinancial];
        [self drawChart];
    }
}

- (void)updateNextIncomDay
{
    self.nextIncomDayLabel.text = [_dataModel getNextIncomDate];
}

- (void)updateFinancial
{
    if (![iHValidationKit isValueEmpty:[User sharedInstance].purchasedFundsArr]) {
        [self hideEmptyBtn];
        self.financialLabel.text = [NSString stringWithFormat:@"%.2f", [_dataModel getTodayIncome]];
    } else {
        [self showEmptyBtn];
    }
}

- (void)drawChart
{
    float minDateInterval = [_dataModel.minDate timeIntervalSince1970];
    float maxDateInterval = [_dataModel.maxDate timeIntervalSince1970];
    NSArray *xDatePoints = [_dataModel getDatesIntervalFromMindateToMaxdate];
    
    NSMutableArray *fundsSource = [NSMutableArray array];
    
    NSArray *sortedFundsID = [_dataModel.fundsDic allKeys];
    sortedFundsID = [sortedFundsID sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = NSOrderedSame;
        int f1 = [obj1 integerValue];
        int f2 = [obj2 integerValue];
        
        if (f1 > f2) {
            result = NSOrderedDescending;
        } else {
            result = NSOrderedAscending;
        }
        return result;
    }];
    
    for (NSString *fundID in sortedFundsID) {
        LineChartData *chartDataSource = [LineChartData new];
        NSArray *ratesArray = [_dataModel.fundsDic objectForKey:fundID];
        Fund *f = [[User sharedInstance] getFundById:fundID];
        
        chartDataSource.xMin = minDateInterval;
        chartDataSource.xMax = maxDateInterval;
        NSString *title = f.name;
        if ([f.name isEqualToString:@"天弘"]) {
            title = @"天弘-余额宝";
        } else if ([f.name isEqualToString:@"华夏"]) {
            title = @"华夏-微信理财";
        }
        chartDataSource.title = title;
        chartDataSource.color = f.color;
        chartDataSource.itemCount = ratesArray.count;
        
        chartDataSource.getData = ^(NSUInteger item) {
            float x = [xDatePoints[item] floatValue];
            float y = [ratesArray[item] floatValue];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *label1 = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:x]];
            NSString *label2 = [NSString stringWithFormat:@"%f", y];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
        };
        
        [fundsSource addObject:chartDataSource];
    }
    
    LineChartView *chartView = nil;
    float height = 0.0;
    if (IS_IPHONE_5) {
        height = 335;
    } else {
        height = 335 - (IPHONE_SCREEN_5_HEIGHT - IPHONE_SCREEN_HEIGHT);
    }
    if (IH_FREE) {
        height -= 50;
    }
    chartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 37, 300, height)];
    
    chartView.yMin = [_dataModel getMinIncomeRate];
    chartView.yMax = [_dataModel getMaxIncomeRate];
    float ystep = (chartView.yMax - chartView.yMin) / 5;
    chartView.ySteps = @[[NSString stringWithFormat:@"%f", chartView.yMin],
                         [NSString stringWithFormat:@"%f", chartView.yMin + ystep],
                         [NSString stringWithFormat:@"%f", chartView.yMin + 2 * ystep],
                         [NSString stringWithFormat:@"%f", chartView.yMin + 3 * ystep],
                         [NSString stringWithFormat:@"%f", chartView.yMax]];
    chartView.xStepsCount = 7;
    
    chartView.data = fundsSource;
    chartView.backgroundColor = [UIColor clearColor];
    
    LineChartView *oldChartView = (LineChartView *)[self.chartView viewWithTag:CHART_VIEW_TAG];
    if (oldChartView) {
        [oldChartView removeFromSuperview];
    }
    chartView_ = chartView;
    if(!IH_IS_IPHONE)
    {
        CGRect temp = CGRectMake(chartView.frame.origin.x+30, chartView.frame.origin.y+100, 700, 600);
        chartView.frame = temp;
    }
    chartView.tag = CHART_VIEW_TAG;
    [self.chartView addSubview:chartView];
}

- (void)setupNavBtns
{
}

- (void)showEmptyBtn
{
    self.accountListBtn.hidden = YES;
    self.financialLabel.hidden = YES;
    self.financialTitleLabel.hidden = YES;
    self.nextIncomDayLabel.hidden = YES;
    self.emptyView.hidden = NO;
    self.emptyBtn.hidden = NO;
}

- (void)hideEmptyBtn
{
    if (!IH_FREE) {
        self.accountListBtn.hidden = NO;
    }
    self.financialLabel.hidden = NO;
    self.financialTitleLabel.hidden = NO;
    self.nextIncomDayLabel.hidden = NO;
    self.emptyView.hidden = YES;
    self.emptyBtn.hidden = YES;
}

@end
