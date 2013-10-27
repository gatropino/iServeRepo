//
//  MenuItemCell.h
//  dragAndDrop
//
//  Created by xcode on 10/23/13.
//  Copyright (c) 2013 xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchProtocol.h"

@interface MenuItemCell : UIView

@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property NSString *parentName;         // used for finding children
@property NSString *name; 
@property NSString *titleToDisplay;     
@property NSString *imageLocation;

@property NSString *type;               // eg. MenuItem, UIDestination, UIInstance, MenuBranch, UIFilter
@property NSString *localIDNumber;      //     used to define behaviors 
@property NSString *instanceOf;         // specifies the idNumber of the UIDestination a MenuItem was dropped on

@property BOOL isSelected;
@property BOOL canDrag;
@property NSString *destination;        // name of a parent can you drag and drop to (one only)
@property NSString *receives;           // name of an item that can be dropped on you (one only, unless use "ALL")

@property float defaultPositionX;   
@property float defaultPositionY;
@property UIColor *defaultColor;
@property UIColor *highlightedColor;
@property UIColor *dragColor;

@property id<TouchProtocol>delegate;

@end

//TO ADD
//  useCurrentSizeAndLocationSettings (to make method, not used here)
//  placeInstancesInHorizontalLine 

