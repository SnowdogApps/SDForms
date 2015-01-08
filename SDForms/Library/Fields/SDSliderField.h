//
//  SDSliderField.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 26.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"

@interface SDSliderField : SDFormField

@property (nonatomic) float min;
@property (nonatomic) float max;
@property (nonatomic) float step;

@end
