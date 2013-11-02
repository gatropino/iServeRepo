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
#import "MenuItemData.h"
#import "UIItemData.h"
#import "PlacedOrder.h"

@interface CoreData : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

+(CoreData *) myData;
-(void)resetPizzaInventoryLevels;
-(NSArray *)fetchAllPizzasMade;

-(void)deletePlacedOrderEntitiesByTableName:(NSString *)tableName;

-(NSInteger)summedTablesCheesesByTableName:(NSString *)tableName;
-(NSInteger)summedTablesSausageByTableName:(NSString *)tableName;
-(NSInteger)summedTablesPepperoniByTableName:(NSString *)tableName;
-(NSInteger)summedTablesVeggiesByTableName:(NSString *)tableName;
-(NSInteger)summedTablesBudweisersByTableName:(NSString *)tableName;
-(NSInteger)summedTablesCokesByTableName:(NSString *)tableName;
-(NSInteger)summedTablesSpritesByTableName:(NSString *)tableName;
-(NSInteger)summedTablesPizzasByTableName:(NSString *)tableName;
-(NSInteger)summedTablesDrinksByTableName:(NSString *)tableName;

-(NSArray *)attributesOfPizza;
-(Pizza *)quantityOfCheese:(NSNumber *)cheeseToppings quantityOfSausage:(NSNumber *)sausageToppings quantityOfPepperoni:(NSNumber *)pepperoniToppings;
-(Pizza *)createPizzaObject;
-(NSArray *)fetchMenuItems;
-(NSArray *)fetchUIItems;
-(AvailableIngredients *)getAvailableIngrediants;
-(void)placeOrderWithArray:(NSMutableArray *)mutableArray;
-(NSArray *)fetchOrders;

-(MenuItemData *)makeNewUIItem_parentName:(NSString *)parentName name:(NSString *)name titleToDisplay:(NSString *)titleToDisplay imageLocation:(NSString *)imageLocation type:(NSString *)type localIDNumber:(NSString *)localIDNumber instanceOf:(NSString *)instanceOf destination:(NSString *)destination receives:(NSString *)receives restaurant:(NSString *)restaurant table:(NSString *)table customer:(NSString *)customer filterRestaurant:(NSString *)filterRestaurant filterTable:(NSString *)filterTable filterCustomer:(NSString *)filterCustomer isSelected:(BOOL)isSelected canDrag:(BOOL)canDrag placeInstancesInHorizontalLine:(BOOL)placeInstancesInHorizontalLine isSeated:(BOOL)isSeated filterIsSeated:(BOOL)filterIsSeated defaultPositionX:(float)defaultPositionX defaultPositionY:(float)defaultPositionY buildMode:(NSNumber *)buildMode;
-(MenuItemData *)makeNewMenuItemFromData_parentName:(NSString *)parentName name:(NSString *)name titleToDisplay:(NSString *)titleToDisplay imageLocation:(NSString *)imageLocation type:(NSString *)type localIDNumber:(NSString *)localIDNumber instanceOf:(NSString *)instanceOf destination:(NSString *)destination receives:(NSString *)receives restaurant:(NSString *)restaurant table:(NSString *)table customer:(NSString *)customer filterRestaurant:(NSString *)filterRestaurant filterTable:(NSString *)filterTable filterCustomer:(NSString *)filterCustomer isSelected:(BOOL)isSelected canDrag:(BOOL)canDrag placeInstancesInHorizontalLine:(BOOL)placeInstancesInHorizontalLine isSeated:(BOOL)isSeated filterIsSeated:(BOOL)filterIsSeated defaultPositionX:(float)defaultPositionX defaultPositionY:(float)defaultPositionY buildMode:(NSNumber *)buildMode;

@end
