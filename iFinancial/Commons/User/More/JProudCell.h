//
//  JProudCell.h
//  Journey
//
//  Created by Bean on 13-8-14.
//  Copyright (c) 2013年 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JProudCellView.h"
@interface JProudCell : UITableViewCell
{
    JProudCellView *_cellView;


}
- (void)setValues:(NSDictionary *)keyedValues;
@end
