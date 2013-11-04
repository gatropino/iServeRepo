//
//  EditMenuItemCellDetailView.h
//  iServe
//
//  Created by xcode on 10/31/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItemCell.h"
#import "ViewController.h"

@interface EditMenuItemCellDetailView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

  @property UIImagePickerController *picker;

  @property MenuItemCell *senderCell;
  @property id<TouchProtocol>delegate;

  @property (strong, nonatomic) IBOutlet UITextField *menuLabel;
  @property (strong, nonatomic) IBOutlet UIImageView *menuImagePreview;

  - (IBAction)cancelButtonPressed:(id)sender;
  - (IBAction)okButtonPressed:(id)sender;


  -(void)loadDetailAndDisplay: (MenuItemCell *)senderCell;

@end
