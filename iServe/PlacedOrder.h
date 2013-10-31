//
//  PlacedOrder.h
//  iServe
//
//  Created by Greg Tropino on 10/30/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlacedOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * coke;
@property (nonatomic, retain) NSNumber * budweiser;
@property (nonatomic, retain) NSNumber * sprite;
@property (nonatomic, retain) NSNumber * cheese;
@property (nonatomic, retain) NSNumber * pepperoni;
@property (nonatomic, retain) NSNumber * sausage;
@property (nonatomic, retain) NSNumber * ticketNumber;
@property (nonatomic, retain) NSNumber * veggie;
@property (nonatomic, retain) NSDate * timeOfOrder;
@property (nonatomic, retain) NSString * orderedFromTable;

@end
