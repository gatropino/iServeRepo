//
//  AvailableIngredients.h
//  iServe
//
//  Created by Greg Tropino on 10/30/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AvailableIngredients : NSManagedObject

@property (nonatomic, retain) NSNumber * cheese;
@property (nonatomic, retain) NSNumber * pepperoni;
@property (nonatomic, retain) NSNumber * sausage;
@property (nonatomic, retain) NSNumber * ticketNumber;
@property (nonatomic, retain) NSNumber * confirmedTicketNumber;
@property (nonatomic, retain) NSNumber * localIDNumber;
@property (nonatomic, retain) NSDate * createdAt;

@end
