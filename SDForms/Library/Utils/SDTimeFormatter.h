//
//  SDTimeFormatter.h
//  SDForms
//
//  Created by Radoslaw Szeja on 22.04.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDTimeIntervalComponents.h"

@interface SDTimeFormatter : NSObject
@property (nonatomic, strong) SDTimeIntervalComponents *timeComponents;

- (instancetype)initWithComponents:(SDTimeIntervalComponents *)components;
+ (NSString *)timeFromComponents:(SDTimeIntervalComponents *)components withSeparator:(NSString *)separator;
+ (NSString *)shortTimeFromComponents:(SDTimeIntervalComponents *)components withSeparator:(NSString *)separator;

- (NSString *)hours;
- (NSString *)minutes;
- (NSString *)seconds;
@end
