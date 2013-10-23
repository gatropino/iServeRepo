//
//  Food.h
//  iServe
//
//  Created by Greg Tropino on 10/23/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Food.h"
#import "Pizza.h"

@class Pizza;

@interface Food : NSManagedObject

@property (nonatomic, retain) Pizza *pizza;

@end
