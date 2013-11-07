//
//  CoreData.m
//  iServe
//
//  Created by Greg Tropino on 10/23/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "CoreData.h"
#import "MenuItemCell.h"
#import "ConfirmedOrder.h"

@implementation CoreData
static CoreData* sMyData;
id observer2;

@synthesize fetchedResultsController, managedObjectContext, cokePrice, spritePrice, budweiserPrice, cheesePrice, sausagePrice, pepperoniPrice, veggiePrice;

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
    
    dispatch_once(&onceToken, ^
    {
        NSLog(@"Dispatch once");
        sMyData = [[CoreData alloc] init];
    });
    return sMyData;
}

-(id)init
{
    if (self = [super init])
    {
        NSLog(@"instantiating the singleton here: %@", self);
        managedObjectContext = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"init context %@", managedObjectContext);
        spritePrice = @1.50;
        cokePrice = @1.50;
        budweiserPrice = @4.50;
        cheesePrice = @9.50;
        pepperoniPrice = @11.50;
        sausagePrice = @11.50;
        veggiePrice = @12.50;
    }
    return self;
}

-(void)resetPizzaInventoryLevels
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"AvailableIngredients" inManagedObjectContext:managedObjectContext]];
    
    NSArray *availArray = [managedObjectContext executeFetchRequest:searchRequest error:nil];
    
    if ([availArray count] <= 0)
    {
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

-(AvailableIngredients *)getAvailableIngrediants
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"AvailableIngredients" inManagedObjectContext:managedObjectContext]];
    
    NSArray *availArray = [managedObjectContext executeFetchRequest:searchRequest error:nil];
    
    if ([availArray count] <= 0)
    {
        AvailableIngredients *availIngredients = (AvailableIngredients *) [NSEntityDescription insertNewObjectForEntityForName:@"AvailableIngredients" inManagedObjectContext:[self managedObjectContext]];
        availIngredients.sausage = @5;
        availIngredients.cheese = @5;
        availIngredients.pepperoni = [NSNumber numberWithInt:5];  //same as @5
        availIngredients.localIDNumber = @1;
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
        return availIngredients;
    }
    else
    {
        NSArray *searchedArray = [managedObjectContext executeFetchRequest:searchRequest error:nil];
        AvailableIngredients *ingredients = [searchedArray objectAtIndex:0];
        return ingredients;
    }
}

-(int)assignLocalIDNumber
{
    AvailableIngredients *ingrediants = [self getAvailableIngrediants];
    
    if (!ingrediants.confirmedTicketNumber)
    {
        ingrediants.confirmedTicketNumber = @1;
    }
    ingrediants.confirmedTicketNumber = @([ingrediants.confirmedTicketNumber floatValue] + [@1 floatValue]);
    
    int newLocalIDNumber = [ingrediants.confirmedTicketNumber intValue];

    return newLocalIDNumber;
}

-(NSArray *)fetchAllPizzasMade
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"Food" inManagedObjectContext:managedObjectContext]];
    
    NSArray *matchedObjects = [managedObjectContext executeFetchRequest:searchRequest error:nil];
    //creates a list of ALL pizzas created, would work well for a list of all pizzas made/sold but need it to show only ONE pizza, fix later
    return matchedObjects;
}

-(void)deletePlacedOrderEntitiesByTableName:(NSString *)tableName
{
    NSLog(@"deletePlacedOrders context %@", managedObjectContext);
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    [fr setPredicate:predicate];
    [fr setResultType:NSManagedObjectIDResultType];
    
    NSError *error;
    NSArray *placedOrderEntities = [managedObjectContext executeFetchRequest:fr error:&error];
    NSLog(@"%@", error);

    for (NSManagedObjectID *order in placedOrderEntities)
    {
        [managedObjectContext deleteObject:[managedObjectContext objectWithID:order]];
    }
    //[managedObjectContext save:&error];
    /*
    for (int x = 0; x < [placedOrderEntities count]; x++)
    {
        PlacedOrder *orderToDelete = [placedOrderEntities objectAtIndex:x];
        [managedObjectContext deleteObject:orderToDelete];
    }
    */
    
}

