//
//  iHImageSlideView.h
//  Journey
//
//  Created by Wayde Sun on 6/28/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iHImageView.h"

@protocol ImageSliderViewDelegate <NSObject>
@optional
- (void)imageClickedWithIndex:(int)imageIndex;
- (void)imageDidEndDeceleratingWithIndex:(int)imageIndex;
@end

@interface iHImageSlideView : UIView <UIScrollViewDelegate,iHImageViewDelegate> {
    id<ImageSliderViewDelegate> __weak _delegate;
    UIScrollView *_scrollView;
    NSArray *_imageUrls;           //image urls
    NSMutableSet *_recycledPages;
    NSMutableSet *_visiblePages;
	
    // Those value are stored before we start to rotation
    // so we adjust our content offset appropriately during rotation
    int           firstVisiblePageIndexBeforeRotation;
    CGFloat       percentScrolledIntoFirstVisiblePage;
}

@property (nonatomic, weak)id<ImageSliderViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)setImageUrls:(NSArray*)imagesUrls;
- (void)updateFrame;

@end
