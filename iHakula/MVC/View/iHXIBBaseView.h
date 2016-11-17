//
//  iHXIBBaseView.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iHXIBBaseView : UIView {
    NSDictionary *dic;
}

@property (nonatomic, strong) NSDictionary *dic;

+ (id)viewFromNib: (NSDictionary *)dataDic;
+ (id)viewFromNib;

@end
