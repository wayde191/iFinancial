//
//  UIImage+iHAddition.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "UIImage+iHAddition.h"
#import "iHSingletonCloud.h"
#import "iHLog.h"

@implementation UIImage (iHAddition)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaleAndRotateToMaxResolution:(int)maxResolution{
	int kMaxResolution = maxResolution; // Or whatever
	
	CGImageRef imgRef = self.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = self.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

//Add two image into one, the second one is on the top
+ (UIImage *)combineTwoImgsIntoOne:(CGSize)newImgSize
                      firstImgRect:(CGRect)frect
                     secondImgRect:(CGRect)srect
                      firstImgName:(NSString *)fname
                     secondImgName:(NSString *)sname
{
    if (!fname || !sname) {
        iHLog *log = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        [log pushLog:@"CombineTwoImgsIntoOne"
             message:@"The first image name or the second image name is nil"
                type:iH_LOGS_EXCEPTION
                file:nil function:nil line:0];
        return nil;
    }
    
    UIImage *firstImg = [UIImage imageNamed:fname];
    UIImage *secondimg = [UIImage imageNamed:sname];
    UIGraphicsBeginImageContext(newImgSize);
    [firstImg drawInRect:frect];
    [secondimg drawInRect:srect];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}

+ (UIImage *)combineTwoImgsIntoOneSecondWay:(CGSize)newImgSize
                               firstImgRect:(CGRect)frect
                              secondImgRect:(CGRect)srect
                                   firstImg:(UIImage *)fimg
                                  secondImg:(UIImage *)simg
{
    if (!fimg || !simg) {
        iHLog *log = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        [log pushLog:@"CombineTwoImgsIntoOne"
             message:@"The first image or the second image is nil"
                type:iH_LOGS_EXCEPTION
                file:nil function:nil line:0];
        return nil;
    }
    
    UIGraphicsBeginImageContext(newImgSize);
    [fimg drawInRect:frect];
    [simg drawInRect:srect];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}

+ (UIImage*)textImageWithString:(NSString*)text font:(UIFont*)font
{
    {
        int mw = 256;
        int mh = 32;
        mw*=2;
        mh*=2;
        
        int imgWide;
        int imgHigh;
        
        UIImage* imgGradient;
        
        {
            UIGraphicsBeginImageContext(CGSizeMake(mw, mh));
            
            CGContextRef context=UIGraphicsGetCurrentContext();
            
            CGGradientRef myGradient;
            CGColorSpaceRef myColorSpace;
            size_t locationCount = 3;
            CGFloat locationList[] = {0.0, 0.76, 1.0};
            CGFloat colorList[] = {
                253./256, 253./256, 253./256, 1.0,
                176./256, 176./256, 176./256, 1.0,
                1.0, 1.0, 1.0, 1.0
            };
            
            myColorSpace = CGColorSpaceCreateDeviceRGB();
            myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList,
                                                             locationList, locationCount);
            
            CGPoint startPoint, endPoint;
            startPoint.x = 0;
            startPoint.y = 0;
            endPoint.x = 0;
            endPoint.y = font.pointSize+5;
            CGContextDrawLinearGradient(context, myGradient, startPoint, endPoint,0);
            CGColorSpaceRelease(myColorSpace);
            CGGradientRelease(myGradient);
            
            imgGradient=UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        {
            CGImageRef imgRef;
            
            {
                int bytesPerRow = (mw + 15)&0xfffffff0;
                
                CGColorSpaceRef cSpace = CGColorSpaceCreateDeviceGray();
                CGContextRef context = CGBitmapContextCreate(nil, mw, mh, 8, bytesPerRow, cSpace, kCGBitmapAlphaInfoMask);
                
                CGContextSetRGBFillColor(context, 1, 1, 1, 1);
                CGContextScaleCTM(context, 1, -1);
                CGContextTranslateCTM(context, 0, -mh);
                
                UIGraphicsPushContext(context);
                
                {
                    NSString* s=text;
                
                    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:s];
                    NSRange range = NSMakeRange(0, attrStr.length);
                    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
                    
                    [s drawAtPoint:CGPointMake(1, 0) withAttributes:dic];
                    
                    CGSize textSize=[s sizeWithAttributes:dic];
                    
                    imgWide=textSize.width;
                    imgHigh=textSize.height;
                }
                
                UIGraphicsPopContext();
                
                CFRelease(cSpace);
                
                imgRef = CGBitmapContextCreateImage(context);
                
                CGContextRelease(context);
            }
            
            {
                UIGraphicsBeginImageContext(CGSizeMake(imgWide+10, imgHigh+10));
                CGContextRef context=UIGraphicsGetCurrentContext();
                CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 2, [UIColor blackColor].CGColor);
                
                CGImageRef masked = CGImageCreateWithMask([imgGradient CGImage], imgRef);
                UIImage* img=[UIImage imageWithCGImage:masked];
                
                CGImageRelease(masked);
                CGImageRelease(imgRef);
                
                [img drawAtPoint:CGPointMake(5, 5)];
                
                UIImage* imgText=UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                return imgText;
            }
        }
    }
}

@end
