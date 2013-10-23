//
//  Pizza.h
//  iServe
//
//  Created by Greg Tropino on 10/23/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food;

@interface Pizza : NSManagedObject

@property (nonatomic, retain) NSNumber * cheese;
@property (nonatomic, retain) NSNumber * pepperoni;
@property (nonatomic, retain) NSNumber * sausage;
@property (nonatomic, retain) Food *food;

@end
