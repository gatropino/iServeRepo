//
//  ViewSingleOrderViewController.m
//  iServe
//
//  Created by Greg Tropino on 10/30/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "ViewSingleOrderViewController.h"

@interface ViewSingleOrderViewController ()

@end

@implementation ViewSingleOrderViewController

@synthesize currentOrder, timeLabel, ticketNumberLabel, textView, tableLabel, quantityTotalLabel;


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
    
    
    if (currentOrder.cheese.intValue > 0) {
        temp1 = [NSString stringWithFormat:@"   Pizza:              Cheese                  %@\n", currentOrder.cheese];
    }
    if (currentOrder.pepperoni.intValue > 0) {
        temp2 = [NSString stringWithFormat:@"   Pizza:              Pepperoni              %@\n", currentOrder.pepperoni];
    }
    if (currentOrder.sausage.intValue > 0) {
        temp3 = [NSString stringWithFormat:@"   Pizza:              Sausage                %@\n", currentOrder.sausage];
    }
    if (currentOrder.veggie.intValue > 0) {
        temp4 = [NSString stringWithFormat:@"   Pizza:              Veggie                    %@\n", currentOrder.veggie];
    }
    if (currentOrder.sprite.intValue > 0) {
        temp5 = [NSString stringWithFormat:@"   Drink:              Sprite                     %@\n", currentOrder.sprite];
    }
    if (currentOrder.coke.intValue > 0) {
        temp6 = [NSString stringWithFormat:@"   Drink:              Coke                      %@\n", currentOrder.coke];
    }
    if (currentOrder.budweiser.intValue > 0) {
        temp7 = [NSString stringWithFormat:@"   Drink:              Budweiser             %@\n", currentOrder.budweiser];
    }

    textView.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp1 ?: @"", temp2 ?: @"", temp3 ?: @"", temp4 ?: @"", temp5 ?: @"",temp6 ?: @"",temp7 ?: @""];
    textView.font = [UIFont systemFontOfSize:25];
    
}



@end
