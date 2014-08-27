//
//  SDTimeIntervalComponents.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 27.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDTimeIntervalComponents.h"

#define SD_SECONDS_PER_HOUR     3600.0
#define SD_SECONDS_PER_MINUTE   60.0

@implementation SDTimeIntervalComponents

- (id) init
{
    self = [super init];
    if(self) {
        self.hours = 0;
        self.minutes = 0;
        self.seconds = 0;
    }
    return self;
}

- (id) initWithHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    self = [super init];
    if(self) {
        self.hours = hours;
        self.minutes = minutes;
        self.seconds = seconds;
    }
    return self;
}

+ (SDTimeIntervalComponents*) componentsWithRange:(SDTimeIntervalUnitRange)range andInterval:(NSTimeInterval)interval
{
    SDTimeIntervalComponents *components = [[SDTimeIntervalComponents alloc] init];
    
    if(range == SDTimeIntervalUnitRangeHourToSecond)
    {
        components.hours = floor(interval / SD_SECONDS_PER_HOUR);
        components.minutes = floor((interval - components.hours * SD_SECONDS_PER_HOUR) / SD_SECONDS_PER_MINUTE);
        components.seconds = floor((interval - components.hours * SD_SECONDS_PER_HOUR - components.minutes * SD_SECONDS_PER_MINUTE));
    }
    else
    {
        components.minutes = floor(interval / SD_SECONDS_PER_MINUTE);
        components.seconds = floor((interval - components.minutes * SD_SECONDS_PER_MINUTE));
    }
    
    return components;
}

- (NSTimeInterval) timeInterval
{
    NSTimeInterval timeInterval = self.hours * SD_SECONDS_PER_HOUR + self.minutes * SD_SECONDS_PER_MINUTE + self.seconds;
    
    return timeInterval;
}

@end
