//
//  iHPageView.h
//  iHakula
//
//  Created by Wayde Sun on 6/28/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PAGE_VIEW_SPACE_BETWEEN_DOTS  6
#define PAGE_VIEW_DOT_WIDTH           6
#define PAGE_VIEW_DOT_HEIGHT          6
#define PAGE_VIEW_SELECTED_DOT_IMAGE  @"dot_sel.png"
#define PAGE_VIEW_DOT_IMAGE           @"dot.png"

@interface iHPageView : UIView {
    int _pageNum;
    int _currentPage;
    UIImageView *_selectedDotView;
}

@property (nonatomic, assign)int pageNum;
@property (nonatomic, assign)int currentPage;

- (id)initWithPageNum:(int)pageNum;
- (void)setInitStateFromNib:(int)pageNum;

@end
