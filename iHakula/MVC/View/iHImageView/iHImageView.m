//
//  iHImageView.m
//  iHakula
//
//  Created by Wayde Sun on 6/28/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHImageView.h"
#import "iHSingletonCloud.h"

@interface iHImageView()
-(void)showLoading;
-(void)hideLoading;
-(void)handleTapGesture:(UITapGestureRecognizer *)recognizer;
@end

@implementation iHImageView

@synthesize delegate = _delegate;
@synthesize imageUrl = _imageUrl;
@synthesize enableTapEvent = _enableTapEvent;
@synthesize indicatorViewStyle = _indicatorViewStyle;

- (void)dealloc {
    [self cancelImageRequest];
    
    _delegate = nil;
    RELEASE_SAFELY(_indicator);
    RELEASE_SAFELY(_imageUrl);
}

- (id)init{
    self = [super init];
	if (self) {
        self.indicatorViewStyle = UIActivityIndicatorViewStyleGray;
	}
	return self;
}

- (void)setDefaultImage:(UIImage*)defaultImage{
	self.image = defaultImage;
}

- (void)cancelImageRequest{
    iHCacheCenter *ccenter = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHCacheCenter"];
    [ccenter cancelLoadingImgByUrlStr:_imageUrl];
    [self hideLoading];
}

- (void)loadImage:(NSString*)url{
    if( url==nil || [url isEqualToString:@""] ){
        return;
    }
	RELEASE_SAFELY(_imageUrl);
    _imageUrl = url;
    [self cancelImageRequest];
    
    iHCacheCenter *ccenter = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHCacheCenter"];
    UIImage *img = [ccenter getImgFromUrlStr:_imageUrl byDelegate:self];
    if (img) {
        self.image = img;
        [self hideLoading];
    } else {
        BOOL showShowLoading = YES;
        if (self.image) {
            showShowLoading = NO;
        }
        if (showShowLoading) {
            [self showLoading];
        }
    }
    
    if (_enableTapEvent) {
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
}

-(void)setIndicatorViewStyle:(UIActivityIndicatorViewStyle)style{
    _indicatorViewStyle = style;
    [_indicator setActivityIndicatorViewStyle:style];
}

-(void)showLoading{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_indicatorViewStyle];
        _indicator.center = CGRectGetCenter(self.bounds);
        [_indicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    }
    _indicator.hidden = NO;
    if(!_indicator.superview){
        [self addSubview:_indicator];
    }
    [_indicator startAnimating];
}
-(void)hideLoading{
    if (_indicator) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer{
    if (_delegate && [_delegate respondsToSelector:@selector(imageClicked:)]) {
        [_delegate imageClicked:self];
	}
}

#pragma mark - ITTCacheDelegate
- (void)imgLoaded:(UIImage *)img byUrl:(NSString *)urlStr
{
    if ([urlStr isEqualToString:_imageUrl]) {
        self.image = img;
        [self performSelectorOnMainThread:@selector(imageLoaded:) withObject:img waitUntilDone:YES];
    }
}

#pragma mark - ITTImageDataOperationDelegate
- (void)imageLoaded:(UIImage *)image{
    [self hideLoading];
    self.image = image;
	if (_delegate && [_delegate respondsToSelector:@selector(imageLoaded:)]) {
        [_delegate imageLoaded:self];
	}
}

@end
