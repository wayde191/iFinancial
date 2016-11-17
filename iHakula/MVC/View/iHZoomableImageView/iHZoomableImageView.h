//
//  iHZoomableImageView.h
//  iHakula
//
//  Created by Wayde Sun on 7/2/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iHCacheCenter.h"
#import "iHZoomableImageViewProtocol.h"

@interface iHZoomableImageView : UIScrollView <UIScrollViewDelegate, iHCacheDelegate> {
    UIActivityIndicatorView *activityIndicatorView;
    UIImageView *_imageView;
    NSString *_imgUrlStr;
    BOOL _canClickScale;     //if the maxscale equals to minscale, the image can't support click enlarge
    id<iHZoomableImageViewProtocol> _tapDelegate;
}

@property (nonatomic, strong) id<iHZoomableImageViewProtocol> tapDelegate;

- (UIImage *)image;
- (void)displayImage:(NSString *)imageURL;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;
- (void)cancelImageRequest;
- (void)setMaxMinZoomScalesForCurrentBounds;

- (void)setupImage:(UIImage *)image;

@end
