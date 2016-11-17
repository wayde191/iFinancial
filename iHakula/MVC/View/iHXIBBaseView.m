//
//  iHXIBBaseView.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHXIBBaseView.h"

@implementation iHXIBBaseView
@synthesize dic;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)viewFromNib
{
    NSString *viewNibName = NSStringFromClass([self class]);
    id view = [[[NSBundle mainBundle] loadNibNamed:viewNibName owner:self options:nil] objectAtIndex:0];
    
    return view;
}

+ (id)viewFromNib:(NSDictionary *)dataDic
{
    NSString *viewNibName = NSStringFromClass([self class]);
    id view = [[[NSBundle mainBundle] loadNibNamed:viewNibName owner:self options:nil] objectAtIndex:0];
    
    if ([view isKindOfClass:[iHXIBBaseView class]] && dataDic) {
        [(iHXIBBaseView *)view setDic:dataDic];
    }
    
    return view;
}


@end
