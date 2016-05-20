//
//  BVRatingStarsField.h
//  SDForms
//
//  Created by Tim Kelly on 5/20/16.
//  Copyright © 2016 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"

@interface BVRatingStarsField : SDFormField

@property CGFloat maximumValue;
@property CGFloat minimumValue;
@property UIColor *starsColor;
@property (nonatomic) NSNumber *value;

@end
