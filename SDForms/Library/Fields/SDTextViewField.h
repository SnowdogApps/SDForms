//
//  SDTextViewField.h
//  SDForms
//
//  Created by Radoslaw Szeja on 15.09.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"
#import "SDTextViewCell.h"

@interface SDTextViewField : SDFormField

@property (nonatomic) BOOL editable;
@property (nonatomic) BOOL selectable;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;

@end
