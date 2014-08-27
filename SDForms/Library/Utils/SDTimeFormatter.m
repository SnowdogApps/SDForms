//
//  SDTimeFormatter.m
//  SDForms
//
//  Created by Radoslaw Szeja on 22.04.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDTimeFormatter.h"

@implementation SDTimeFormatter

- (instancetype)initWithComponents:(SDTimeIntervalComponents *)components
{
    self = [super init];
    if (self) {
        self.timeComponents = components;
    }
    
    return self;
}

+ (NSString *)timeFromComponents:(SDTimeIntervalComponents *)components withSeparator:(NSString *)separator
{
    SDTimeFormatter *formatter = [[SDTimeFormatter alloc] initWithComponents:components];
    return [NSString stringWithFormat:@"%@%@%@%@%@", [formatter hours], separator, [formatter minutes], separator, [formatter seconds]];
}

+ (NSString *)shortTimeFromComponents:(SDTimeIntervalComponents *)components withSeparator:(NSString *)separator
{
    SDTimeFormatter *formatter = [[SDTimeFormatter alloc] initWithComponents:components];
    return [NSString stringWithFormat:@"%@%@%@", [formatter minutes], separator, [formatter seconds]];
}


- (NSString *)hours
{
    NSString *formattedHours = nil;
    
    if (self.timeComponents) {
        if (self.timeComponents.hours < 10) {
            formattedHours = [NSString stringWithFormat:@"0%li", (long)self.timeComponents.hours];
        } else {
            formattedHours = [NSString stringWithFormat:@"%li", (long)self.timeComponents.hours];
        }
    }
    
    return formattedHours;
}

- (NSString *)minutes
{
    NSString *formattedMinutes = nil;
    
    if (self.timeComponents) {
        if (self.timeComponents.minutes < 10) {
            formattedMinutes = [NSString stringWithFormat:@"0%li", (long)self.timeComponents.minutes];
        } else {
            formattedMinutes = [NSString stringWithFormat:@"%li", (long)self.timeComponents.minutes];
        }
    }
    
    return formattedMinutes;
}

- (NSString *)seconds
{
    NSString *formattedSeconds = nil;
    
    if (self.timeComponents) {
        if (self.timeComponents.seconds < 10){
            formattedSeconds = [NSString stringWithFormat:@"0%li", (long)self.timeComponents.seconds];
        } else {
            formattedSeconds = [NSString stringWithFormat:@"%li", (long)self.timeComponents.seconds];
        }
    }
            
    return formattedSeconds;
}

@end
