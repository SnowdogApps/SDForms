//
//  SDMultilineTextFormField.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 26.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"

@interface SDMultilineTextField : SDFormField

@property (nonatomic) BOOL editable;
@property (nonatomic) BOOL selectable;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) CGFloat textViewHeight;
@property (nonatomic) BOOL automaticHeight;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic) BOOL placeholderVisible;
@property (nonatomic) UIDataDetectorTypes dataDetectorTypes;

@end
