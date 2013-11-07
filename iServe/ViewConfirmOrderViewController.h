//
//  ViewConfirmOrderViewController.h
//  iServe
//
//  Created by Greg Tropino on 11/1/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmedOrder.h"

@interface ViewConfirmOrderViewController : UIViewController

@property (strong, nonatomic) ConfirmedOrder *currentOrder;

@property (weak, nonatomic) IBOutlet UILabel *ticketNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tableLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *dollarTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
