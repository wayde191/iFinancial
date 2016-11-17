//
//  CustomerBarButtonItem.m
//  UnderCover
//
//  Created by Wayde Sun on 7/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "CustomerBarButtonItem.h"

@implementation CustomerBarButtonItem

+ (UIBarButtonItem *)createRectBarButtonItemWithImageUrl:(NSString *)url target:(id)delegate action:(SEL)action {
    UIImage *choosePlayerBg = ImageNamed(url);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:choosePlayerBg forState:UIControlStateNormal];
    btn.width = 50;
    btn.height = 32;
    [btn addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftDoneBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    return leftDoneBtn;
}

+ (UIBarButtonItem *)createRectBarButtonItemWithTitle:(NSString *)title {
    UIBarButtonItem *leftDoneBtn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftDoneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         RGBCOLOR(89, 89, 89), UITextAttributeTextColor,
                                         [UIColor whiteColor], UITextAttributeTextShadowColor,
                                         [NSValue valueWithUIOffset:UIOffsetMake(1.0f, 0.5f)], UITextAttributeTextShadowOffset,
                                         nil] forState:UIControlStateNormal];
    [leftDoneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor whiteColor], UITextAttributeTextColor,
                                         RGBCOLOR(89, 89, 89), UITextAttributeTextShadowColor,
                                         [NSValue valueWithUIOffset:UIOffsetMake(1.0f, 0.5f)], UITextAttributeTextShadowOffset,
                                         nil] forState:UIControlStateHighlighted];
    
    UIImage *choosePlayerBg = ImageNamed(@"BarButtonItem_Normal.png");
    choosePlayerBg = [choosePlayerBg stretchableImageWithLeftCapWidth:8 topCapHeight:0];
    
    UIImage *choosePlayerHighlightedBg = ImageNamed(@"BarButtonItem_Pressed.png");
    choosePlayerHighlightedBg = [choosePlayerHighlightedBg stretchableImageWithLeftCapWidth:8 topCapHeight:0];
    
    [leftDoneBtn setBackgroundImage:choosePlayerBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [leftDoneBtn setBackgroundImage:choosePlayerHighlightedBg forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    return leftDoneBtn;
}

+ (UIBarButtonItem *)createGoBackItemWithTitle:(NSString *)title {
    UIBarButtonItem *leftDoneBtn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
//    [leftDoneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                         RGBCOLOR(89, 89, 89), UITextAttributeTextColor,
//                                         [UIColor whiteColor], UITextAttributeTextShadowColor,
//                                         [NSValue valueWithUIOffset:UIOffsetMake(1.0f, 0.5f)], UITextAttributeTextShadowOffset,
//                                         nil] forState:UIControlStateNormal];
//    [leftDoneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                         [UIColor whiteColor], UITextAttributeTextColor,
//                                         RGBCOLOR(89, 89, 89), UITextAttributeTextShadowColor,
//                                         [NSValue valueWithUIOffset:UIOffsetMake(1.0f, 0.5f)], UITextAttributeTextShadowOffset,
//                                         nil] forState:UIControlStateHighlighted];
    
//    UIImage *choosePlayerBg = ImageNamed(@"BarButtonItem_Back_Normal.png");
//    choosePlayerBg = [choosePlayerBg stretchableImageWithLeftCapWidth:15 topCapHeight:0];
//    
//    UIImage *choosePlayerHighlightedBg = ImageNamed(@"BarButtonItem_Back_Pressed.png");
//    choosePlayerHighlightedBg = [choosePlayerHighlightedBg stretchableImageWithLeftCapWidth:15 topCapHeight:0];
//    
//    [leftDoneBtn setBackgroundImage:choosePlayerBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [leftDoneBtn setBackgroundImage:choosePlayerHighlightedBg forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [leftDoneBtn setTitlePositionAdjustment:UIOffsetMake(3, 0) forBarMetrics:UIBarMetricsDefault];
    
    return leftDoneBtn;
}
@end
