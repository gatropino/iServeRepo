//
//  CoreData.m
//  iServe
//
//  Created by Greg Tropino on 10/23/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData

@synthesize fetchedResultsController, managedObjectContext;

-(void)setPizzaInventoryLevels
{
    Food *resetFood;
    
    resetFood.pizza.sausage = [NSNumber numberWithInt:5];
    resetFood.pizza.cheese = [NSNumber numberWithInt:5];
    resetFood.pizza.pepperoni = [NSNumber numberWithInt:5];
    
    

}

-(Food *)createMenuItemsOnce
{
    Food *newFood = (Food *) [NSEntityDescription insertNewObjectForEntityForName:@"Food" inManagedObjectContext:[self managedObjectContext]];
    newFood.pizza = (Pizza *) [NSEntityDescription insertNewObjectForEntityForName:@"Pizza" inManagedObjectContext:[self managedObjectContext]];
    
    return newFood;
}

@end