-(void)deleteUIItemDataEntitiesByTableName:(NSString *)tableName
{
    NSLog(@"deletePlacedOrders context %@", managedObjectContext);
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localIDNumber MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"UIItemData" inManagedObjectContext:managedObjectContext];
    [fr setPredicate:predicate];
    [fr setResultType:NSManagedObjectIDResultType];
    
    NSError *error;
    NSArray *UIItemDataEntitiesArray = [managedObjectContext executeFetchRequest:fr error:&error];
    
    for (NSManagedObjectID *order in UIItemDataEntitiesArray)
    {
        NSLog(@"%@", order);
        
        [managedObjectContext deleteObject:[managedObjectContext objectWithID:order]];
    }
    //[managedObjectContext save:&error];
    
}

-(void)updateUIItemDataEntitiesByTableName:(NSString *)tableName defaultPositionX:(float)defaultPositionX defaultPositionY:(float)defaultPositionY titleToDisplay:(NSString*)titleToDisplay imageLocation:(NSString *)imageLocation
{
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localIDNumber MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"UIItemData" inManagedObjectContext:managedObjectContext];
    [fr setPredicate:predicate];
    
    NSError *error;
    NSArray *itemDataEntitiesArray = [managedObjectContext executeFetchRequest:fr error:&error];
    NSLog(@"%@", error);
    
    for (UIItemData *data in itemDataEntitiesArray)
    {
        data.defaultPositionX = [NSNumber numberWithFloat:defaultPositionX];
        data.defaultPositionY = [NSNumber numberWithFloat:defaultPositionY];
        data.titleToDisplay = titleToDisplay;
        data.imageLocation = imageLocation;
    }
    
    [managedObjectContext save:&error];
    
    NSLog(@"%@", error);
}


