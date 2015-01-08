//
//  SDTextField.h
//  SDForms
//
//  Created by Radoslaw Szeja on 05.02.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SDTextFieldTypeTime = 0,
    SDTextFieldTypeShortTime,
    SDTextFieldTypeNumber,
    SDTextFieldTypeDecimal,
    SDTextFieldTypeTemperature,
    SDTextFieldTypeOther
} SDTextFieldType;

typedef enum {
    SDAnimationDirectionUp = 0,
    SDAnimationDirectionRight,
    SDAnimationDirectionDown,
    SDAnimationDirectionLeft
} SDAnimationDirection;

static NSString * const kDegreeSign = @"\u00B0";

typedef void(^CompletionBlock)(BOOL finished);

@class SDTrainingInputTextField;
@class SDTextField;

@protocol SDTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)textDidChangeInTextField:(SDTextField *)textField;

@end

@interface SDTextField : UITextField

/*! Defines SDTextFieldType of the SDTrainingInputTextField.
 */
@property (nonatomic) SDTextFieldType type;
@property (nonatomic, weak) id<SDTextFieldDelegate> delegate;

@property (nonatomic, strong) UIColor *disabledTextColor;
@property (nonatomic, strong) UIColor *enabledTextColor;

@property (nonatomic, strong) NSNumber *minNumberValue;
@property (nonatomic, strong) NSNumber *maxNumberValue;

- (NSNumber *)numberOfSeconds;
- (void)performBasicShake;
- (void)markWrongValue;
- (void)markCorrectValue;
@end
