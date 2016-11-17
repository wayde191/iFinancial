//
//  JProudDetailViewController.m
//  Journey
//
//  Created by Bean on 13-8-15.
//  Copyright (c) 2013年 iHakula. All rights reserved.
//

#import "JProudDetailViewController.h"
#import "CustomerBarButtonItem.h"

#import "MobClick.h"

@interface JProudDetailViewController ()

@end

@implementation JProudDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _theScrollView.delegate=self;
        
        UIBarButtonItem *leftDoneBtn = [CustomerBarButtonItem createGoBackItemWithTitle:@"骄傲"];
        leftDoneBtn.target = self;
        leftDoneBtn.action = @selector(leftBarBtnClicked);
        self.navigationItem.leftBarButtonItem = leftDoneBtn;
   
    }
    return self;
}
- (void)leftBarBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupDic:_dic];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ProudDetailViewPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ProudDetailViewPage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupDic:(NSDictionary *)dic
{
    _nameLabel.text = [dic objectForKey:@"description"];
    NSString *image = [dic objectForKey:@"logo_url"];
    NSString *imageStr = [NSString stringWithFormat:@"%@",image];
    NSString *os = [dic objectForKey:@"os"];
    NSString *version = [dic objectForKey:@"version"];
    NSString *qrcode_url = [dic objectForKey:@"qrcode_url"];
    NSString *price = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
    NSString *name = [dic objectForKey:@"name"];
    NSString *download_url = [dic objectForKey:@"download_url"];
    self.navigationItem.title=name;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
    
    _logoicon.image = [UIImage imageWithData:data];
    
    CGSize suggestedSize = [_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(_nameLabel.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    _nameLabel.height=suggestedSize.height;
    _nameLabel.numberOfLines = 0;
    _versionLabel.text = version;
    if ([price isEqualToString:@"Free"]) {
        _priceLabel.text=@"Free";
    }else{
    _priceLabel.text=price;
        _priceLabel.textColor=[UIColor redColor];
    }
    
    
    if ([os isEqualToString:@"iOS,Android"]) {
        NSArray *arr=[qrcode_url componentsSeparatedByString:@","];
        NSString *ios_url = [arr objectAtIndex:0];
        NSString *andriod_url = [arr objectAtIndex:1];
        NSData * data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:ios_url]];
        
        _iosImageView.image = [UIImage imageWithData:data1];
        NSData * data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:andriod_url]];
        
        _andriodImageView.image = [UIImage imageWithData:data2];
        
        NSArray *downArr=[download_url componentsSeparatedByString:@","];
        _ios_str = [NSString stringWithFormat:@"%@",[downArr objectAtIndex:0]];
        _andriod_str = [NSString stringWithFormat:@"%@",[downArr objectAtIndex:1]];
        
        
    }else{
        NSData * data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:qrcode_url]];
        
        _iosImageView.image = [UIImage imageWithData:data1];
        if ([os isEqualToString:@"Andriod"]) {
            [_iosBtn.imageView setImage:[UIImage imageNamed:@"andriod.jpg"]];
        }
    _iosBtn.origin = CGPointMake(160-_iosBtn.frame.size.width/2, _iosBtn.origin.y);
    _iosImageView.origin = CGPointMake(160-_iosImageView.frame.size.width/2, _iosImageView.origin.y);
_iosLabel.origin = CGPointMake(160-_iosLabel.frame.size.width/2, _iosLabel.origin.y);
        if (!IH_IS_IPHONE) {
            _iosBtn.origin = CGPointMake(384-_iosBtn.frame.size.width/2+20, _iosBtn.origin.y);
            _iosImageView.origin = CGPointMake(384-_iosImageView.frame.size.width/2+20, _iosImageView.origin.y);
            _iosLabel.origin = CGPointMake(384-_iosLabel.frame.size.width/2+20, _iosLabel.origin.y);
        }
    _andriodBtn.hidden=YES;
_andriodLabel.hidden=YES;
_andriodImageView.hidden=YES;
        _ios_str = [NSString stringWithFormat:@"%@",download_url];//download_url;
    }
    
    _qrCodeView.origin = CGPointMake(0,_nameLabel.height+_nameLabel.origin.y+20);
    if (!IH_IS_IPHONE) {
        int k = _nameLabel.height+_nameLabel.origin.y+50;
        if (k<400) {
            k=400;
            _qrCodeView.origin = CGPointMake(0,k);
        }else
            _qrCodeView.origin = CGPointMake(0,k+100);
        
    }
    _theScrollView.contentSize=CGSizeMake(self.view.frame.size.width, _qrCodeView.origin.y+_qrCodeView.height+50);
    //_theScrollView.contentSize=CGSizeMake(320, 550);
    _theScrollView.contentOffset=CGPointMake(0, 0);
    [_theScrollView addSubview:_qrCodeView];
    

}
#pragma mark UIScrollViewDelegate

// 触摸屏幕来滚动画面还是其他的方法使得画面滚动，皆触发该函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"Scrolling...");
}

// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging  -  End of Scrolling.");
}

// 滚动停止时，触发该函数

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating  -   End of Scrolling.");
}
-(IBAction)iosPressed:(id)sender{
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_ios_str]];
}

-(IBAction)andriodPressed:(id)sender{
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_andriod_str]];
}
@end
