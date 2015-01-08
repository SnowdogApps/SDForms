//
//  UIImage+Colorize.h
//  SDForms
//
//  Created by Radoslaw Szeja on 17.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Colorize)

/**
 * @description Changing the color of given image. Image needs to have alpha channel.
 */
+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color;
@end
