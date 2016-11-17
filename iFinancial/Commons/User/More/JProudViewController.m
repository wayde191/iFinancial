//
//  JProudViewController.m
//  Journey
//
//  Created by Bean on 13-8-13.
//  Copyright (c) 2013年 iHakula. All rights reserved.
//

#import "JProudViewController.h"
#import "JProudDetailViewController.h"
#import "CustomerBarButtonItem.h"

@interface JProudViewController ()

@end

@implementation JProudViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我们的骄傲";
        _dm = [[JProudModel alloc] init];
        _dm.servicesArr=[NSArray array];
        _dm.delegate=self;
        [_dm doCallGetProudService];
        UIBarButtonItem *leftDoneBtn = [CustomerBarButtonItem createGoBackItemWithTitle:@"设置"];
        leftDoneBtn.target = self;
        leftDoneBtn.action = @selector(leftBarBtnClicked);
        self.navigationItem.leftBarButtonItem = leftDoneBtn;
        
        
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        float k =self.view.frame.size.width/2-activity.frame.size.width/2;
        float j =self.view.frame.size.height/2-3*activity.frame.size.height;
        activity.left = k;
        activity.top = j;
        if (!IH_IS_IPHONE) {
            activity.frame = CGRectMake(k+55, j+100,50, 50);
        }

        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [self.view addSubview:activity];
        [activity startAnimating];
        _theTableView.hidden = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _theTableView.delegate=self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setProud
{
    [_theTableView reloadData];
    [activity stopAnimating];
    _theTableView.hidden = NO;

}
- (void)leftBarBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView delegate & datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!IH_IS_IPHONE) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        if (_delegate && [_delegate respondsToSelector:@selector(showProud:)]) {
//           
//            [_delegate performSelector:@selector(showProud:) withObject:[_dm.servicesArr objectAtIndex:indexPath.row]];
//        }
//        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!IH_IS_IPHONE) {
        JProudDetailViewController *vc=[[JProudDetailViewController alloc]initWithNibName:@"JProudViewController_ipad" bundle:nil];
        vc.dic = [_dm.servicesArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    JProudDetailViewController *vc=[[JProudDetailViewController alloc]initWithNibName:@"JProudDetailViewController" bundle:nil];
    vc.dic = [_dm.servicesArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dm.servicesArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProudCell";
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[JProudCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    NSDictionary *service = [_dm.servicesArr objectAtIndex:indexPath.row];
    [(JProudCell *)cell setValues:service];
    
    return cell;
}
@end
