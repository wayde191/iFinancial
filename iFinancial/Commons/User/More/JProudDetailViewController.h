//
//  JProudDetailViewController.h
//  Journey
//
//  Created by Bean on 13-8-15.
//  Copyright (c) 2013年 iHakula. All rights reserved.
//

#import "FBaseViewController.h"

@interface JProudDetailViewController : FBaseViewController<UIScrollViewDelegate>

@property(retain,nonatomic)NSDictionary *dic;
@property(retain,nonatomic)NSString *andriod_str;
@property(retain,nonatomic)NSString *ios_str;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoicon;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (weak, nonatomic) IBOutlet UIView *qrCodeView;
@property (weak, nonatomic) IBOutlet UIImageView *iosImageView;
@property (weak, nonatomic) IBOutlet UIImageView *andriodImageView;
@property (weak, nonatomic) IBOutlet UIButton *andriodBtn;
@property (weak, nonatomic) IBOutlet UIButton *iosBtn;
@property (weak, nonatomic) IBOutlet UILabel *iosLabel;
@property (weak, nonatomic) IBOutlet UILabel *andriodLabel;

-(IBAction)iosPressed:(id)sender;
-(IBAction)andriodPressed:(id)sender;
-(void)setupDic:(NSDictionary *)dic;

@end
