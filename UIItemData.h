//
//  UIItemData.h
//  iServe
//
//  Created by Greg Tropino on 10/28/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UIItemData : NSManagedObject

@property (nonatomic, retain) NSNumber * buildMode;
@property (nonatomic, retain) NSNumber * canDrag;
@property (nonatomic, retain) NSString * customer;
@property (nonatomic, retain) NSNumber * defaultPositionX;
@property (nonatomic, retain) NSNumber * defaultPositionY;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSString * filterCustomer;
@property (nonatomic, retain) NSNumber * filterIsSeated;
@property (nonatomic, retain) NSString * filterRestaurant;
@property (nonatomic, retain) NSString * filterTable;
@property (nonatomic, retain) NSString * imageLocation;
@property (nonatomic, retain) NSString * instanceOf;
@property (nonatomic, retain) NSNumber * isSeated;
@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) NSString * localIDNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parentName;
@property (nonatomic, retain) NSNumber * placeInstancesInHorizontalLine;
@property (nonatomic, retain) NSString * receives;
@property (nonatomic, retain) NSString * restaurant;
@property (nonatomic, retain) NSString * table;
@property (nonatomic, retain) NSString * titleToDisplay;
@property (nonatomic, retain) NSString * type;

@end
