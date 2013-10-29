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



-(void)ParseSaveObject:(id)ObjectToSave
{
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
    
    NSLog(@"passed parse");

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
