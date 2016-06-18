//
//  SDPhotoField.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 27.01.2015.
//  Copyright (c) 2015 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"

@interface SDPhotoField : SDFormField

/// Icon to be used in the call toa ction in the cell. Will be 44x44
@property (strong, nonatomic) UIImage *callToActionImage;

@end
