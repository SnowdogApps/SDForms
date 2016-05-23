//
//  SDRatingStarsField.m
//  SDForms
//
//  Created by Tim Kelly on 5/20/16.
//  Copyright © 2016 Snowdog sp. z o.o. All rights reserved.
//

#import "SDRatingStarsField.h"
#import "SDRatingStarsFormCell.h"

@interface SDRatingStarsField()

@property (strong, nonatomic) SDRatingStarsFormCell *ratingCell;

@end

@implementation SDRatingStarsField

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDRatingStarsFormCell *cell = (SDRatingStarsFormCell *)[super cellForTableView:tableView atIndex:index];
    
    // any work to get the cell
    
    if (self.maximumValue == 0 && self.minimumValue == 0){
        self.maximumValue = 5 && self.minimumValue == 0;
    } else {
        cell.ratingStars.maximumValue = self.maximumValue;
        cell.ratingStars.minimumValue = self.minimumValue;
    }
    
    if (self.starsColor){
        cell.ratingStars.tintColor = self.starsColor;
    }
    
    cell.ratingStars.value = [self.value floatValue];
    
    self.ratingCell = cell;
    
    [self.ratingCell.ratingStars addTarget:self action:@selector(didChangeValue) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (void)didChangeValue{
    self.value = [NSNumber numberWithFloat:self.ratingCell.ratingStars.value];
}

- (NSArray *)cellHeights {
    return @[@66.0];
}

- (NSArray *)reuseIdentifiers {
    return @[kStarRatingCell];
}


- (void)setValue:(NSNumber *)value
{
    
    [self setValue:value withCellRefresh:YES];
}


@dynamic value;

@end
