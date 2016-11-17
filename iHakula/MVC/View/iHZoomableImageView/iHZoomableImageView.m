//
//  iHZoomableImageView.m
//  iHakula
//
//  Created by Wayde Sun on 7/2/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHZoomableImageView.h"
#import "iHValidationKit.h"
#import "iHSingletonCloud.h"

@interface iHZoomableImageView ()
- (void)initObjects;
- (void)computationContentSize;
- (CGPoint)getChengedPoint:(CGPoint)touchPoint;
@end

@implementation iHZoomableImageView

@synthesize tapDelegate = _tapDelegate;

- (void)initObjects
{
    _canClickScale = YES;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;
    
    UIView *bkView = [[UIView alloc] initWithFrame:self.bounds];
    bkView.backgroundColor = [UIColor blackColor];
    bkView.alpha = 0.6;
    [self addSubview:bkView];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight
    | UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:_imageView];
}

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self initObjects];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initObjects];
}


#pragma mark - Override layoutSubviews to center content

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width){
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }else{
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height){
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }else{
        frameToCenter.origin.y = 0;
    }
    
    _imageView.frame = frameToCenter;
}

#pragma mark - UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

#pragma mark - Configure scrollView to display new image
- (void)displayImage:(NSString *)imageURL{
    
    if ([iHValidationKit isValueEmpty:imageURL]) {
        iHLog *theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        [theLog pushLog:@"iHZoomableImageView:displayImage" message:@"the image url string is empty" type:iH_LOGS_EXCEPTION file:nil function:nil line:0];
        return;
    }
    
    _imageView.image = nil;
    _imgUrlStr = imageURL;
    
    iHCacheCenter *ccenter = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHCacheCenter"];
    UIImage *img = [ccenter getImgFromUrlStr:_imgUrlStr byDelegate:self];
    
    if (img) {
        [_imageView setImage:img];
    }else{
        activityIndicatorView.frame = CGRectMake(150, 230, 20, 20);
        [self addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(isThereAnImage:)]) {
            [_tapDelegate isThereAnImage:NO];
        }
    }
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setupImage:(UIImage *)image{
    UIImage *img = image;
    [_imageView setImage:img];
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)cancelImageRequest{
    //[_imageView cancelImageRequest];
}
- (UIImage *)image{
    return _imageView.image;
}
#pragma mark - Methods called during rotation to preserve the zoomScale and the visible portion of the image

// returns the center point, in image coordinate space, to try to restore after rotation.
- (CGPoint)pointToCenterAfterRotation{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:_imageView];
}

- (void)setMaxMinZoomScalesForCurrentBounds{
    if (self.bounds.size.width == 320) {
        // is landscape
        self.maximumZoomScale = 3;
        self.minimumZoomScale = 1;
    }else{
        self.maximumZoomScale = 2;
        self.minimumZoomScale = 1;
    }
    /*
     CGSize boundsSize = self.bounds.size;
     CGSize imageSize = _imageView.bounds.size;
     
     // calculate min/max zoomscale
     CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
     CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
     CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
     
     CGFloat maxScale = 1.0f;
     
     // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
     if (minScale > maxScale) {
     minScale = maxScale;
     _canClickScale = NO;
     }else{
     _canClickScale = YES;
     }
     
     //force it can zoom scale;
     if (minScale == maxScale) {
     maxScale = 1.5 * maxScale;
     }
     
     self.maximumZoomScale = maxScale;
     self.minimumZoomScale = minScale;
     */
}
// returns the zoom scale to attempt to restore after rotation.
- (CGFloat)scaleToRestoreAfterRotation{
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON){
        contentScale = 0;
    }
    return contentScale;
}

- (CGPoint)maximumContentOffset{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale{
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:_imageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}
#pragma mark - handle double tap and single tap

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    NSUInteger tapCount = [touch tapCount];
    switch (tapCount) {
        case 1:
            [self performSelector:@selector(singleTapBegan:) withObject:[NSArray arrayWithObjects:touches, event,nil] afterDelay:.3];
            break;
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            break;
        default:
            break;
    }
}

- (void)singleTapBegan:(NSArray *)sender{
    [[self nextResponder] touchesBegan:[sender objectAtIndex:0] withEvent:[sender objectAtIndex:1]];
}

-(void)singleTapEnd:(NSArray *)sender{
    [[self nextResponder] touchesEnded:[sender objectAtIndex:0] withEvent:[sender objectAtIndex:1]];
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(ihimageZoomableViewSingleTapped:) ]) {
        [_tapDelegate ihimageZoomableViewSingleTapped:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    NSUInteger tapCount = [touch tapCount];
    if(tapCount == 2){
        [NSObject cancelPreviousPerformRequestsWithTarget:self]; // Cancel previous perform selector
        if (self.zoomScale != self.minimumZoomScale) {
            CGFloat scaleTime = (self.zoomScale - self.minimumZoomScale)/self.zoomScale/2;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:scaleTime];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.zoomScale = self.minimumZoomScale;
            
            [UIView commitAnimations];
        }else{
            if (!_canClickScale) {
                return;
            }
            UITouch *touch = [touches anyObject];
            CGPoint centerPoint = [touch locationInView:self];
            CGPoint origin = self.contentOffset;
            centerPoint = CGPointMake(centerPoint.x - origin.x, centerPoint.y - origin.y);
            
            [self setZoomScale:self.maximumZoomScale animated:YES];
            [self computationContentSize];
            [self setContentOffset:[self getChengedPoint:centerPoint] animated:YES];
        }
    }else if(tapCount == 1){
        [self performSelector:@selector(singleTapEnd:) withObject:[NSArray arrayWithObjects:touches, event,nil] afterDelay:.3];
    }
}

- (void)computationContentSize{
    float imgWidth = _imageView.image.size.width;
    float imgHeight = _imageView.image.size.height;
    if (imgWidth-320 > imgHeight-480) {
        _imageView.frame = CGRectMake(0, 0,MAX(self.contentSize.width, 320), MAX(imgHeight*self.contentSize.width/imgWidth, 480));
    }else{
        _imageView.frame = CGRectMake(0, 0,MAX(self.contentSize.height/imgHeight*imgWidth, 320),MAX(self.contentSize.height, 480));
    }
    self.contentSize = _imageView.frame.size;
}

- (CGPoint)getChengedPoint:(CGPoint)touchPoint{
    float x = 0;
    float y = 0;
    if (_imageView.image.size.width-320>_imageView.image.size.height-480) {
        float imgBoundsHeight = _imageView.image.size.height*320/_imageView.image.size.width;
        x = touchPoint.x*2;
        y = (touchPoint.y - (240 - imgBoundsHeight/2));
    }else{
        float imgBoundsWidth = _imageView.image.size.width*480/_imageView.image.size.height;
        x = touchPoint.x-(160-imgBoundsWidth/2);
        y = touchPoint.y*2;
    }
    x = MAX(0, x);
    y = MAX(0, y);
    x = MIN(self.contentSize.width-320, x);
    y = MIN(self.contentSize.height-480, y);
    return CGPointMake(x, y);
}

#pragma mark - ITTCacheDelegate
- (void)imgLoaded:(UIImage *)img byUrl:(NSString *)urlStr
{
    [activityIndicatorView stopAnimating];
    [_imageView setImage:img];
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(isThereAnImage:)]) {
        [_tapDelegate isThereAnImage:YES];
    }
}


@end
