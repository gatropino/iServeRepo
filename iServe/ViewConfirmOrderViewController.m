//
//  ViewConfirmOrderViewController.m
//  iServe
//
//  Created by Greg Tropino on 11/1/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "ViewConfirmOrderViewController.h"

@interface ViewConfirmOrderViewController ()

@end

@implementation ViewConfirmOrderViewController

@synthesize currentConfirmedOrder, timeLabel, ticketNumberLabel, textView, tableLabel, quantityTotalLabel;


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
    
    NSDate *passedDate = currentConfirmedOrder.timeOfOrder;
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSLog(@"%@",[DateFormatter stringFromDate:passedDate]);
    
    timeLabel.text = [DateFormatter stringFromDate:passedDate];
    tableLabel.text = currentConfirmedOrder.orderedFromTable;
    ticketNumberLabel.text = [NSString stringWithFormat:@"%@", currentConfirmedOrder.ticketNumber];
    
    NSNumber *total = @([currentConfirmedOrder.cheese floatValue] + [currentConfirmedOrder.pepperoni floatValue] + [currentConfirmedOrder.sausage floatValue] + [currentConfirmedOrder.coke floatValue] + [currentConfirmedOrder.sprite floatValue] + [currentConfirmedOrder.budweiser floatValue] + [currentConfirmedOrder.veggie floatValue]);
    quantityTotalLabel.text = [NSString stringWithFormat:@"%@", total];
    
    
    if (currentConfirmedOrder.cheese.intValue > 0) {
        temp1 = [NSString stringWithFormat:@"   Pizza:              Cheese                  %@\n", currentConfirmedOrder.cheese];
    }
    if (currentConfirmedOrder.pepperoni.intValue > 0) {
        temp2 = [NSString stringWithFormat:@"   Pizza:              Pepperoni              %@\n", currentConfirmedOrder.pepperoni];
    }
    if (currentConfirmedOrder.sausage.intValue > 0) {
        temp3 = [NSString stringWithFormat:@"   Pizza:              Sausage                %@\n", currentConfirmedOrder.sausage];
    }
    if (currentConfirmedOrder.veggie.intValue > 0) {
        temp4 = [NSString stringWithFormat:@"   Pizza:              Veggie                    %@\n", currentConfirmedOrder.veggie];
    }
    if (currentConfirmedOrder.sprite.intValue > 0) {
        temp5 = [NSString stringWithFormat:@"   Drink:              Sprite                     %@\n", currentConfirmedOrder.sprite];
    }
    if (currentConfirmedOrder.coke.intValue > 0) {
        temp6 = [NSString stringWithFormat:@"   Drink:              Coke                      %@\n", currentConfirmedOrder.coke];
    }
    if (currentConfirmedOrder.budweiser.intValue > 0) {
        temp7 = [NSString stringWithFormat:@"   Drink:              Budweiser             %@\n", currentConfirmedOrder.budweiser];
    }
    
    textView.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp1 ?: @"", temp2 ?: @"", temp3 ?: @"", temp4 ?: @"", temp5 ?: @"",temp6 ?: @"",temp7 ?: @""];
    textView.font = [UIFont systemFontOfSize:25];
}


@end
