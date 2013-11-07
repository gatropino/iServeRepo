//
//  ViewSingleOrderViewController.m
//  iServe
//
//  Created by Greg Tropino on 10/30/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "ViewSingleOrderViewController.h"
#import "CoreData.h"

@interface ViewSingleOrderViewController ()

@end

@implementation ViewSingleOrderViewController

@synthesize currentOrder, timeLabel, ticketNumberLabel, textView, tableLabel, quantityTotalLabel, dollarTotalLabel, taxTotalLabel, grandTotalLabel;


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
    NSString *temp1, *temp2, *temp3, *temp4, *temp5, *temp6, *temp7;
    
    NSDate *passedDate = currentOrder.timeOfOrder;
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSLog(@"%@",[DateFormatter stringFromDate:passedDate]);
    
    timeLabel.text = [DateFormatter stringFromDate:passedDate];
    tableLabel.text = currentOrder.orderedFromTable;
    ticketNumberLabel.text = [NSString stringWithFormat:@"%@", currentOrder.ticketNumber];
    
    NSNumber *total = @([currentOrder.cheese floatValue] + [currentOrder.pepperoni floatValue] + [currentOrder.sausage floatValue] + [currentOrder.coke floatValue] + [currentOrder.sprite floatValue] + [currentOrder.budweiser floatValue] + [currentOrder.veggie floatValue]);
    quantityTotalLabel.text = [NSString stringWithFormat:@"%@", total];
    
    NSNumber *cheeseTotal = @([currentOrder.cheese floatValue] * [[CoreData myData].cheesePrice floatValue]);
    NSNumber *pepperoniTotal = @([currentOrder.pepperoni floatValue] * [[CoreData myData].pepperoniPrice floatValue]);
    NSNumber *sausageTotal = @([currentOrder.sausage floatValue] * [[CoreData myData].sausagePrice floatValue]);
    NSNumber *veggieTotal = @([currentOrder.veggie floatValue] * [[CoreData myData].veggiePrice floatValue]);
    NSNumber *spriteTotal = @([currentOrder.sprite floatValue] * [[CoreData myData].spritePrice floatValue]);
    NSNumber *cokeTotal = @([currentOrder.coke floatValue] * [[CoreData myData].cokePrice floatValue]);
    NSNumber *budweiserTotal = @([currentOrder.budweiser floatValue] * [[CoreData myData].budweiserPrice floatValue]);
    
    NSNumber *grandTotal = @([cheeseTotal floatValue] + [pepperoniTotal floatValue] + [sausageTotal floatValue] + [veggieTotal floatValue] + [spriteTotal floatValue] + [cokeTotal floatValue] + [budweiserTotal floatValue]);

    if (currentOrder.cheese.intValue > 0) {
        temp1 = [NSString stringWithFormat:@"   Pizza:           Cheese          %@               %@             %@\n", currentOrder.cheese, [CoreData myData].cheesePrice, cheeseTotal];
    }
    if (currentOrder.pepperoni.intValue > 0) {
        temp2 = [NSString stringWithFormat:@"   Pizza:           Pepperoni      %@              %@           %@\n", currentOrder.pepperoni, [CoreData myData].pepperoniPrice, pepperoniTotal];
    }
    if (currentOrder.sausage.intValue > 0) {
        temp3 = [NSString stringWithFormat:@"   Pizza:           Sausage           %@               %@          %@\n", currentOrder.sausage, [CoreData myData].sausagePrice, sausageTotal];
    }
    if (currentOrder.veggie.intValue > 0) {
        temp4 = [NSString stringWithFormat:@"   Pizza:           Veggie            %@              %@           %@\n", currentOrder.veggie, [CoreData myData].veggiePrice, veggieTotal];
    }
    if (currentOrder.sprite.intValue > 0) {
        temp5 = [NSString stringWithFormat:@"   Drink:           Sprite             %@               %@             %@\n", currentOrder.sprite, [CoreData myData].spritePrice, spriteTotal];
    }
    if (currentOrder.coke.intValue > 0) {
        temp6 = [NSString stringWithFormat:@"   Drink:           Coke              %@               %@             %@\n", currentOrder.coke, [CoreData myData].cokePrice, cokeTotal];
    }
    if (currentOrder.budweiser.intValue > 0) {
        temp7 = [NSString stringWithFormat:@"   Drink:           Budweiser      %@               %@             %@\n", currentOrder.budweiser, [CoreData myData].budweiserPrice, budweiserTotal];
    }

    textView.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp1 ?: @"", temp2 ?: @"", temp3 ?: @"", temp4 ?: @"", temp5 ?: @"",temp6 ?: @"",temp7 ?: @""];
    textView.font = [UIFont systemFontOfSize:25];
    
    dollarTotalLabel.text = [NSString stringWithFormat:@"$%1.2f", [grandTotal floatValue]];
    NSNumber *taxTotal = @([grandTotal floatValue] * .095);
    taxTotalLabel.text = [NSString stringWithFormat:@"$%1.2f", [taxTotal floatValue]];
    grandTotalLabel.text = [NSString stringWithFormat:@"$%1.2f", [grandTotal floatValue] + [taxTotal floatValue]];
}



@end
