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
    
    dispatch_once(&onceToken, ^
    {
        NSLog(@"Dispatch once");
        sMyData = [[CoreData alloc] init];
    });
    NSLog(@"returning coredata singleton = %@", sMyData);
    
    return sMyData;
}

-(id)init
{
    if (self = [super init])
    {
        NSLog(@"instantiating the singleton here: %@", self);
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
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSArray *placedOrderEntities = [context executeFetchRequest:fr error:nil];
    
    for (int x = 0; x < [placedOrderEntities count]; x++)
    {
        PlacedOrder *orderToDelete = [placedOrderEntities objectAtIndex:x];
        [context deleteObject:orderToDelete];
    }
}


-(NSInteger)summedTablesCheesesByTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"cheese"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesVeggiesByTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"veggie"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesBudweisersByTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"budweiser"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesCokesByTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"coke"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesSpritesByTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"sprite"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}


-(NSInteger)summedTablesSausageByTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"sausage"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesPepperoniByTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfAttribute"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"pepperoni"]]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfAttribute"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesPizzasByTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfPizzas"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObjects:[NSExpression expressionForKeyPath:@"cheese"], [NSExpression expressionForKeyPath:@"sausage"], [NSExpression expressionForKeyPath:@"veggie"], [NSExpression expressionForKeyPath:@"pepperoni"], nil]]];

    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfPizzas"] integerValue];
    
    return pizzaAttributeTotal;
}

-(NSInteger)summedTablesDrinksByTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderedFromTable = '%@'", tableName];
    
    fr.entity = [NSEntityDescription entityForName:@"PlacedOrder" inManagedObjectContext:context];
    fr.resultType = NSDictionaryResultType;
    [fr setPredicate:predicate];
    
    NSExpressionDescription *sumOfAttributes = [[NSExpressionDescription alloc] init];
    [sumOfAttributes setName:@"TotalOfDrinks"];
    [sumOfAttributes setExpression:[NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObjects:[NSExpression expressionForKeyPath:@"coke"], [NSExpression expressionForKeyPath:@"budweiser"], [NSExpression expressionForKeyPath:@"sprite"]
                                                                                          , nil]]];
    
    //is equal to the attribute "type" that you are trying to receive
    [sumOfAttributes setExpressionResultType:NSInteger16AttributeType];
    
    fr.propertiesToFetch = [NSArray arrayWithObject:sumOfAttributes];
    
    NSArray *pizzaTotalResults = [context executeFetchRequest:fr error:nil];
    
    NSDictionary *fetchResultsDictionary = [pizzaTotalResults objectAtIndex:0];
    
    NSInteger pizzaAttributeTotal = [[fetchResultsDictionary objectForKey:@"TotalOfDrinks"] integerValue];
    
    return pizzaAttributeTotal;
}

-(void)confirmTicketsByTableName:(NSString *)tableName
{
     ConfirmedOrder *confirmOrder = (ConfirmedOrder *)[NSEntityDescription insertNewObjectForEntityForName:@"ConfirmedOrder" inManagedObjectContext:[self managedObjectContext]];

    
    confirmOrder.sprite = [NSNumber numberWithInteger:[self summedTablesSpritesByTableName:tableName]];
    confirmOrder.coke = [NSNumber numberWithInteger:[self summedTablesCokesByTableName:tableName]];
    confirmOrder.budweiser = [NSNumber numberWithInteger:[self summedTablesBudweisersByTableName:tableName]];
    
    confirmOrder.cheese = [NSNumber numberWithInteger:[self summedTablesCheesesByTableName:tableName]];
    confirmOrder.sausage = [NSNumber numberWithInteger:[self summedTablesSausageByTableName:tableName]];
    confirmOrder.pepperoni = [NSNumber numberWithInteger:[self summedTablesPepperoniByTableName:tableName]];
    confirmOrder.veggie = [NSNumber numberWithInteger:[self summedTablesVeggiesByTableName:tableName]];
    confirmOrder.orderedFromTable = tableName;
    
    
    confirmOrder.timeOfOrder = [NSDate date];

    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    
    
    //need to also delete entities that it pulled from
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
    PlacedOrder *orderToBePlaced = (PlacedOrder *)[NSEntityDescription insertNewObjectForEntityForName:@"PlacedOrder" inManagedObjectContext:[self managedObjectContext]];
    
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
    
    if (!ingrediants.ticketNumber) {
        ingrediants.ticketNumber = @0;
    }
    ingrediants.ticketNumber = @([ingrediants.ticketNumber floatValue] + [@1 floatValue]);
    
    orderToBePlaced.ticketNumber = ingrediants.ticketNumber;
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
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



-(void)parseSaveConfirmedOrders
{
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"ConfirmedOrder" inManagedObjectContext:managedObjectContext]];
    
    NSArray *matchedObjects = [managedObjectContext executeFetchRequest:searchRequest error:nil];
    //creates a list of ALL pizzas created, would work well for a list of all pizzas made/sold but need it to show only ONE pizza, fix later

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
        
        [confirmedOrder saveEventually];
    }
    
}


