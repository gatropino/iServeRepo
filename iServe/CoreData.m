//
//  CoreData.m
//  iServe
//
//  Created by Greg Tropino on 10/23/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData

-(void)setPizzaInventoryLevels
{
    Food *resetFood;
    
    resetFood.pizza.sausage = [NSNumber numberWithInt:5];
    resetFood.pizza.cheese = [NSNumber numberWithInt:5];
    resetFood.pizza.pepperoni = [NSNumber numberWithInt:5];
    
    
    //RootViewController *rvc = (RootViewController *)[segue destinationViewController];
    Food *newFood = (Food *) [NSEntityDescription insertNewObjectForEntityForName:@"Food" inManagedObjectContext:[self managedObjectContext]];
    newFood.pizza = (Address *) [NSEntityDescription insertNewObjectForEntityForName:@"Pizza" inManagedObjectContext:[self managedObjectContext]];
    //rvc.currentFood = newFood;

}

-(Food)create

@end
