// NOTES: to reposition detail view, move it around in the xib; remember that this view takes up the whole screen in order to create a semitransparent overlay and to prevent screen interaction

#import "EditMenuItemCellDetailView.h"

@implementation EditMenuItemCellDetailView
  @synthesize picker, menuImagePreview, menuLabel, senderCell, delegate;


-(void)loadDetailAndDisplay: (MenuItemCell *)sender;
{
    // not in init function because reusing view cell
    
    senderCell = sender;
    menuLabel.text = senderCell.titleToDisplay;
    
    if(senderCell.isCustomPhoto == FALSE){
        menuImagePreview.image = [UIImage imageNamed: senderCell.imageLocation];
    }else{
        
        menuImagePreview.image = senderCell.imageView.image;      
    }
}


- (IBAction)cancelButtonPressed:(id)sender {

    self.hidden = TRUE;
    [delegate unhighlightUIObjects];
}

- (IBAction)okButtonPressed:(id)sender {
        
    // update text field
    senderCell.titleToDisplay = menuLabel.text;
    senderCell.textLabel.text = menuLabel.text;
    [senderCell reloadInputViews];
    
    senderCell.isCustomPhoto = TRUE;
    
    // save image to file
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSURL *documentDirectory = [[fileManger URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *photoName = [NSString stringWithFormat:@"%@_%@_photo.png", senderCell.titleToDisplay, [senderCell class]];
    NSURL *localFileLoc = [documentDirectory URLByAppendingPathComponent:
                           photoName]; 
    
    NSData *imageData = UIImagePNGRepresentation(menuImagePreview.image);
    [imageData writeToURL:localFileLoc atomically:YES];
    
    
    // set MenuItemCell to image and save image location
    senderCell.imageView.image = [UIImage imageWithData:imageData];  
    senderCell.imageLocation = photoName;

    
    // exit
    [menuLabel resignFirstResponder];
    self.hidden = TRUE;
    
    [delegate unhighlightUIObjects];
}



#pragma mark PhotoPicker & Delegate

- (IBAction)selectedPhotoButtonPressed:(id)sender {
    
    picker = [UIImagePickerController new];
    picker.delegate = self;
    
    // UIPicker is a nav, so need to 
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [delegate pickerHelperMethodLoadsViewController:picker];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    
    [Picker dismissViewControllerAnimated:YES completion:nil];}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    menuImagePreview.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [Picker dismissViewControllerAnimated:YES completion:nil]; }


@end
