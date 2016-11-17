//
//  iHAnalyseDetailViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHAnalyseDetailViewController.h"
#import "MobClick.h"

@interface iHAnalyseDetailViewController (){
    NSString *_htmlStr;
}
- (void)setupHtmlStr;
@end

@implementation iHAnalyseDetailViewController

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
    [MobClick beginLogPageView:@"AnalyseDetailView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AnalyseDetailView"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupHtmlStr];
    [self.webView loadHTMLString:_htmlStr baseURL:nil];
}

- (void)setupHtmlStr {
    _htmlStr = @"<html><head><title>收支详情</title></head><body style='font-size:12px;'>";
    for (int i = 0; i < self.deatilsArr.count; i++) {
        NSDictionary *field = [self.deatilsArr objectAtIndex:i];
        
        _htmlStr = [_htmlStr stringByAppendingString:[NSString stringWithFormat:@"<li>%@</li>", field[@"text"]]];
    }
    _htmlStr = [_htmlStr stringByAppendingString:@"</body></html>"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
