//
//  iHImageSlideView.m
//  Journey
//
//  Created by Wayde Sun on 6/28/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHImageSlideView.h"

@interface iHImageSlideView()
- (void)configurePage:(iHImageView *)page forIndex:(NSInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSInteger)index;

- (CGRect)frameForPageAtIndex:(NSInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (void)tilePages;
- (void)clearPages;
- (iHImageView *)dequeueRecycledPageForIndex:(NSInteger)index;
@end

@implementation iHImageSlideView

@synthesize delegate = _delegate;
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _recycledPages = [[NSMutableSet alloc] init];
        _visiblePages  = [[NSMutableSet alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.alpha = 0;
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _recycledPages = [[NSMutableSet alloc] init];
        _visiblePages  = [[NSMutableSet alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.alpha = 0;
    }
    return self;
}

- (void)setImageUrls:(NSArray*)imageUrls{
    [self clearPages];
    RELEASE_SAFELY(_imageUrls);
    _imageUrls = [imageUrls copy];
    _scrollView.alpha = 1;
    _scrollView.contentSize = [self contentSizeForPagingScrollView];
    
    [_scrollView setContentOffset:CGPointZero];
    if ([_delegate respondsToSelector:@selector(imageDidEndDeceleratingWithIndex:)]) {
        [_delegate imageDidEndDeceleratingWithIndex:_scrollView.contentOffset.x/_scrollView.bounds.size.width];
    }
    [self tilePages];
}
- (void)dealloc{
    _delegate = nil;
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_recycledPages);
    RELEASE_SAFELY(_visiblePages);
    RELEASE_SAFELY(_imageUrls);
}


#pragma mark - Tiling and page configuration
- (void)updateFrame {
    [_scrollView setContentSize:[self contentSizeForPagingScrollView]];
    CGFloat offsetX = floorf(_scrollView.contentOffset.x/_scrollView.width)*_scrollView.width;
    [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)tilePages {
	int firstIndex = 0;
	int lastIndex = [_imageUrls count] - 1;
	// Calculate which pages are visible
	CGRect visibleBounds = _scrollView.bounds;
	int currentIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
	currentIndex = MAX(currentIndex,0);
	currentIndex = MIN(currentIndex,[_imageUrls count] + 1);
    
	int previousPageIndex = currentIndex - 2;
	int nextPageIndex = currentIndex + 2;
	
	previousPageIndex = MAX(previousPageIndex,firstIndex);
	nextPageIndex  = MIN(nextPageIndex,lastIndex);
	
    NSMutableArray *visibleIndexes = [NSMutableArray array];
    for (int i = previousPageIndex; i<=nextPageIndex; i++) {
        [visibleIndexes addObject:[NSNumber numberWithInt:i]];
    }
	// Recycle no-longer-visible pages
	for (iHImageView *page in _visiblePages) {
		int indexInImages = [_imageUrls indexOfObject:page.imageUrl];
        if (indexInImages < previousPageIndex || indexInImages > nextPageIndex){
			[_recycledPages addObject:page];
			[page removeFromSuperview];
		}
	}
	[_visiblePages minusSet:_recycledPages];
	
	// add missing pages
	for (int i = 0; i < [visibleIndexes count]; i++) {
		int index = [(NSNumber*)[visibleIndexes objectAtIndex:i] intValue];
		if (![self isDisplayingPageForIndex:index]) {
			iHImageView *page = [self dequeueRecycledPageForIndex:index];
			if (page == nil) {
				page = [[iHImageView alloc] initWithFrame:_scrollView.bounds];
                page.contentMode = UIViewContentModeScaleAspectFit;
                [page setDefaultImage:ImageNamed(@"default_image_news_top.png")];
                page.enableTapEvent = YES;
                page.delegate = self;
			}
			[page setDefaultImage:[UIImage imageNamed:@"default_image_news_top"]];
			[self configurePage:page forIndex:index];
			[_scrollView addSubview:page];
			[_visiblePages addObject:page];
		}
	}
    for (iHImageView *page in _visiblePages) {
        int indexInImages = [_imageUrls indexOfObject:page.imageUrl];
        if (indexInImages!=NSNotFound) {
            [self configurePage:page forIndex:indexInImages];
        }
	}
}

- (void)clearPages{
    for (iHImageView *page in _visiblePages) {
        [_recycledPages addObject:page];
        [page removeFromSuperview];
	}
	[_visiblePages minusSet:_recycledPages];
}

- (iHImageView *)dequeueRecycledPageForIndex:(int)index{
    iHImageView *page = [_recycledPages anyObject];
    if (page) {
        [_recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSInteger)index{
	BOOL foundPage = NO;
	for (iHImageView *page in _visiblePages) {
		int indexInImages = [_imageUrls indexOfObject:page.imageUrl];
		if (indexInImages == index) {
			foundPage = YES;
			break;
		}
	}
	return foundPage;
}

- (void)configurePage:(iHImageView *)page forIndex:(NSInteger)index{
    [page loadImage:[_imageUrls objectAtIndex:index]];
	page.frame = [self frameForPageAtIndex:index];
}


#pragma mark - ScrollView delegate methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([_delegate respondsToSelector:@selector(imageDidEndDeceleratingWithIndex:)]) {
        [_delegate imageDidEndDeceleratingWithIndex:scrollView.contentOffset.x/scrollView.bounds.size.width];
    }
}

#pragma mark - Frame calculations

- (CGRect)frameForPageAtIndex:(NSInteger)index {
	CGRect bounds = _scrollView.bounds;
	CGRect pageFrame = bounds;
	pageFrame.origin.x = (bounds.size.width * index);
	return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
	return CGSizeMake(_scrollView.bounds.size.width * [_imageUrls count] , _scrollView.bounds.size.height);
}

- (void)clearCache{
	[_recycledPages removeAllObjects];
}

#pragma mark - ITTImageView delegate
- (void)imageClicked:(iHImageView *)imageView{
    int indexInImages = [_imageUrls indexOfObject:imageView.imageUrl];
    if (_delegate && [_delegate respondsToSelector:@selector(imageClickedWithIndex:)]) {
        [_delegate imageClickedWithIndex:indexInImages];
    }
}

@end
