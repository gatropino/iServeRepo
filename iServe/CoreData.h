//
//  CoreData.h
//  iServe
//
//  Created by Greg Tropino on 10/23/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
#import "Pizza.h"
#import "AvailableIngredients.h"
#import "AppDelegate.h"
#import "Images.h"

@interface CoreData : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

+(CoreData *) myData;
-(void)resetPizzaInventoryLevels;
-(NSArray *)fetchAllPizzasMade;
-(NSInteger)totalCheesePizzasSold;
-(NSInteger)totalSausagePizzasSold;
-(NSInteger)totalPepperoniPizzasSold;
-(NSArray *)attributesOfPizza;
-(Pizza *)quantityOfCheese:(NSNumber *)cheeseToppings quantityOfSausage:(NSNumber *)sausageToppings quantityOfPepperoni:(NSNumber *)pepperoniToppings;
-(Pizza *)createPizzaObject;

@end
