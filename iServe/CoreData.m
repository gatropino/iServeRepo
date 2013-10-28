//
//  CoreData.m
//  iServe
//
//  Created by Greg Tropino on 10/23/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData
static CoreData* sMyData;
id observer2;

@synthesize fetchedResultsController, managedObjectContext;

-(void)testingMethod
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    observer2 = [nc addObserverForName:@"CoreDataTesting" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
                 {
                     [self performSelector:@selector(resetPizzaInventoryLevels) withObject:nil];
                     
                 }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer2];
}


+(CoreData *)myData
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSLog(@"Dispatch once");
        sMyData = [[CoreData alloc] init];
    });
    NSLog(@"returning coredata singleton = %@", sMyData);
    
    return sMyData;
}

-(id)init
{
    if (self = [super init]) {
        NSLog(@"instantiating the singleton here: %@", self);
    }
    return self;
}

-(void)resetPizzaInventoryLevels
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"AvailableIngredients" inManagedObjectContext:managedObjectContext]];
    
    NSArray *availArray = [managedObjectContext executeFetchRequest:searchRequest error:nil];

    if ([availArray count] <= 0) {
        AvailableIngredients *availIngredients = (AvailableIngredients *) [NSEntityDescription insertNewObjectForEntityForName:@"AvailableIngredients" inManagedObjectContext:[self managedObjectContext]];
        availIngredients.sausage = @5;
        availIngredients.cheese = @5;
        availIngredients.pepperoni = [NSNumber numberWithInt:5];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    }
    else
    {
        NSArray *searchedArray = [managedObjectContext executeFetchRequest:searchRequest error:nil];
        AvailableIngredients *ingredients = [searchedArray objectAtIndex:0];
        ingredients.cheese = @5;
        ingredients.sausage = @5;
        ingredients.pepperoni = @5;
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    }
}

-(NSArray *)fetchAllPizzasMade
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"Food" inManagedObjectContext:managedObjectContext]];
    
    NSArray *matchedObjects = [managedObjectContext executeFetchRequest:searchRequest error:nil];
    //creates a list of ALL pizzas created, would work well for a list of all pizzas made/sold but need it to show only ONE pizza, fix later
    return matchedObjects;
}

-(NSInteger)totalCheesePizzasSold
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    
    fr.entity = [NSEntityDescription entityForName:@"Pizza" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    
    NSExpressionDescription *sumOfCheeseDescription = [[NSExpressionDescription alloc] init];
    [sumOfCheeseDescription setName:@"TotalOfPizzaAttribute"];
    
    [sumOfCheeseDescription setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"cheese"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfCheeseDescription setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfCheeseDescription];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfPizzaAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)totalSausagePizzasSold
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    
    fr.entity = [NSEntityDescription entityForName:@"Pizza" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    
    NSExpressionDescription *sumOfCheeseDescription = [[NSExpressionDescription alloc] init];
    [sumOfCheeseDescription setName:@"TotalOfPizzaAttribute"];
    
    [sumOfCheeseDescription setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"sausage"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfCheeseDescription setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfCheeseDescription];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfPizzaAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)totalPepperoniPizzasSold
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    
    fr.entity = [NSEntityDescription entityForName:@"Pizza" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    
    NSExpressionDescription *sumOfCheeseDescription = [[NSExpressionDescription alloc] init];
    [sumOfCheeseDescription setName:@"TotalOfPizzaAttribute"];
    
    [sumOfCheeseDescription setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"pepperoni"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfCheeseDescription setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfCheeseDescription];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfPizzaAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}


-(NSArray *)attributesOfPizza
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pizza" inManagedObjectContext:managedObjectContext];
    
    NSLog(@"%@", entity.properties);
    
    return entity.properties;
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

-(Pizza *)quantityOfCheese:(NSNumber *)cheeseToppings quantityOfSausage:(NSNumber *)sausageToppings quantityOfPepperoni:(NSNumber *)pepperoniToppings
{
    Pizza *pizzaToBeBuilt;
    
    pizzaToBeBuilt = (Pizza *) [NSEntityDescription insertNewObjectForEntityForName:@"Pizza" inManagedObjectContext:[self managedObjectContext]];
    
    pizzaToBeBuilt.cheese = cheeseToppings;
    pizzaToBeBuilt.sausage = sausageToppings;
    pizzaToBeBuilt.pepperoni= pepperoniToppings;
    
    
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"AvailableIngredients" inManagedObjectContext:managedObjectContext]];
    
    NSArray *availArray = [managedObjectContext executeFetchRequest:searchRequest error:nil];
    
    AvailableIngredients *availIngrediants;
    if ([availArray count] <= 0) {
        availIngrediants = (AvailableIngredients *) [NSEntityDescription insertNewObjectForEntityForName:@"AvailableIngredients" inManagedObjectContext:[self managedObjectContext]];
        availIngrediants.sausage = @5;
        availIngrediants.cheese = @5;
        availIngrediants.pepperoni = [NSNumber numberWithInt:5];

        [self resetPizzaInventoryLevels];
    
    }
    else
    {
        /*
        int cheeseTemp = availIngrediants.cheese;
        NSInteger *cheeseTemp2 = availIngrediants.cheeseToppings;
        
        NSInteger *cheeseTemp4 = cheeseToppings.integerValue;
        
        NSNumber *cheeseTemp3 = availIngrediants.cheeseToppings;
        NSInteger *sausageTemp = (availIngrediants.sausage.integerValue - sausageToppings.integerValue);
        NSArray *searchedArray = [managedObjectContext executeFetchRequest:searchRequest error:nil];
        availIngrediants = [searchedArray objectAtIndex:0];
        availIngrediants.cheese =
        availIngrediants.sausage =
        availIngrediants.pepperoni = (availIngrediants.pepperoni.integerValue - pepperoniToppings);
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
         */
    }

    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    
    
    return pizzaToBeBuilt;
}

-(Pizza *)createPizzaObject
{
    NSLog(@"%@", managedObjectContext);
    Pizza *newPizza = (Pizza *) [NSEntityDescription insertNewObjectForEntityForName:@"Pizza" inManagedObjectContext:[self managedObjectContext]];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];

    return newPizza;
}

@end
