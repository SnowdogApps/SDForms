//
//  UIImage+Colorize.m
//  SDForms
//
//  Created by Radoslaw Szeja on 17.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "UIImage+Colorize.h"

@implementation UIImage (Colorize)

+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color
{
    CGImageRef maskImage = image.CGImage;
    CGSize size = image.size;
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGRect bounds = CGRectMake(0,0,width,height);
    
    // Begin context for image of size 'size', with no opaque and adjustable scale factor
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    // Get context
    CGContextRef bitmapContext = UIGraphicsGetCurrentContext();
    
    // Translate image and scale from CG to UI coordinates
    CGContextTranslateCTM(bitmapContext, 0, height);
    CGContextScaleCTM(bitmapContext, 1.0, -1.0);
    
    // Clip to mask, set fill color and fill image accordignly to the mask
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
    CGContextFillRect(bitmapContext, bounds);
    
    // Get image from current image context
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End image context
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

@end
