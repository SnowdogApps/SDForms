//
//  SDStarRatingView.m
//  SDForms
//
//  Created by Radoslaw Szeja on 27.02.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDStarRatingView.h"
#import "UIImage+Colorize.h"
#import "UIColor+HexColor.h"

@implementation SDStarRatingView

#pragma UITouch methods

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self validateTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self validateTouches:touches];
}

- (void)validateTouches:(NSSet *)touches
{
    NSInteger index = -1;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    for (UIImageView *starImageView in self.starsCollection) {
        if (CGRectContainsPoint(starImageView.frame, location)) {
            index = [self.starsCollection indexOfObject:starImageView];
        }
    }
    
    if (index > -1) {
        self.numberOfFullStars = [NSNumber numberWithInteger:index+1];
    }
}

#pragma mark - Setup

- (void)setupView
{
    for (UIImageView *starImageView in self.starsCollection) {
        NSInteger index = [self.starsCollection indexOfObject:starImageView];
        UIImage *starImage = [UIImage imageNamed:@"icn_star_empty"];
        
        if (index < [self.numberOfFullStars integerValue]) {
            starImage = [UIImage imageNamed:@"icn_star_full"];
        }
        
        if (NO == self.active) {
            starImage = [UIImage colorizeImage:starImage withColor:[UIColor colorWithHex:@"#DFDFDF"]];
        }
        
        [starImageView setImage:starImage];
    }
}

#pragma mark - Getters

- (NSNumber *)numberOfFullStars
{
    if (_numberOfFullStars == nil) {
        _numberOfFullStars = @3;
    }
    
    return _numberOfFullStars;
}

#pragma mark - Setters

- (void)setNumberOfFullStars:(NSNumber *)numberOfFullStars
{
    if (_numberOfFullStars != numberOfFullStars) {
        _numberOfFullStars = numberOfFullStars;
        
        if ([self.delegate respondsToSelector:@selector(starRatingView:didChangeSelectionToStars:)]) {
            [self.delegate starRatingView:self didChangeSelectionToStars:_numberOfFullStars];
        }

        [self setupView];
    }
}

- (void)setActive:(BOOL)active
{
    _active = active;
    [self setupView];
}

@synthesize numberOfFullStars = _numberOfFullStars;

@end
