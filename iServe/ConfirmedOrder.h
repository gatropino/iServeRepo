//
//  ConfirmedOrder.h
//  iServe
//
//  Created by Greg Tropino on 11/3/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ConfirmedOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * budweiser;
@property (nonatomic, retain) NSNumber * cheese;
@property (nonatomic, retain) NSNumber * coke;
@property (nonatomic, retain) NSString * orderedFromTable;
@property (nonatomic, retain) NSNumber * pepperoni;
@property (nonatomic, retain) NSNumber * sausage;
@property (nonatomic, retain) NSNumber * sprite;
@property (nonatomic, retain) NSNumber * ticketNumber;
@property (nonatomic, retain) NSDate * timeOfOrder;
@property (nonatomic, retain) NSNumber * totalDrinks;
@property (nonatomic, retain) NSNumber * totalPizzas;
@property (nonatomic, retain) NSNumber * veggie;
@property (nonatomic, retain) NSNumber * uploaded;

@end
