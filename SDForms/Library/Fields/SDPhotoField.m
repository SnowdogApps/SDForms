//
//  SDPhotoField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 27.01.2015.
//  Copyright (c) 2015 Snowdog sp. z o.o. All rights reserved.
//

#import "SDPhotoField.h"
#import "SDPhotoCell.h"

@interface SDPhotoField () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation SDPhotoField

- (NSArray *)reuseIdentifiers {
    return @[kPhotoCell];
}

- (NSArray *)cellHeights {
    return @[@160.0];
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index {
    SDPhotoCell *cell = (SDPhotoCell *)[super cellForTableView:tableView atIndex:index];
    
    if (self.value != nil) {
        cell.photoView.image = self.value;
        cell.placeholderLabel.hidden = YES;
    } else {
        cell.photoView.image = nil;
        cell.placeholderLabel.hidden = NO;
        cell.placeholderLabel.text = NSLocalizedString(@"Tap to add a photo", nil);
    }
    
    return cell;
}

- (void)form:(SDForm *)form didSelectFieldAtIndex:(NSInteger)index {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        self.value = [info objectForKey:UIImagePickerControllerOriginalImage];
    }];
}

@end
