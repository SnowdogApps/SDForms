//
//  SDTextField.m
//  SDForms
//
//  Created by Radoslaw Szeja on 05.02.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDTextFieldView.h"

static CGFloat const kAnimationDuration = 0.04;
static NSString * const kSeparatorForTimeType = @":";
static NSString * const kDefaultTextForTimeType = @"00:00:00";
static NSString * const kDefaultTextForShortTimeType = @"00:00";

@interface SDTextFieldView()
{
    dispatch_once_t onceToken;
    
    NSInteger maxNumberOfDots;
    NSInteger maxNumberOfCharacters;
}
@property (nonatomic, strong) NSString *temperaturePostfix;
@property (readonly, nonatomic) CGRect initialFrame;
@end

@implementation SDTextFieldView

@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTextField];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupTextField];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupTextField];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    dispatch_once(&onceToken, ^{
        _initialFrame = self.frame;
    });
}

/*! Sets up text field
 */
- (void)setupTextField
{
    self.type = SDTextFieldTypeOther;   // by default
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.temperaturePostfix = [NSString stringWithFormat:@"%@%@", kDegreeSign, @"C"];

    self.disabledTextColor = [UIColor lightGrayColor];
    self.enabledTextColor = [UIColor blackColor];
    
    [self addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
}

/*! Action method that should appropriately change text in UITextField according to text field type.
 */
- (void)textFieldDidChange:(SDTextFieldView *)sender
{
    switch (self.type) {
        case SDTextFieldTypeTime:
            [self validateTimeSender:sender];
            break;
        case SDTextFieldTypeShortTime:
            [self validateTimeSender:sender];
            break;
        case SDTextFieldTypeTemperature:
            [self validateTemperatureSender:sender];
            break;
        case SDTextFieldTypeDecimal:
            [self validateDecimalSender:sender];
            break;
        default:
            [self validateSender:sender];
            break;
    }
    [self setTextColor:[UIColor blackColor]];
}

/*! Action method that responds to UIControlEventEditingDidBegin according to text field type.
 */
- (void)textFieldDidBeginEditing:(SDTextFieldView *)sender
{
    if (self.text.length == 0 || [self.text isEqualToString:@"0.00"] || [self.text isEqualToString:@"0"]) {
        switch (self.type) {
            case SDTextFieldTypeTime:
                [self setText:kDefaultTextForTimeType];
                break;
            case SDTextFieldTypeShortTime:
                [self setText:kDefaultTextForShortTimeType];
                break;
            case SDTextFieldTypeOther:
            case SDTextFieldTypeDecimal:
                [self setText:@""];
                break;
            default:
                break;
        }
    }
}

/*! Responds to UIControlEventEditingDidEnd. This method doesn't let to set up zero time.
 */
- (void)textFieldDidEndEditing:(SDTextFieldView *)sender
{
    [self validateNumberSender:sender];
    
    if ([self.text isEqualToString:kDefaultTextForTimeType]) {
        self.text = nil;
    } else if (self.type != SDTextFieldTypeOther && self.text.length == 0) {
        self.text = @"0";
    }
    
    if ([self.delegate respondsToSelector:@selector(textDidChangeInTextField:)]) {
        [self.delegate textDidChangeInTextField:self];
    }
}

#pragma mark - Utils

/*! Changes text in text field of type SDTextFieldTypeDecimal.
 */

- (void)validateTimeSender:(SDTextFieldView *)sender
{
    if (self.text.length < maxNumberOfCharacters && self.text.length > 0) {
        [self clearLastCharacter];
    } else if ([self.text length] > 0) {
        [self setTextForTimeType];
    } else {
        [self textFieldDidBeginEditing:sender];
    }
}

- (void)validateTemperatureSender:(SDTextFieldView *)sender
{
    NSString *text = [self.text stringByReplacingOccurrencesOfString:self.temperaturePostfix withString:@""];
    NSRange range = [text rangeOfString:kDegreeSign];
    
    if (range.location != NSNotFound) {
        text = [text substringToIndex:range.location-1];
    }
    
    if (text.length > 0) {
        text = [text stringByAppendingString:self.temperaturePostfix];
    }
    
    [self setText:text];
}

- (void)validateDecimalSender:(SDTextFieldView *)sender
{ 
    NSInteger length = [sender.text length];
    if (length < maxNumberOfCharacters && length > 0) {
        [self checkForCorrectNumberOfDotsInTextField:sender];
    }
}

- (void)validateNumberSender:(SDTextFieldView *)sender
{
    if (sender.type == SDTextFieldTypeNumber || sender.type == SDTextFieldTypeDecimal) {
        BOOL shouldPerformShake = NO;
        NSString *stringToSet = nil;
        NSNumber *current = [self numberFromString:sender.text];
        
        if (self.minNumberValue.doubleValue > current.doubleValue) {
            stringToSet = self.minNumberValue.stringValue;
            shouldPerformShake = YES;
        }
        
        if (self.maxNumberValue.doubleValue < current.doubleValue) {
            stringToSet = self.maxNumberValue.stringValue;
            shouldPerformShake = YES;
        }
        
        if (shouldPerformShake) {
            [self setTextColor:[UIColor redColor]];
            [self performBasicShake];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [sender setText:stringToSet];
                if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
                    [self.delegate textFieldDidEndEditing:self];
                }
            });
        } else {
            [sender setTextColor:[UIColor blackColor]];
        }
    }
}

