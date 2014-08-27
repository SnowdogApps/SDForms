//
//  SDTimeIntervalComponents.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 27.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SDTimeIntervalUnitRangeHourToSecond,
    SDTimeIntervalUnitRangeMinuteToSecond
} SDTimeIntervalUnitRange;

@interface SDTimeIntervalComponents : NSObject

@property (nonatomic) NSInteger hours;
@property (nonatomic) NSInteger minutes;
@property (nonatomic) NSInteger seconds;

- (id) initWithHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;
+ (SDTimeIntervalComponents*) componentsWithRange:(SDTimeIntervalUnitRange)range andInterval:(NSTimeInterval)interval;
- (NSTimeInterval) timeInterval;

@end
