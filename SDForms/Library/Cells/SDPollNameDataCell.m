//
//  SDPollNameDataCell.m
//  SDForms
//
//  Created by Radoslaw Szeja on 09.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDPollNameDataCell.h"

@implementation SDPollNameDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.lineView setBackgroundColor:[UIColor clearColor]];
    
    self.firstNameTextField.placeholder = NSLocalizedString(@"First name", nil);
    self.lastNameTextField.placeholder = NSLocalizedString(@"Last name", nil);
}

- (void)setAvatar:(UIImageView *)imageView
{
    CALayer *imageLayer = imageView.layer;
    [imageLayer setCornerRadius:imageView.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    
    _avatar = imageView;
}

- (IBAction)photoButtonTapped:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(pollNameDataCellDidTapPhotoButton:)]) {
        [self.delegate pollNameDataCellDidTapPhotoButton:self];
    }
}

@end
