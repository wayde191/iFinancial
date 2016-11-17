//
//  iHImageView.h
//  iHakula
//
//  Created by Wayde Sun on 6/28/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iHCacheCenter.h"

@class iHImageView;
@protocol iHImageViewDelegate <NSObject>
@optional
- (void)imageLoaded:(iHImageView *)imageView;
- (void)imageClicked:(iHImageView *)imageView;
@end

@interface iHImageView : UIImageView <UIGestureRecognizerDelegate, iHCacheDelegate, iHImageViewDelegate>{
  
    id<iHImageViewDelegate> __weak _delegate;
    UIActivityIndicatorView *_indicator;
    UIActivityIndicatorViewStyle _indicatorViewStyle;
    NSString *_imageUrl;
    
    BOOL _enableTapEvent;
}

@property (nonatomic, strong, readonly) NSString *imageUrl;
@property (nonatomic, weak) id<iHImageViewDelegate> delegate;
@property (nonatomic, assign) BOOL enableTapEvent;
@property (nonatomic, assign) UIActivityIndicatorViewStyle indicatorViewStyle;

- (void)loadImage:(NSString*)url;
- (void)setDefaultImage:(UIImage*)defaultImage;
- (void)cancelImageRequest;

@end
