//
//  EditMenuItemCellDetailView.h
//  iServe
//
//  Created by xcode on 10/31/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMenuItemCellDetailView : UIView

@property (strong, nonatomic) IBOutlet UITextField *menuLabel;
@property (strong, nonatomic) IBOutlet UIImageView *menuImagePreview;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)okButtonPressed:(id)sender;
- (IBAction)addPhotoButtonPressed:(id)sender;

-(void)loadDetailAndDisplay;

@end
