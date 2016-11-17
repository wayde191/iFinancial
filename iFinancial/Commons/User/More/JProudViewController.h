//
//  JProudViewController.h
//  Journey
//
//  Created by Bean on 13-8-13.
//  Copyright (c) 2013年 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JProudCell.h"
#import "JProudModel.h"
@interface JProudViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    JProudModel *_dm;
    UIActivityIndicatorView *activity;
}
@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (retain, nonatomic) id delegate;

-(void)setProud;
@end
