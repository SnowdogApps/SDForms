//
//  SDPhotoCell.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 27.01.2015.
//  Copyright (c) 2015 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormCell.h"

static NSString *kPhotoCell = @"SDPhotoCell";

@interface SDPhotoCell : SDFormCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end
