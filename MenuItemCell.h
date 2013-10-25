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

@property NSString *name;        // aka, textLabel
@property NSString *type;
@property NSString *parentName;
@property NSString *parentType;
@property NSString *viewLevel;
@property NSString *imageLocation;

@property BOOL canDrag;
@property float defaultPositionX;
@property float defaultPositionY;
@property UIColor *defaultColor;
@property UIColor *highlightedColor;
@property UIColor *dragColor;
@property BOOL isSelected;

@property id<TouchProtocol>delegate;

@end