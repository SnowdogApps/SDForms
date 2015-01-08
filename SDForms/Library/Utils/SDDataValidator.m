//
//  SDDataValidator.m
//  SDForms
//
//  Created by Radoslaw Szeja on 26.05.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDDataValidator.h"

@implementation SDDataValidator

+ (NSDictionary *)validateObject:(id)object withRules:(NSDictionary *)rules
{    
    if (object == nil) {
        return @{@"failed": @(SDValidationResultFailedNilObject)};
    }
    
    if (rules == nil) {
        return @{@"failed": @(SDValidationResultFailedNoRules)};
    }
    
    NSMutableDictionary *validationResult = [NSMutableDictionary dictionary];
    
    for (NSString *key in rules) {
        if ([object respondsToSelector:NSSelectorFromString(key)]) {
            SDValidationType currentValidationType = [[rules objectForKey:key] unsignedIntegerValue];
            SDValidationResult result = [self validateObject:object forKey:key withSingleValidationType:currentValidationType];
            [validationResult setObject:@(result) forKey:key];
        } else {
            [validationResult setObject:@(SDValidationResultWrongPropertyName) forKey:key];
        }
    }
    
    return validationResult;
}

+ (SDValidationResult)validateObject:(id)object forKey:(NSString *)key withSingleValidationType:(SDValidationType)validationType
{
    SDValidationResult result = SDValidationResultPassed;
    
    if (validationType == SDValidationTypeNone) {
        return SDValidationResultNotValidated;
    } else {
        id property = [object valueForKey:key];
        
        if (validationType & SDValidationTypeAtLeastOneValue) {
            result = result | [self validateAtLeastOneValueInObjectsProperty:property];
        }
        
        if (validationType & SDValidationTypeNonNegative) {
            result = result | [self validateNonNegativeInObjectsProperty:property];
        }
        
        if (validationType & SDValidationTypeNotEmpty) {
            result = result | [self validateNotEmptyInObjectsProperty:property];
        }
        
        if (validationType & SDValidationTypePositive) {
            result = result | [self validatePositiveInObjectsProperty:property];
        }
    }
    
    if (result & SDValidationResultWrongType) {
        result = SDValidationResultWrongType;
    }
    
    return result;
}

+ (SDValidationResult)validateAtLeastOneValueInObjectsProperty:(id)property
{
    SDValidationResult result = SDValidationResultWrongType;
    
    if ([property respondsToSelector:@selector(count)]) {
        result = ([property performSelector:@selector(count)] > 0) ? SDValidationResultPassed : SDValidationResultFailedAtLeastOneValue;
    }
    
    return result;
}

+ (SDValidationResult)validateNonNegativeInObjectsProperty:(id)property
{
    SDValidationResult result = SDValidationResultWrongType;
    
    if ([property isKindOfClass:[NSNumber class]]) {
        result = ([property performSelector:@selector(doubleValue)] >= 0) ? SDValidationResultPassed : SDValidationResultFailedNonNegative;
    }
    
    return result;
}

+ (SDValidationResult)validateNotEmptyInObjectsProperty:(id)property
{
    SDValidationResult result = SDValidationResultPassed;
    
    if (property != nil) {
        if ([property isKindOfClass:[NSString class]]) {
            NSString *stringProperty = (NSString *)property;
            result =  (stringProperty.length > 0) ? SDValidationResultPassed : SDValidationResultFailedNotEmpty;
        }
    } else {
        result = SDValidationResultFailedNotEmpty;
    }
    
    return result;
}

+ (SDValidationResult)validatePositiveInObjectsProperty:(id)property
{
    SDValidationResult result = SDValidationResultWrongType;
    
    if ([property isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)property;
        result = (number.doubleValue > 0) ? SDValidationResultPassed : SDValidationResultFailedPositive;
    }
    
    return result;
}

+ (void)reportValidationDictionary:(NSDictionary *)result
{
    for (NSString *key in result) {
        SDValidationResult validationResult = [[result objectForKey:key] unsignedIntegerValue];
        NSString *resultString = @"";
        
        if (validationResult == SDValidationResultPassed) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultPassed"];
        }
        
        if (validationResult & SDValidationResultFailedNotEmpty) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultFailedNotEmpty"];
        }
        
        if (validationResult & SDValidationResultFailedNonNegative) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultFailedNonNegative"];
        }
        
        if (validationResult & SDValidationResultFailedPositive) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultFailedPositive"];
        }
        
        if (validationResult & SDValidationResultFailedAtLeastOneValue) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultFailedAtLeastOneValue"];
        }
        
        if (validationResult & SDValidationResultFailedNilObject) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultFailedNilObject"];
        }
        
        if (validationResult & SDValidationResultFailedNoRules) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultFailedNoRules"];
        }
        
        if (validationResult & SDValidationResultNotValidated) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultNotValidated"];
        }
        
        if (validationResult & SDValidationResultWrongType) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultWrongType"];
        }
        
        if (validationResult & SDValidationResultWrongPropertyName) {
            resultString = [resultString stringByAppendingString:@"SDValidationResultWrongPropertyName"];
        }
        
        NSLog(@"%@ : %@", key, resultString);
    }
}

+ (BOOL)didValidationPassedForResult:(NSDictionary *)result
{
    NSArray *results = [result allValues];
    
    for (NSNumber *singleResultObj in results) {
        SDValidationResult singleResult = singleResultObj.unsignedIntegerValue;
        if (singleResult != SDValidationResultPassed && singleResult != SDValidationResultNotValidated) {
            return NO;
        }
    }
    
    return YES;
}

@end

@implementation SDDataValidator (MarkFailsOnIndexPaths)

+ (NSArray *)indexPathsOfFailForValidationResults:(NSDictionary *)validationResult andCorrespondingIndexPaths:(NSDictionary *)indexPaths
{
    NSArray *indexPathsToMark = nil;

    NSMutableArray *mutableIndexPathsToMark = [NSMutableArray array];
    
    for (NSString *key in validationResult) {
        SDValidationResult result = [[validationResult objectForKey:key] unsignedIntegerValue];
        if (result != SDValidationResultPassed) {
            [mutableIndexPathsToMark addObject:[indexPaths objectForKey:key]];
        }
    }
    
    if (mutableIndexPathsToMark.count > 0) {
        indexPathsToMark = [mutableIndexPathsToMark copy];
    }
    
    return indexPathsToMark;
}

@end