-(NSArray *)fetchMenuItems
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MenuItemData" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    fetchRequest.entity = entityDescription;
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    return results;
    
}


-(NSArray *)fetchUIItems
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"UIItemData" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    fetchRequest.entity = entityDescription;
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    return results;
    
    
}

-(Pizza *)createPizzaObject
{
    NSLog(@"%@", managedObjectContext);
    Pizza *newPizza = (Pizza *) [NSEntityDescription insertNewObjectForEntityForName:@"Pizza" inManagedObjectContext:[self managedObjectContext]];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    
    return newPizza;
}

/*
 [[CoreData myData] parentName:@"" name:@"" titleToDisplay:@"UIFILTER" imageLocation:@"" type:@"UIFilter" localIDNumber:@"" instanceOf:@"" destination:@"" receives:@"nothing ever" restaurant:@"ALWAYS SHOW" table:@"ALWAYS SHOW" customer:@"ALWAYS SHOW" filterRestaurant:@"lklkj" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:FALSE isSeated:FALSE filterIsSeated:FALSE defaultPositionX:100 defaultPositionY:200 buildMode:@0];
 
 [[CoreData myData] parentName:@"" name:@"" titleToDisplay:@"UIDESTINATION" imageLocation:@"" type:@"UIDestination" localIDNumber:@"" instanceOf:@"" destination:@"" receives:@"ALL" restaurant:@"ALWAYS SHOW" table:@"ALWAYS SHOW" customer:@"ALWAYS SHOW" filterRestaurant:@"kjhkjh" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:FALSE isSeated:FALSE filterIsSeated:FALSE defaultPositionX:100 defaultPositionY:300 buildMode:@0];
 
 // ??? SHOULD HARD CODE IT SO CAN'T GIVE A FILTER A DESTINATION
 
 [[CoreData myData] parentName:@"Main Menu" name:@"Coke" titleToDisplay:@"COKE?" imageLocation:@"" type:@"MenuItem" localIDNumber:@"" instanceOf:@"" destination:@"" receives:@"ALL" restaurant:@"ALWAYS SHOW" table:@"ALWAYS SHOW" customer:@"ALWAYS SHOW" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:FALSE isSeated:FALSE filterIsSeated:FALSE defaultPositionX:100 defaultPositionY:500 buildMode:@0];
 
 
 
 
 
 NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
 
 NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
 [searchRequest setEntity:[NSEntityDescription entityForName:@"MenuItemData" inManagedObjectContext:context]];
 
 NSArray *menuArray2 = [context executeFetchRequest:searchRequest error:nil];
 
 // filter data (STUPID FIX)
 NSMutableArray *menuArray = [NSMutableArray new];
 
 for(int x = 0; x<[menuArray2 count]; x++){
 
 if([ [(MenuItemData *)[menuArray2 objectAtIndex:x] type] isEqualToString:@"MenuItem"] || [[(MenuItemData *)[menuArray2 objectAtIndex:x] type] isEqualToString:@"MenuBranch"])
 {
 
 [menuArray addObject:[menuArray2 objectAtIndex:x]];
 }
 
 }
 
 
 
 
 NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
 
 NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
 [searchRequest setEntity:[NSEntityDescription entityForName:@"MenuItemData" inManagedObjectContext:context]];
 
 NSArray *MenuArray2 = [context executeFetchRequest:searchRequest error:nil];
 
 // filter data (STUPID FIX)
 NSMutableArray *MenuArray = [NSMutableArray new];
 
 for(int x = 0; x<[MenuArray2 count]; x++){
 
 if([ [(MenuItemData *)[MenuArray2 objectAtIndex:x] type] isEqualToString:@"UIFilter"] || [[(MenuItemData *)[MenuArray2 objectAtIndex:x] type] isEqualToString:@"UIDestination"])
 {
 
 [MenuArray addObject:[MenuArray2 objectAtIndex:x]];
 }
 
 
 }
 
 
 
 
 
 */

@end
