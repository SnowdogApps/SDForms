//
//  NSMutableDictionary+SDExtensions.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 17.09.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "NSMutableDictionary+SDExtensions.h"

@implementation NSMutableDictionary (SDExtensions)

- (void)setNillableObject:(id)object forKey:(NSString *)key
{
    if (object && ![object isEqual:[NSNull null]]) {
        [self setObject:object forKey:key];
    }
}

@end