- (void)validateSender:(SDTextFieldView *)sender
{
    NSInteger length = [sender.text length];
    if (length < maxNumberOfCharacters && length > 0) {
        [self checkForZeroAsFirstCharInTextField:sender];
        [self checkForCorrectNumberOfDotsInTextField:sender];
    }
}

- (void)checkForZeroAsFirstCharInTextField:(SDTextFieldView *)sender
{
    NSString *firstChar = [sender.text substringToIndex:1];
    if ([firstChar isEqualToString:@"0"]) {
        sender.text = @"";
    }
}

- (void)checkForCorrectNumberOfDotsInTextField:(SDTextFieldView *)sender
{
    NSInteger numberOfDots = [[sender.text componentsSeparatedByString:@"."] count] - 1;
    if (numberOfDots > maxNumberOfDots) {
        // last character is erased
        sender.text = [sender.text substringToIndex:[sender.text length]-1];
    }
}

/*! Changes text in text field of type SDTextFieldTypeTime.
 */
- (void)setTextForTimeType
{
    NSRange firstPart = NSMakeRange(0, 1);
    NSRange secondPart = NSMakeRange(1, 1);
    
    NSString *newNumber = [self.text substringFromIndex:(self.text.length-1)];
    
    NSArray *fragments = [self.text componentsSeparatedByString:kSeparatorForTimeType];
    
    if (self.type == SDTextFieldTypeTime) {
        NSString *hours = [fragments objectAtIndex:0];
        NSString *minutes = [fragments objectAtIndex:1];
        NSString *seconds = [fragments objectAtIndex:2];
        
        hours = [NSString stringWithFormat:@"%@%@", [hours substringWithRange:secondPart], [minutes substringWithRange:firstPart]];
        minutes = [NSString stringWithFormat:@"%@%@", [minutes substringWithRange:secondPart], [seconds substringWithRange:firstPart]];
        seconds = [NSString stringWithFormat:@"%@%@", [seconds substringWithRange:secondPart], newNumber];
        
        self.text = [NSString stringWithFormat:@"%@:%@:%@", hours, minutes, seconds];
   
    } else if (self.type == SDTextFieldTypeShortTime) {
        NSString *minutes = [fragments objectAtIndex:0];
        NSString *seconds = [fragments objectAtIndex:1];
        
        minutes = [NSString stringWithFormat:@"%@%@", [minutes substringWithRange:secondPart], [seconds substringWithRange:firstPart]];
        seconds = [NSString stringWithFormat:@"%@%@", [seconds substringWithRange:secondPart], newNumber];
        
        self.text = [NSString stringWithFormat:@"%@:%@", minutes, seconds];
    }
}

/*! Erases last character and moving all string right by one character, adds 0 at the beginning.
 */
- (void)clearLastCharacter
{
    NSRange firstPart = NSMakeRange(0, 1);
    NSRange secondPart = NSMakeRange(1, 1);
    
    NSString *newNumber = @"0";
    NSArray *fragments = [self.text componentsSeparatedByString:kSeparatorForTimeType];

    if (self.type == SDTextFieldTypeTime)
    {
        NSString *hours = [fragments objectAtIndex:0];
        NSString *minutes = [fragments objectAtIndex:1];
        NSString *seconds = [[fragments objectAtIndex:2] stringByAppendingString:newNumber];
        
        seconds = [NSString stringWithFormat:@"%@%@", [minutes substringWithRange:secondPart], [seconds substringWithRange:firstPart]];
        minutes = [NSString stringWithFormat:@"%@%@", [hours substringWithRange:secondPart], [minutes substringWithRange:firstPart]];
        hours = [NSString stringWithFormat:@"%@%@", newNumber, [hours substringWithRange:firstPart]];
        
        self.text = [NSString stringWithFormat:@"%@:%@:%@", hours, minutes, seconds];
    }
    else if (self.type == SDTextFieldTypeShortTime)
    {
        NSString *minutes = [fragments objectAtIndex:0];
        NSString *seconds = [[fragments objectAtIndex:1] stringByAppendingString:newNumber];
        
        seconds = [NSString stringWithFormat:@"%@%@", [minutes substringWithRange:secondPart], [seconds substringWithRange:firstPart]];
        minutes = [NSString stringWithFormat:@"%@%@", newNumber, [minutes substringWithRange:firstPart]];
        
        self.text = [NSString stringWithFormat:@"%@:%@", minutes, seconds];
    }
}

#pragma mark - Getters

