//
//  JFeedbackViewController.m
//  Journey
//
//  Created by Wayde Sun on 7/2/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "JFeedbackViewController.h"
#import "iHArithmeticKit.h"
#import "iHFeedbackModel.h"

#import "MobClick.h"

#define TEXT_VIEW_DEFAULT_COLOR     RGBACOLOR(187, 187, 187, 1)

@interface JFeedbackViewController (){
    iHFeedbackModel *_dm;
}
- (void)sureBtnClicked;
- (void)restoreTextView;
@end

@implementation JFeedbackViewController

- (void)awakeFromNib
{
    _dm = [[iHFeedbackModel alloc] init];
    _dm.delegate = self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"feedback");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self restoreTextView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"FeedbackViewPage"];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureFeedBtnClicked:)];
    //self.navigationController.navigationItem.title = @"反馈信息";
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.title = @"反馈信息";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FeedbackViewPage"];
    
   // self.navigationController.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTheTextView:nil];
    [self setLengthLabel:nil];
    [super viewDidUnload];
}

#pragma mark UItextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    NSUInteger strLength = [iHArithmeticKit lengthOfComplexStr:textView.text];
    NSUInteger numOfHanzi = (strLength - textView.text.length)/2;
    self.lengthLabel.text = [NSString stringWithFormat:@"%d/500",(textView.text.length + numOfHanzi)];
    if ((textView.text.length + numOfHanzi) > 500) {
//        textView.text = [textView.text substringToIndex:[textView.text length] - 1];
        self.lengthLabel.textColor = [UIColor redColor];
    }else{
        self.lengthLabel.textColor = RGBACOLOR(68, 30, 12, 1);
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (0 == textView.text.length) {
        [self restoreTextView];
    }
}

- (void)onFeedbackSuccess
{
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"反馈成功！";
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
            [_theTextView resignFirstResponder];
            [self restoreTextView];
        }];
    }];
}

- (void)onFeedbackFailure
{
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"反馈失败，请重新提交！";
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
        }];
    }];
}

#pragma mark - Private Methods
- (IBAction)sureFeedBtnClicked:(id)sender
{
    [self sureBtnClicked];
}

- (void)sureBtnClicked {
    if ([_lengthLabel.text isEqualToString:@"0/500"]) {
        [self showAlertMessage:@"反馈内容不能为空"];
        return;
    }
    [_dm doCallFeedbackService:_theTextView.text];
    
    [MobClick event:@"feedback" label:@"feedback"];
}

- (IBAction)onBgClicked:(id)sender {
    [_theTextView resignFirstResponder];
}

- (void)restoreTextView {
    self.theTextView.text = @"请向我们反馈您使用过程中遇到的问题，或者是您所关注的基金编号，我们会尽最大努力为您整理信息，交将该基金入库。一经采纳或采用，我们将赠送收费免广告版本激活码，请留下您的有效联系邮箱，谢谢！";
    self.theTextView.textColor = TEXT_VIEW_DEFAULT_COLOR;
}
@end
