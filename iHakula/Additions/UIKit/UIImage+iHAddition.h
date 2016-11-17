//
//  UIImage+iHAddition.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (iHAddition)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)scaleAndRotateToMaxResolution:(int)maxResolution;
+ (UIImage *)combineTwoImgsIntoOne:(CGSize)newImgSize
                      firstImgRect:(CGRect)frect
                     secondImgRect:(CGRect)srect
                      firstImgName:(NSString *)fname
                     secondImgName:(NSString *)sname;
+ (UIImage *)combineTwoImgsIntoOneSecondWay:(CGSize)newImgSize
                               firstImgRect:(CGRect)frect
                              secondImgRect:(CGRect)srect
                                   firstImg:(UIImage *)fimg
                                  secondImg:(UIImage *)simg;
+ (UIImage*)textImageWithString:(NSString*)text font:(UIFont*)font;
@end