-(NSInteger)summedTablesCheesesByTableName:(NSString *)tableName
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"cheese"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [managedObjectContext executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesVeggiesByTableName:(NSString *)tableName
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"veggie"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [managedObjectContext executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesBudweisersByTableName:(NSString *)tableName
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"budweiser"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [managedObjectContext executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesCokesByTableName:(NSString *)tableName
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"coke"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [managedObjectContext executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesSpritesByTableName:(NSString *)tableName
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"sprite"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [managedObjectContext executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}


-(NSInteger)summedTablesSausageByTableName:(NSString *)tableName
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"sausage"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [managedObjectContext executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesPepperoniByTableName:(NSString *)tableName
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"pepperoni"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [managedObjectContext executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesPizzasByTableName:(NSString *)tableName
{
    //doesnt work for some reason, must be related to multiple sum operators
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable MATCHES[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfPizzas"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObjects:[NSExpression expressionForKeyPath:@"cheese"], [NSExpression expressionForKeyPath:@"sausage"], [NSExpression expressionForKeyPath:@"veggie"], [NSExpression expressionForKeyPath:@"pepperoni"], nil]]];

    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [managedObjectContext executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfPizzas"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesDrinksByTableName:(NSString *)tableName
{
    //doesnt work for some reason, must be related to multiple sum operators
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable CONTAINS[cd] %@", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfDrinks"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObjects:[NSExpression expressionForKeyPath:@"coke"], [NSExpression expressionForKeyPath:@"budweiser"], [NSExpression expressionForKeyPath:@"sprite"]
                                                                                          , nil]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [managedObjectContext executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfDrinks"] integerValue];
    
    return pizzaAttributeTotal;
}

-(void)confirmTicketsByTableName:(NSString *)tableName
{
    NSNumber *doorKeeper = @([self summedTablesSpritesByTableName:tableName] + [self summedTablesSpritesByTableName:tableName] + [self summedTablesBudweisersByTableName:tableName] + [self summedTablesCheesesByTableName:tableName] + [self summedTablesPepperoniByTableName:tableName] + [self summedTablesVeggiesByTableName:tableName]);
    int allItemsInOrders = [doorKeeper intValue];
    
    if (allItemsInOrders > 0)
    {
        ConfirmedOrder *confirmOrder = (ConfirmedOrder *)[NSEntityDescription insertNewObjectForEntityForName:@"ConfirmedOrder" inManagedObjectContext:managedObjectContext];
        
        confirmOrder.sprite = [NSNumber numberWithInteger:[self summedTablesSpritesByTableName:tableName]];
        confirmOrder.coke = [NSNumber numberWithInteger:[self summedTablesSpritesByTableName:tableName]];
        confirmOrder.budweiser = [NSNumber numberWithInteger:[self summedTablesBudweisersByTableName:tableName]];
        confirmOrder.totalDrinks = @([confirmOrder.sprite floatValue] + [confirmOrder.coke floatValue] + [confirmOrder.budweiser floatValue]);
        
        confirmOrder.cheese = [NSNumber numberWithInteger:[self summedTablesCheesesByTableName:tableName]];
        confirmOrder.sausage = [NSNumber numberWithInteger:[self summedTablesSausageByTableName:tableName]];
        confirmOrder.pepperoni = [NSNumber numberWithInteger:[self summedTablesPepperoniByTableName:tableName]];
        confirmOrder.veggie = [NSNumber numberWithInteger:[self summedTablesVeggiesByTableName:tableName]];
        confirmOrder.totalPizzas = @([confirmOrder.cheese floatValue] + [confirmOrder.sausage floatValue] + [confirmOrder.pepperoni floatValue] + [confirmOrder.veggie floatValue]);
        
        confirmOrder.orderedFromTable = tableName;
        confirmOrder.uploaded = [NSNumber numberWithBool:NO];
        
        AvailableIngredients *ingrediants = [self getAvailableIngrediants];
        
        if (!ingrediants.confirmedTicketNumber) {
            ingrediants.confirmedTicketNumber = @0;
        }
        ingrediants.confirmedTicketNumber = @([ingrediants.confirmedTicketNumber floatValue] + [@1 floatValue]);
        
        confirmOrder.ticketNumber = ingrediants.confirmedTicketNumber;
        
        confirmOrder.timeOfOrder = [NSDate date];
        
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
        
        [self deletePlacedOrderEntitiesByTableName:tableName];
        
        [self parseSaveConfirmedOrders];
    }
    
    
}

-(NSArray *)attributesOfPizza
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pizza" inManagedObjectContext:managedObjectContext];
    
    NSLog(@"%@", entity.properties); //shows a list of ALL the attributes of the entity
    NSLog(@"%@", entity.name); //gets the name of the actual entity
    
    return entity.properties;
}

-(void)placeOrderWithArray:(NSMutableArray *)mutableArray
{
    
    int coke = 0, sprite = 0, cheese = 0, pepperoni = 0, veggie = 0, budweiser = 0, sausage = 0;
    NSString *tempTableString;
    for (int x = 0; x < [mutableArray count]; x++)
    {
        MenuItemCell *tempMenuItemCell = [mutableArray objectAtIndex:x];
        if ([tempMenuItemCell.titleToDisplay isEqualToString:@"Coke"])
        {
            coke++;
        }
        else if ([tempMenuItemCell.titleToDisplay isEqualToString:@"Sprite"])
        {
            sprite++;
        }
        else if ([tempMenuItemCell.titleToDisplay isEqualToString:@"Budweiser"])
        {
            budweiser++;
        }
        else if ([tempMenuItemCell.titleToDisplay isEqualToString:@"Cheese Pizza"])
        {
            cheese++;
        }
        else if ([tempMenuItemCell.titleToDisplay isEqualToString:@"Pepperoni Pizza"])
        {
            pepperoni++;
        }
        else if ([tempMenuItemCell.titleToDisplay isEqualToString:@"Veggie Pizza"])
        {
            veggie++;
        }
        else if ([tempMenuItemCell.titleToDisplay isEqualToString:@"Sausage Pizza"])
        {
            sausage++;
        }
        else
        {
            NSLog(@"Didn't find a titleToDisplay that is equal to %@", tempMenuItemCell.titleToDisplay);
        }

        tempTableString = tempMenuItemCell.table;
    }
    int allOrderedItems = coke + sprite + budweiser + cheese + pepperoni + veggie + sausage;
    
    if (allOrderedItems > 0)
    {
        PlacedOrder *orderToBePlaced = (PlacedOrder *)[NSEntityDescription insertNewObjectForEntityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext];
        
        orderToBePlaced.cheese = [NSNumber numberWithInt:cheese];
        orderToBePlaced.sausage = [NSNumber numberWithInt:sausage];
        orderToBePlaced.pepperoni = [NSNumber numberWithInt:pepperoni];
        orderToBePlaced.sprite = [NSNumber numberWithInt:sprite];
        orderToBePlaced.coke = [NSNumber numberWithInt:coke];
        orderToBePlaced.veggie = [NSNumber numberWithInt:veggie];
        orderToBePlaced.budweiser = [NSNumber numberWithInt:budweiser];
        
        orderToBePlaced.orderedFromTable = tempTableString;
        NSLog(@"%@", orderToBePlaced.orderedFromTable);
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSLog(@"%@",[DateFormatter stringFromDate:[NSDate date]]);
        
        orderToBePlaced.timeOfOrder = [NSDate date];
        
        AvailableIngredients *ingrediants = [self getAvailableIngrediants];
        
        if (!ingrediants.ticketNumber)
        {
            ingrediants.ticketNumber = @0;
        }
        ingrediants.ticketNumber = @([ingrediants.ticketNumber floatValue] + [@1 floatValue]);
        
        orderToBePlaced.ticketNumber = ingrediants.ticketNumber;
        
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    }
}

-(NSArray *)fetchOrders
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:managedObjectContext]];
    
    NSArray *matchedObjects = [managedObjectContext executeFetchRequest:searchRequest error:nil];
    //creates a list of ALL pizzas created, would work well for a list of all pizzas made/sold but need it to show only ONE pizza, fix later
    return matchedObjects;
}

-(Pizza *)quantityOfCheese:(NSNumber *)cheeseToppings quantityOfSausage:(NSNumber *)sausageToppings quantityOfPepperoni:(NSNumber *)pepperoniToppings
{
    Pizza *pizzaToBeBuilt;
    
    pizzaToBeBuilt = (Pizza *)[NSEntityDescription insertNewObjectForEntityForName:@"Pizza" inManagedObjectContext:[self managedObjectContext]];
    
    pizzaToBeBuilt.cheese = cheeseToppings;
    pizzaToBeBuilt.sausage = sausageToppings;
    pizzaToBeBuilt.pepperoni= pepperoniToppings;
    
    AvailableIngredients *availIngrediants = [self getAvailableIngrediants];
    
    availIngrediants.cheese = @([availIngrediants.cheese floatValue] - [cheeseToppings floatValue]);
    availIngrediants.sausage = @([availIngrediants.sausage floatValue] - [sausageToppings floatValue]);
    availIngrediants.pepperoni = @([availIngrediants.pepperoni floatValue] - [pepperoniToppings floatValue]);
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    
    return pizzaToBeBuilt;
}

-(MenuItemData *)makeNewMenuItemFromData_parentName:(NSString *)parentName name:(NSString *)name titleToDisplay:(NSString *)titleToDisplay imageLocation:(NSString *)imageLocation type:(NSString *)type localIDNumber:(NSString *)localIDNumber instanceOf:(NSString *)instanceOf destination:(NSString *)destination receives:(NSString *)receives restaurant:(NSString *)restaurant table:(NSString *)table customer:(NSString *)customer filterRestaurant:(NSString *)filterRestaurant filterTable:(NSString *)filterTable filterCustomer:(NSString *)filterCustomer isSelected:(BOOL)isSelected canDrag:(BOOL)canDrag placeInstancesInHorizontalLine:(BOOL)placeInstancesInHorizontalLine isSeated:(BOOL)isSeated filterIsSeated:(BOOL)filterIsSeated defaultPositionX:(float)defaultPositionX defaultPositionY:(float)defaultPositionY buildMode:(NSNumber *)buildMode
{
    MenuItemData *menu = (MenuItemData *) [NSEntityDescription insertNewObjectForEntityForName:@"MenuItemData" inManagedObjectContext:[self managedObjectContext]];
    
    menu.parentName = parentName;
    menu.name = name;
    menu.titleToDisplay = titleToDisplay;
    menu.imageLocation = imageLocation;
    menu.type = type;
    menu.localIDNumber = localIDNumber;
    menu.instanceOf = instanceOf;
    menu.destination = destination;
    menu.receives = receives;
    menu.restaurant = restaurant;
    menu.table = table;
    menu.customer = customer;
    menu.filterRestaurant = filterRestaurant;
    menu.filterTable = filterTable;
    menu.filterCustomer = filterCustomer;
    menu.isSelected = [NSNumber numberWithBool:isSelected];
    menu.canDrag = [NSNumber numberWithBool:canDrag];
    menu.placeInstancesInHorizontalLine = [NSNumber numberWithBool:placeInstancesInHorizontalLine];
    menu.isSeated = [NSNumber numberWithBool:isSeated];
    menu.filterIsSeated = [NSNumber numberWithBool:filterIsSeated];
    menu.defaultPositionX = [NSNumber numberWithFloat:defaultPositionX];
    menu.defaultPositionY = [NSNumber numberWithFloat:defaultPositionY];
    menu.buildMode = buildMode;
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    
    return menu;
}

-(MenuItemData *)makeNewUIItem_parentName:(NSString *)parentName name:(NSString *)name titleToDisplay:(NSString *)titleToDisplay imageLocation:(NSString *)imageLocation type:(NSString *)type localIDNumber:(NSString *)localIDNumber instanceOf:(NSString *)instanceOf destination:(NSString *)destination receives:(NSString *)receives restaurant:(NSString *)restaurant table:(NSString *)table customer:(NSString *)customer filterRestaurant:(NSString *)filterRestaurant filterTable:(NSString *)filterTable filterCustomer:(NSString *)filterCustomer isSelected:(BOOL)isSelected canDrag:(BOOL)canDrag placeInstancesInHorizontalLine:(BOOL)placeInstancesInHorizontalLine isSeated:(BOOL)isSeated filterIsSeated:(BOOL)filterIsSeated defaultPositionX:(float)defaultPositionX defaultPositionY:(float)defaultPositionY buildMode:(NSNumber *)buildMode
{
    MenuItemData *menu = (MenuItemData *) [NSEntityDescription insertNewObjectForEntityForName:@"UIItemData" inManagedObjectContext:[self managedObjectContext]];
    
    menu.parentName = parentName;
    menu.name = name;
    menu.titleToDisplay = titleToDisplay;
    menu.imageLocation = imageLocation;
    menu.type = type;
    menu.localIDNumber = localIDNumber;
    menu.instanceOf = instanceOf;
    menu.destination = destination;
    menu.receives = receives;
    menu.restaurant = restaurant;
    menu.table = table;
    menu.customer = customer;
    menu.filterRestaurant = filterRestaurant;
    menu.filterTable = filterTable;
    menu.filterCustomer = filterCustomer;
    menu.isSelected = [NSNumber numberWithBool:isSelected];
    menu.canDrag = [NSNumber numberWithBool:canDrag];
    menu.placeInstancesInHorizontalLine = [NSNumber numberWithBool:placeInstancesInHorizontalLine];
    menu.isSeated = [NSNumber numberWithBool:isSeated];
    menu.filterIsSeated = [NSNumber numberWithBool:filterIsSeated];
    menu.defaultPositionX = [NSNumber numberWithFloat:defaultPositionX];
    menu.defaultPositionY = [NSNumber numberWithFloat:defaultPositionY];
    menu.buildMode = buildMode;
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];

    return menu;
}

-(void)parseLoadConfirmedOrders
{
    NSString *uniqueID = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] identifierForVendor]];
    NSLog(@"%@", [[UIDevice currentDevice] identifierForVendor]);
    
    AvailableIngredients *ingrediants = [self getAvailableIngrediants];
    if (!ingrediants.confirmedTicketNumber)
    {
        ingrediants.confirmedTicketNumber = @0;
    }
   // NSString *createdAt = [NSString stringWithFormat:@"%@", ingrediants.createdAt];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ConfirmedOrder"];
    [query whereKey:@"uniqueIdentity" notEqualTo:uniqueID];
    //[query whereKey:@"createdAt" greaterThan:createdAt];  //comparison not working properly, must FIX!!
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu completed orders.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects)
            {
                ingrediants.createdAt = object.createdAt;
            
                int sprite = [[object objectForKey:@"sprite"] intValue];
                int coke = [[object objectForKey:@"coke"] intValue];
                int budweiser = [[object objectForKey:@"budweiser"] intValue];
                int totalDrinks = [[object objectForKey:@"totalDrinks"] intValue];

                int cheese = [[object objectForKey:@"cheese"] intValue];
                int pepperoni = [[object objectForKey:@"pepperoni"] intValue];
                int sausage = [[object objectForKey:@"sausage"] intValue];
                int veggie = [[object objectForKey:@"veggie"] intValue];
                int totalPizzas = [[object objectForKey:@"totalPizzas"] intValue];
                
                ConfirmedOrder *confirmOrder = (ConfirmedOrder *)[NSEntityDescription insertNewObjectForEntityForName:@"ConfirmedOrder" inManagedObjectContext:managedObjectContext];
                
                ingrediants.confirmedTicketNumber = @([ingrediants.confirmedTicketNumber floatValue] + [@1 floatValue]);
                
                //converting string into date
                NSString *dateString = object[@"timeOfOrder"];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                NSDate *date = [dateFormat dateFromString:[dateString stringByReplacingOccurrencesOfString:@" +0000" withString:@""]];
                
                confirmOrder.ticketNumber = ingrediants.confirmedTicketNumber;
                confirmOrder.timeOfOrder = date;  //not converting properly, must FIX!!
                confirmOrder.sprite = [NSNumber numberWithInt:sprite];
                confirmOrder.coke = [NSNumber numberWithInt:coke];
                confirmOrder.budweiser = [NSNumber numberWithInt:budweiser];
                confirmOrder.totalDrinks = [NSNumber numberWithInt:totalDrinks];
                
                confirmOrder.cheese = [NSNumber numberWithInt:cheese];
                confirmOrder.sausage = [NSNumber numberWithInt:sausage];
                confirmOrder.pepperoni = [NSNumber numberWithInt:pepperoni];
                confirmOrder.veggie = [NSNumber numberWithInt:veggie];
                confirmOrder.totalPizzas = [NSNumber numberWithInt:totalPizzas];
                
                confirmOrder.orderedFromTable = object[@"orderedFromTable"];
                
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
                
                NSLog(@"%@", object.objectId);
            }
        } else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)parseSaveConfirmedOrders
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"ConfirmedOrder" inManagedObjectContext:managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded != 1"];
    [searchRequest setPredicate:predicate];
    
    NSArray *matchedObjects = [managedObjectContext executeFetchRequest:searchRequest error:nil];

    for (ConfirmedOrder *order in matchedObjects)
    {
        PFObject *confirmedOrder = [PFObject objectWithClassName:@"ConfirmedOrder"];
        
        confirmedOrder[@"coke"] = [NSString stringWithFormat:@"%@", order.coke];
        confirmedOrder[@"sprite"] = [NSString stringWithFormat:@"%@", order.sprite];
        confirmedOrder[@"budweiser"] = [NSString stringWithFormat:@"%@", order.budweiser];
        confirmedOrder[@"totalDrinks"] = [NSString stringWithFormat:@"%@", order.totalDrinks];
        
        confirmedOrder[@"cheese"] = [NSString stringWithFormat:@"%@", order.cheese];
        confirmedOrder[@"pepperoni"] = [NSString stringWithFormat:@"%@", order.pepperoni];
        confirmedOrder[@"sausage"] = [NSString stringWithFormat:@"%@", order.sausage];
        confirmedOrder[@"veggie"] = [NSString stringWithFormat:@"%@", order.veggie];
        confirmedOrder[@"totalPizzas"] = [NSString stringWithFormat:@"%@", order.totalPizzas];
        
        confirmedOrder[@"timeOfOrder"] = [NSString stringWithFormat:@"%@", order.timeOfOrder];
        confirmedOrder[@"ticketNumber"] = [NSString stringWithFormat:@"%@", order.ticketNumber];
        confirmedOrder[@"orderedFromTable"] = [NSString stringWithFormat:@"%@", order.orderedFromTable];
        confirmedOrder[@"uniqueIdentity"] = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        order.uploaded = [NSNumber numberWithBool:YES];
        
        [confirmedOrder saveEventually];
    }
}


-(NSArray *)fetchMenuItems
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MenuItemData" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    fetchRequest.entity = entityDescription;
    
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return results;
}


-(NSArray *)fetchUIItems
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"UIItemData" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    fetchRequest.entity = entityDescription;
    
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return results;
}

-(Pizza *)createPizzaObject
{
    NSLog(@"%@", managedObjectContext);
    Pizza *newPizza = (Pizza *) [NSEntityDescription insertNewObjectForEntityForName:@"Pizza" inManagedObjectContext:[self managedObjectContext]];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    
    return newPizza;
}


@end
