//
//  Images.h
//  iServe
//
//  Created by Greg Tropino on 10/28/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Images : NSManagedObject

@property (nonatomic, retain) NSString * pizzaCheese;
@property (nonatomic, retain) NSString * pizzaPepperoni;
@property (nonatomic, retain) NSString * pizzaSausage;
@property (nonatomic, retain) NSString * storeBinaryImagesLater;

@end
