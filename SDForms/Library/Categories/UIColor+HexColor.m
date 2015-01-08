//
//  UIColor+HexColor.m
//  SDForms
//
//  Created by Rafał Kwiatkowski on 27.08.2013.
//  Copyright (c) 2013 Trail.pl. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)


+ (UIColor*) colorWithHex:(NSString*)hexColor
{
    unsigned int result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexColor];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&result];
    int r, g, b, a;
    if(hexColor.length == 7) {
        r = (result >> 16) & 0xFF;
        g = (result >> 8) & 0xFF;
        b = result & 0xFF;
        return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
    }
    else if(hexColor.length == 9) {
        r = (result >> 24) & 0xFF;
        g = (result >> 16) & 0xFF;
        b = (result >> 8) & 0xFF;
        a = result & 0xFF;
        return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:(float)a/255.0];
    }
    return nil;
}

@end
