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
@property BOOL isCustomPhoto;

@property NSString *type;               // eg. MenuItem, UIDestination, UIInstance, MenuBranch, UIFilter
@property NSString *localIDNumber;      //     used to define behaviors 
@property NSString *instanceOf;         // specifies the idNumber of the UIDestination a MenuItem was dropped on

@property BOOL isSelected;
@property BOOL canDrag;
@property NSString *destination;        // name of a parent can you drag and drop to (one only)
@property NSString *receives;           // name of an item that can be dropped on you (one only, unless use "ALL")

@property float defaultPositionX;   
@property float defaultPositionY;
@property BOOL placeInstancesInHorizontalLine;
@property UIColor *defaultColor;  // FIX ME, either do perform selector based on string or ?????
@property UIColor *highlightedColor;  // FIX ME
@property UIColor *dragColor;  // FIX ME

// instance tracking variables providing intuitive access
@property NSString *restaurant;
@property NSString *table;
@property NSString *customer;
@property BOOL isSeated;
@property BOOL orderConfirmed;

// for objects able to initiate actions (could subclass, but then would require time to rewrite code)
@property NSString *filterRestaurant;
@property NSString *filterTable;
@property NSString *filterCustomer;
@property BOOL filterIsSeated;

@property id<TouchProtocol>delegate;  // ??????????????
@property int buildMode;  // 0 = build mode off  1 = can drag from menu to create instance  2 = instance created 
                          // create enum, or more trouble than worth

@property NSManagedObject *MenuItemCellObject;


@end

//TO ADD
//  useCurrentSizeAndLocationSettings (to make method, not used here)


