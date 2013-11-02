//
//  EditMenuItemCellDetailView.m
//  iServe
//
//  Created by xcode on 10/31/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "EditMenuItemCellDetailView.h"

@implementation EditMenuItemCellDetailView
  @synthesize picker, menuImagePreview, menuLabel, senderCell;

- (IBAction)cancelButtonPressed:(id)sender {

  //  self.isHidden = TRUE;
}

- (IBAction)okButtonPressed:(id)sender {
}

- (IBAction)addPhotoButtonPressed:(id)sender {
}

-(void)loadDetailAndDisplay: (MenuItemCell *)sender;
{

    senderCell = sender;
 
    if(senderCell.isCustomPhoto == FALSE){
        menuImagePreview.image = [UIImage imageNamed: senderCell.imageLocation];
    }else{
  
        NSFileManager *fileManger = [NSFileManager defaultManager];
        NSURL *documentDirectory = [[fileManger URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *localFileLoc = [documentDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_photo.png", senderCell.titleToDisplay, [senderCell class]]];

     
        NSData *imageData = [NSData dataWithContentsOfURL: localFileLoc];
        menuImagePreview.image = [UIImage imageWithData:imageData];      
    }
}


#pragma mark PhotoPicker

- (IBAction)pressedSaveButton:(id)sender {
    
    // save image to file and save file location as property of Person
    NSString *photoName = [NSString stringWithFormat:@"%@_%@_photo.png", senderCell.titleToDisplay, [senderCell class]];
    senderCell.imageLocation = photoName;
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSURL *documentDirectory = [[fileManger URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *localFileLoc = [documentDirectory URLByAppendingPathComponent:
                           photoName]; 
    
    NSData *imageData = UIImagePNGRepresentation(menuImagePreview.image);
    [imageData writeToURL:localFileLoc atomically:YES];
}



#pragma mark IMAGE PICKER

- (IBAction)selectedPhotoButtonPressed:(id)sender {
    
    picker = [UIImagePickerController new];
    picker.delegate = self;
    
    // UIPicker is a nav, so need to 
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
// MUST BE NAV????
    
    //[self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    
    [Picker dismissViewControllerAnimated:YES completion:nil];}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    menuImagePreview.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [Picker dismissViewControllerAnimated:YES completion:nil]; }


@end
