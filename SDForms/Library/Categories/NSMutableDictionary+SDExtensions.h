//
//  NSMutableDictionary+SDExtensions.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 17.09.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SDExtensions)

- (void)setNillableObject:(id)object forKey:(NSString *)key;

@end
