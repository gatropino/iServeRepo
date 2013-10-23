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

-(void)resetPizzaInventoryLevels
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"AvailableIngredients" inManagedObjectContext:managedObjectContext]];
    
    // ??????????????????????????????????????????????
    // or add selector method within error parameter?
    if (![managedObjectContext executeFetchRequest:searchRequest error:nil]) {

    AvailableIngredients *availIngrediants = (AvailableIngredients *) [NSEntityDescription insertNewObjectForEntityForName:@"AvailableIngredients" inManagedObjectContext:[self managedObjectContext]];
    availIngrediants.sausage = @5;
    availIngrediants.cheese = @5;
    availIngrediants.pepperoni = [NSNumber numberWithInt:5];
    }
    else
    {
    NSArray *availArray = [managedObjectContext executeFetchRequest:searchRequest error:nil];
    AvailableIngredients *ingredients = [availArray objectAtIndex:0];
    
        ingredients.cheese = @5;
        ingredients.sausage = @5;
        ingredients.pepperoni = @5;
    }
    
}

-(NSArray *)fetchAllFoodTypes
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"Food" inManagedObjectContext:managedObjectContext]];
    
    NSArray *matchedObjects = [managedObjectContext executeFetchRequest:searchRequest error:nil];
    
    return matchedObjects;
}

-(NSFetchedResultsController *) fetchedResultsController
{
    if (fetchedResultsController != nil)
    {
        return fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pizza"
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cheese"
                                                                   ascending:YES
                                                                    selector:nil];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchedResultsController.delegate = self;
    
    return fetchedResultsController;
}

-(Pizza *)builtPizza:(Pizza *)pizzaToBeBuilt quantityOfCheese:(NSNumber *)cheeseToppings quantityOfSausage:(NSNumber *)sausageToppings quantityOfPepperoni:(NSNumber *)pepperoniToppings
{
    pizzaToBeBuilt = (Pizza *) [NSEntityDescription insertNewObjectForEntityForName:@"Pizza" inManagedObjectContext:[self managedObjectContext]];
    
    pizzaToBeBuilt.cheese = cheeseToppings;
    pizzaToBeBuilt.sausage = sausageToppings;
    pizzaToBeBuilt.pepperoni= pepperoniToppings;
    
    return pizzaToBeBuilt;
}

-(Pizza *)createPizzaObject
{
    Pizza *newPizza = (Pizza *) [NSEntityDescription insertNewObjectForEntityForName:@"Pizza" inManagedObjectContext:[self managedObjectContext]];
    
    return newPizza;
}

@end
