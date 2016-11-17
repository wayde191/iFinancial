//
//  iHZoomableImageViewProtocol.h
//  iHakula
//
//  Created by Wayde Sun on 7/2/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@class iHZoomableImageView;
@protocol iHZoomableImageViewProtocol <NSObject>
@optional
- (void)ihimageZoomableViewSingleTapped:(iHZoomableImageView*)imageZoomableView;
- (void)isThereAnImage:(BOOL)isThere;
@end
