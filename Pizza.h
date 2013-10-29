//
//  Pizza.h
//  iServe
//
//  Created by Greg Tropino on 10/28/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Food.h"


@interface Pizza : Food

@property (nonatomic, retain) NSNumber * cheese;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * pepperoni;
@property (nonatomic, retain) NSNumber * sausage;

@end
