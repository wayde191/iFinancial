//
//  iHAnnualRateViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 4/4/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHAnnualRateViewController.h"
#import "iHAnnualRateModel.h"
#import "LineChartView.h"
#import "Fund.h"

@interface iHAnnualRateViewController ()
- (void)showServiceMessage;
- (void)hideServiceMessage;
- (void)setFundName;
@end

@implementation iHAnnualRateViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _dataModel = [[iHAnnualRateModel alloc] init];
    _dataModel.delegate = self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (IH_FREE) {
        [appDelegate hideAds];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (IH_FREE) {
        [appDelegate showAds];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFundName];
    [_dataModel doCallGetAnnualRateServiceById:self.fundId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onWatchBtnClicked:(UIBarButtonItem *)sender {
}

- (IBAction)onSegmentClicked:(UISegmentedControl *)sender {
}

- (void)drawChat
{
    [self.indicator stopAnimating];
    [self.chartView removeAllSubviews];
    
    float minDateInterval = [_dataModel.minDate timeIntervalSince1970];
    float maxDateInterval = [_dataModel.maxDate timeIntervalSince1970];
    NSArray *xDatePoints = [_dataModel getDatesIntervalFromMindateToMaxdate];
    
    NSMutableArray *fundsSource = [NSMutableArray array];
    LineChartData *chartDataSource = [LineChartData new];
    
    NSArray *ratesArray = _dataModel.annualRates;
    chartDataSource.xMin = minDateInterval;
    chartDataSource.xMax = maxDateInterval;
    
    chartDataSource.title = @"";
    Fund *f = [[User sharedInstance] getFundById:self.fundId];
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
    
    LineChartView *chartView = nil;
    float height = 0.0;
    if (IS_IPHONE_5) {
        height = self.chartView.height - 80;
        
    } else {
        height = self.chartView.height - (IPHONE_SCREEN_5_HEIGHT - IPHONE_SCREEN_HEIGHT) - 80;
    }
    if (IH_FREE) {
        height -= 50;
    }
    
    chartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 10, 300, height)];
    
    chartView.yMin = [_dataModel getMinIncomeRate];
    chartView.yMax = [_dataModel getMaxIncomeRate];
    float ystep = (chartView.yMax - chartView.yMin) / 5;
    chartView.ySteps = @[[NSString stringWithFormat:@"%f", chartView.yMin],
                         [NSString stringWithFormat:@"%f", chartView.yMin + ystep],
                         [NSString stringWithFormat:@"%f", chartView.yMin + 2 * ystep],
                         [NSString stringWithFormat:@"%f", chartView.yMin + 3 * ystep],
                         [NSString stringWithFormat:@"%f", chartView.yMax]];
    chartView.xStepsCount = 30;
    
    chartView.data = fundsSource;
    chartView.backgroundColor = [UIColor clearColor];
    if (!IH_IS_IPHONE) {
        CGRect temp =    CGRectMake(chartView.origin.x+20, chartView.origin.y+30, 700, chartView.size.height);
        chartView.frame = temp;
    }
    [self.chartView addSubview:chartView];
}

- (void)serviceCallFailed
{
    [self.indicator stopAnimating];
}

#pragma mark - Private Methods
- (void)setFundName
{
    Fund *f = [[User sharedInstance] getFundById:self.fundId];
    NSString *title = f.name;
    if ([f.name isEqualToString:@"天弘"]) {
        title = @"天弘-余额宝";
    } else if ([f.name isEqualToString:@"华夏"]) {
        title = @"华夏-微信理财";
    }
    self.fundNameLabel.text = title;
    self.fundNameLabel.textColor = f.color;
    if (!IH_IS_IPHONE) {
        CGRect temp = CGRectMake(self.fundNameLabel.frame.size.width/2+35, self.fundNameLabel.frame.origin.y, self.fundNameLabel.frame.size.width, self.fundNameLabel.frame.size.height);
        
        self.fundNameLabel.frame = temp;
    }
}

- (void)showServiceMessage
{
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"正在请求数据...";
    } completion:^(BOOL finished){
    }];
}

- (void)hideServiceMessage
{
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"请求成功！";
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
        }];
    }];
}

@end
