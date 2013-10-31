//
//  OrderItemsViewController.h
//  iServe
//
//  Created by xcode on 10/29/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "ViewSingleOrderViewController.h"

@interface OrderItemsViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