- (NSNumber *)minNumberValue
{
    if (_minNumberValue == nil) {
        _minNumberValue = @(0.0);
    }
    
    return _minNumberValue;
}

- (NSNumber *)maxNumberValue
{
    if (_maxNumberValue == nil) {
        _maxNumberValue = @(CGFLOAT_MAX);
    }
    
    return _maxNumberValue;
}

#pragma mark - Setters

- (void)setType:(SDTextFieldType)type
{
    _type = type;
    
    switch (_type) {
        case SDTextFieldTypeTime:
            self.keyboardType = UIKeyboardTypeNumberPad;
            maxNumberOfDots = 0;
            maxNumberOfCharacters = 8;
            break;
        case SDTextFieldTypeShortTime:
            self.keyboardType = UIKeyboardTypeNumberPad;
            maxNumberOfDots = 0;
            maxNumberOfCharacters = 5;
            break;
        case SDTextFieldTypeDecimal:
            self.keyboardType = UIKeyboardTypeDecimalPad;
            maxNumberOfDots = 1;
            maxNumberOfCharacters = INT_MAX;
            break;
        case SDTextFieldTypeNumber:
            self.keyboardType = UIKeyboardTypeNumberPad;
            maxNumberOfDots = 0;
            maxNumberOfCharacters = INT_MAX;
            break;
        case SDTextFieldTypeTemperature:
            self.keyboardType = UIKeyboardTypeNumberPad;
            maxNumberOfCharacters = INT_MAX;
            maxNumberOfDots = INT_MAX;
            break;
        default:
            break;
    }
}

- (void)setDelegate:(id<SDTextFieldDelegate>)delegate
{
    [super setDelegate:delegate];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    if ([self.delegate respondsToSelector:@selector(textDidChangeInTextField:)]) {
        [self.delegate textDidChangeInTextField:self];
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    if (userInteractionEnabled) {
        [self setTextColor:self.enabledTextColor];
    } else {
        [self setTextColor:self.disabledTextColor];
    }
    
    [super setUserInteractionEnabled:userInteractionEnabled];
}

- (void)setMinNumberValue:(NSNumber *)minNumberValue
{
    if (_minNumberValue != minNumberValue) {
        _minNumberValue = minNumberValue;
        
        if (self.text.doubleValue < minNumberValue.doubleValue) {
            self.text = _minNumberValue.stringValue;
        }
    }
}

#pragma mark - Shake animations

- (void)performBasicShake
{
    CGRect centeredFrame = self.frame;
    CompletionBlock finalShakeCompletionBlock = ^(BOOL finished) {
        if (finished) {
            [self moveView:self toFrame:centeredFrame withCompletion:^(BOOL finished) {
                if (finished) {
                    double delayInSeconds = 0.8;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self setTextColor:[UIColor blackColor]];
                    });
                }
            }];
        }
    };
    
    CompletionBlock shakeCompletionBlock = ^(BOOL finished) {
        if (finished) {
            [self moveView:self toFrame:centeredFrame withCompletion:^(BOOL finished) {
                if (finished) {
                    [self shakeView:self inDirection:SDAnimationDirectionRight withCompletion:finalShakeCompletionBlock];
                }
            }];
        }
    };
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self shakeView:self inDirection:SDAnimationDirectionLeft withCompletion:shakeCompletionBlock];
    });
}

- (void)shakeView:(UIView *)view inDirection:(SDAnimationDirection)direction withCompletion:(void (^)(BOOL finished))completion
{
    switch (direction) {
        case SDAnimationDirectionLeft:
            [self leftShakeView:view withCompletion:completion];
            break;
        case SDAnimationDirectionRight:
            [self rightShakeView:view withCompletion:completion];
        default:
            break;
    }
}

- (void)leftShakeView:(UIView *)view withCompletion:(void (^)(BOOL finished))completion
{
    CGFloat left = view.frame.size.width/10.0;
    CGRect destinationFrame = view.frame;
    destinationFrame.origin.x -= left;
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         [view setFrame:destinationFrame];
                     }
                     completion:completion];
}

- (void)rightShakeView:(UIView *)view withCompletion:(void (^)(BOOL finished))completion
{
    CGFloat right = view.frame.size.width/10.0;
    CGRect destinationFrame = view.frame;
    destinationFrame.origin.x += right;
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         [view setFrame:destinationFrame];
                     }
                     completion:completion];
}

- (void)moveView:(UIView *)view toFrame:(CGRect)destinationFrame withCompletion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         [view setFrame:destinationFrame];
                     }
                     completion:completion];
}

- (void)markWrongValue
{
    [self.layer setBorderColor:[UIColor redColor].CGColor];
    [self.layer setBorderWidth:1.0f];
}

- (void)markCorrectValue
{
    [self.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.layer setBorderWidth:0.0f];
}

- (NSNumber *)numberFromString:(NSString *)string
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [formatter numberFromString:string];
}

@synthesize minNumberValue = _minNumberValue;

@end
