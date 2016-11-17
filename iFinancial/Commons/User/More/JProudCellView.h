//
//  JProudCellView.h
//  Journey
//
//  Created by Bean on 13-8-13.
//  Copyright (c) 2013年 iHakula. All rights reserved.
//

#import "FBaseView.h"

@interface JProudCellView : FBaseView

@property(nonatomic,weak)IBOutlet UILabel *titleLabel;
@property(nonatomic,weak)IBOutlet UILabel *descriptionLabel;
@property(nonatomic,weak)IBOutlet UIImageView *iconImageView;
@property(nonatomic,weak)IBOutlet UILabel *priceLabel;
@end
