//
//  RootViewController.m
//  iServe
//
//  Created by Greg Tropino on 10/23/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //for being able to call my individual methods in core data for testing, don't touch!!
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CoreDataTesting" object:nil];
    [[CoreData myData] createPizzaObject];
    
    [[CoreData myData] quantityOfCheese:@3 quantityOfSausage:@0 quantityOfPepperoni:@0];
    
    self.view.layer.cornerRadius = 15;
    
    /*
    //tested and works
    
     //Gives back an NSInteger of how many cheese pizzas have been sold, works same for totalPepperoniPizzasSold and totalSausagePizzasSold
     NSInteger tempTotal = [[CoreData myData] totalCheesePizzasSold];
     NSLog(@"%ld", (long)tempTotal);

    //brings values of all ingrediants levels to 5
    [[CoreData myData] resetPizzaInventoryLevels];
    
    //creates a blank pizza managed object, no ingrediants
    [[CoreData myData] createPizzaObject];

    //creating a pizza with values for ingrediants, only need tempPizza holder if you need to get values out of it
    //need to deduct from available ingrediants list
    Pizza *tempPizza = [[CoreData myData] quantityOfCheese:@1 quantityOfSausage:@0 quantityOfPepperoni:@0];
    NSLog(@"%@", tempPizza.cheese);
    
    //brings back an array of all the pizzas that have been made
    [[CoreData myData] fetchAllPizzasMade];
    */
}


@end
