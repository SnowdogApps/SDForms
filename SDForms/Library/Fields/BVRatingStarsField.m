//
//  BVRatingStarsField.m
//  SDForms
//
//  Created by Tim Kelly on 5/20/16.
//  Copyright © 2016 Snowdog sp. z o.o. All rights reserved.
//

#import "BVRatingStarsField.h"
#import "BVRatingStarsFormCell.h"

@interface BVRatingStarsField()

@property (strong, nonatomic) BVRatingStarsFormCell *ratingCell;

@end

@implementation BVRatingStarsField

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    BVRatingStarsFormCell *cell = (BVRatingStarsFormCell *)[super cellForTableView:tableView atIndex:index];
    
    // any work to get the cell
    
    cell.ratingStars.maximumValue = self.maximumValue;
    cell.ratingStars.minimumValue = self.minimumValue;
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
