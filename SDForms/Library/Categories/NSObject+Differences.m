//
// Created by Radoslaw Szeja on 19.12.14.
// Copyright (c) 2014 Snowdog. All rights reserved.
//

#import "NSObject+Differences.h"


@implementation NSObject (Differences)

- (BOOL)isDifferent:(id)other {
    if (![other isKindOfClass:[self class]]){
        return YES;
    }

    SEL equalitySelector = @selector(isEqual:);

    if ([self isKindOfClass:[NSString class]]) {
        equalitySelector = @selector(isEqualToString:);
    } else if ([self isKindOfClass:[NSNumber class]]) {
        equalitySelector = @selector(isEqualToNumber:);
    } else if ([self isKindOfClass:[NSDate class]]) {
        equalitySelector = @selector(isEqualToDate:);
    } else if ([self isKindOfClass:[NSData class]]) {
        equalitySelector = @selector(isEqualToData:);
    }

    if ([self respondsToSelector:equalitySelector]) {
        IMP imp = [self methodForSelector:equalitySelector];
        BOOL (*func)(id, SEL, NSNumber *) = (void *)imp;
        return !func(self, equalitySelector, other);
    } else {
        if (self == other) {
            return YES;
        }
    }

    return NO;
}

@end