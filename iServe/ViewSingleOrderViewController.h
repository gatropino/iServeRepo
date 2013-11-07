//
//  ViewSingleOrderViewController.h
//  iServe
//
//  Created by Greg Tropino on 10/30/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacedOrder.h"

@interface ViewSingleOrderViewController : UIViewController

@property (strong, nonatomic) PlacedOrder *currentOrder;

@property (weak, nonatomic) IBOutlet UILabel *ticketNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tableLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *dollarTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
