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

@synthesize currentOrder, timeLabel, ticketNumberLabel, textView;


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
    NSString *temp1, *temp2, *temp3, *temp4, *temp5;
    
    NSDate *passedDate = currentOrder.timeOfOrder;
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSLog(@"%@",[DateFormatter stringFromDate:passedDate]);

    timeLabel.text = [DateFormatter stringFromDate:passedDate];
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@", currentOrder.timeOfOrder]);
    
    ticketNumberLabel.text = [NSString stringWithFormat:@"%@", currentOrder.ticketNumber];
    
    
    if (currentOrder.cheese > 0) {
        temp1 = [NSString stringWithFormat:@"Pizza:       Cheese           %@ \n", currentOrder.cheese];
    }
    if (currentOrder.pepperoni > 0) {
        temp2 = [NSString stringWithFormat:@"Pizza:       Pepperoni        %@ \n", currentOrder.pepperoni];
    }
    if (currentOrder.sausage > 0) {
        temp3 = [NSString stringWithFormat:@"Pizza:       Sausage          %@ \n", currentOrder.sausage];
    }
    if (currentOrder.sprite > 0) {
        temp4 = [NSString stringWithFormat:@"Drink:       Sprite           %@ \n", currentOrder.sprite];
    }
    if (currentOrder.coke > 0) {
        temp5 = [NSString stringWithFormat:@"Drink:       Coke             %@ \n", currentOrder.coke];
    }

    textView.text = [NSString stringWithFormat:@"%@%@%@%@%@", temp1, temp2, temp3, temp4, temp5];
}



@end
