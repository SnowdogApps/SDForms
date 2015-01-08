//
//  SDDataValidator.h
//  SDForms
//
//  Created by Radoslaw Szeja on 26.05.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SDValidationType) {
    SDValidationTypeNone            = 0,
    SDValidationTypeNotEmpty        = 1 << 0,
    SDValidationTypePositive        = 1 << 1,
    SDValidationTypeNonNegative     = 1 << 2,
    SDValidationTypeAtLeastOneValue = 1 << 3
};

typedef NS_OPTIONS(NSUInteger, SDValidationResult) {
    SDValidationResultPassed                    = 0,
    SDValidationResultFailedNotEmpty            = 1 << 0,
    SDValidationResultFailedNonNegative         = 1 << 1,
    SDValidationResultFailedPositive            = 1 << 2,
    SDValidationResultFailedAtLeastOneValue     = 1 << 3,
    SDValidationResultFailedNilObject           = 1 << 4,
    SDValidationResultFailedNoRules             = 1 << 5,
    SDValidationResultNotValidated              = 1 << 6,
    SDValidationResultWrongType                 = 1 << 7,
    SDValidationResultWrongPropertyName         = 1 << 8
};

@interface SDDataValidator : NSObject

/**
 * Validate objects using KVC
 * @param object object to be validated
 * @param rules NSDictionary {key : SDValidationType} defining validation rules. Key should be an object property name to be validated.
 * @return NSDictionary {key : @(SDValidationResult)} or {@"failed" : @(SDValidationResult)}. 
 * If SDValidationTypeNone was set for key, the result is {key : @(SDValidationResultNotValidated)}.
 * If the objectForKey returned object that can't be validated with provided SDValidationType, 
 * @{key: @(SDValidationResultWrongType)} is returned.
 **/
+ (NSDictionary *)validateObject:(id)object withRules:(NSDictionary *)rules;

/**
 * NSLogs the dictionary with validation results
 **/
+ (void)reportValidationDictionary:(NSDictionary *)result;

+ (BOOL)didValidationPassedForResult:(NSDictionary *)result;

@end


@interface SDDataValidator (MarkFailsOnIndexPaths)

+ (NSArray *)indexPathsOfFailForValidationResults:(NSDictionary *)validationResult andCorrespondingIndexPaths:(NSDictionary *)indexPaths;

@end
