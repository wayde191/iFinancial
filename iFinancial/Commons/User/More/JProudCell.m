//
//  JProudCell.m
//  Journey
//
//  Created by Bean on 13-8-14.
//  Copyright (c) 2013年 iHakula. All rights reserved.
//

#import "JProudCell.h"

@implementation JProudCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cellView = [JProudCellView viewFromNib];
        
        [self.contentView addSubview:_cellView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setValues:(NSDictionary *)keyedValues {
    NSString *title = [keyedValues objectForKey:@"name"];
    NSString *description = [keyedValues objectForKey:@"keywords"];
    NSString *image = [keyedValues objectForKey:@"logo_url"];
    NSString *price = [keyedValues objectForKey:@"price"];
    _cellView.titleLabel.text = title;
    _cellView.descriptionLabel.text = description;
    _cellView.priceLabel.text = price;
    if (![price isEqualToString:@"Free"]) {
        _cellView.priceLabel.textColor=[UIColor greenColor];
    }else
        _cellView.priceLabel.text = @"Free";
    //_cellView.iconImageView.image = ImageNamed(image);
    //更改读取网络图片方法
    NSString *imageStr=[NSString stringWithFormat:@"%@",image];

    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
    
    _cellView.iconImageView.image = [UIImage imageWithData:data];
}



@end
