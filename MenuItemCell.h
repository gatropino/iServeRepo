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

@property NSString *parentName;
@property NSString *name;        
@property NSString *type;        
@property NSString *titleToDisplay;       
@property NSString *imageLocation;

@property NSString *destination;  
@property NSString *receives;
@property BOOL canDrag;
@property BOOL isSelected;
@property float defaultPositionX;
@property float defaultPositionY;
@property UIColor *defaultColor;
@property UIColor *highlightedColor;
@property UIColor *dragColor;

@property id<TouchProtocol>delegate;

@end