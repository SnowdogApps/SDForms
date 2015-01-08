//
//  SDStarRatingView.h
//  SDForms
//
//  Created by Radoslaw Szeja on 27.02.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SDStarRatingViewDelegate;

@interface SDStarRatingView : UIView

@property (weak, nonatomic) id<SDStarRatingViewDelegate> delegate;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starsCollection;
@property (strong, nonatomic) NSNumber *numberOfFullStars;

@property (nonatomic) BOOL active;

@end

@protocol SDStarRatingViewDelegate <NSObject>
@optional
- (void)starRatingView:(SDStarRatingView *)starRatingView didChangeSelectionToStars:(NSNumber *)numberOfStars;
@end