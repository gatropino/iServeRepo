//
//  ViewController.m
//  dragAndDrop
//
//  Created by xcode on 10/23/13.
//  Copyright (c) 2013 xcode. All rights reserved.
//

#import "ViewController.h"
#import "MenuItemCell.h"
#import "MenuItem.h"
#import "TouchProtocol.h"

@interface ViewController ()

@property NSMutableArray *menuItemsArray;
@property NSMutableArray *arrayUI;
@property NSMutableArray *uiObjectsOnScreen;

@property UIColor *colorDefaultForMenuItems;
@property UIColor *colorHighlightedForMenuItems;
@property UIColor *colorDraggingForMenuItems;
@property UIColor *colorDefaultForUIItems;
@property UIColor *colorHighlightedForUIItems;

-(void)makeBlocks;
-(void)makeSomeData;
-(void)makeBlocksForUI;
-(void)setup;

-(void)makeNewMenuItem_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type viewLevel:(NSString *)viewLevel;
-(void)makeNewUIItem_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type viewLevel:(NSString *)viewLevel;
@end

@implementation ViewController
@synthesize menuItemsArray, arrayUI, uiObjectsOnScreen, colorDefaultForMenuItems, colorDefaultForUIItems, colorDraggingForMenuItems, colorHighlightedForMenuItems, colorHighlightedForUIItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    [self makeSomeData];
    
    [self makeBlocks];
    
    uiObjectsOnScreen = [NSMutableArray new];
    
    [self makeBlocksForUI];    
    
    
    
    
    
    
}

-(void)setup
{
    menuItemsArray = [NSMutableArray new];
    
    // set colors  (UPDATE AS YOU GO, not used throughout)
    colorDefaultForMenuItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];     //dodger blue	#1E90FF	(30,144,255)   
    colorDraggingForMenuItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];    
    colorHighlightedForMenuItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];  
    
    colorDefaultForUIItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];     //purplish
    colorHighlightedForUIItems = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:.3];    
    
}


-(void)makeBlocks
{
    
    // Set Defaults   
    float blockWidth = 80;  
    float blockHeight = 60;
    float blockPadding = 2;
    float positionYStarting = 22;  
    
    // check screen size
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;  
    CGFloat screenHeight = screenSize.width;  // view in landscape
    CGFloat screenWidth = screenSize.height;
    
    
    float positionX = screenWidth - blockWidth;
    int numberOfBlocks = screenHeight / (blockHeight + blockPadding) -1;
    
    for(int x = 0; x<numberOfBlocks; x++)
    {
        //fetch data
        MenuItem *currentMenuItem =[menuItemsArray objectAtIndex:x];
        
        // create menu block
        MenuItemCell *menuBlock = [[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:nil][0];
        
        // set view components
        menuBlock.textLabel.text = currentMenuItem.name;
        menuBlock.imageView.image = [UIImage imageNamed: currentMenuItem.imageLocation];
        
        menuBlock.frame = CGRectMake(positionX,positionYStarting,blockWidth, blockHeight);  
        menuBlock.backgroundColor = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:1];     //dodger blue	#1E90FF	(30,144,255)
        
        // set properties
        menuBlock.delegate = self;
        menuBlock.name = currentMenuItem.name;
        menuBlock.imageLocation = currentMenuItem.imageLocation;
        menuBlock.parentName = currentMenuItem.parentName;
        menuBlock.type = currentMenuItem.type;
        menuBlock.viewLevel = currentMenuItem.viewLevel;
        menuBlock.defaultPositionX = positionX;
        menuBlock.defaultPositionY = positionYStarting;
        
        // increment y position
        positionYStarting = positionYStarting + blockHeight + blockPadding;
        
        [self.view addSubview:menuBlock];
    }
    
    
}


-(void)makeBlocksForUI
{
    // JUST REPEATED CODE, NEED TO REFACTOR
    
    // Set Defaults   
    float blockWidth = 140;  
    float blockHeight = 60;
    float blockPadding = 2;
    float positionYStarting = 22;  
    
    // check screen size
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;  
    CGFloat screenHeight = screenSize.width;  // view in landscape
    CGFloat screenWidth = screenSize.height;
    
    
    float positionX =  blockWidth;
    int numberOfBlocks = screenHeight / (blockHeight + blockPadding) -1;
    
    for(int x = 0; x<4; x++)
    {
        //fetch data
        MenuItem *currentMenuItem =[arrayUI objectAtIndex:x];
        
        // create menu block
        MenuItemCell *menuBlock = [[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:nil][0];
        
        // set view components
        menuBlock.textLabel.text = currentMenuItem.name;
        menuBlock.imageView.image = [UIImage imageNamed: currentMenuItem.imageLocation];
        
        menuBlock.frame = CGRectMake(positionX,positionYStarting,blockWidth, blockHeight);  
        menuBlock.backgroundColor = colorDefaultForUIItems;
        
        // set properties
        menuBlock.delegate = self;
        menuBlock.name = currentMenuItem.name;
        menuBlock.imageLocation = currentMenuItem.imageLocation;
        menuBlock.parentName = currentMenuItem.parentName;
        menuBlock.type = currentMenuItem.type;
        menuBlock.viewLevel = currentMenuItem.viewLevel;
        menuBlock.defaultPositionX = positionX;
        menuBlock.defaultPositionY = positionYStarting;
        
        // increment y position
        positionYStarting = positionYStarting + blockHeight + blockPadding;
        
        // store all UI objects in an Array
        [uiObjectsOnScreen addObject:menuBlock];
        
        [self.view addSubview:menuBlock];
    }
    
    
}






#pragma mark Delegate
-(void)collisionCheck:(MenuItemCell *)sender x:(float)x y:(float)y transactionComplete: (BOOL)objectDropped;
{
    
    
    MenuItemCell *objectBeingHit = nil;
    
    // get location and size of drag object
    // don't want to see if any part of the object collided
    // just where your finger is, so reduce size of frame
    
    // change to use passed x and y
    CGRect objectOne = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, 5, 5);
    
    
    
    // compare to location and size of display objects to see if collision
    // (must be capable of receiving drop)
    
    for(MenuItemCell *z in uiObjectsOnScreen)
    {
        
        
        if (CGRectIntersectsRect (objectOne, z.frame))  // FIX IF UNDROPPABLE
        {
            // if collision then . . .
            z.backgroundColor = colorHighlightedForUIItems; 
            objectBeingHit = z;
            
        } else {
            z.backgroundColor = colorDefaultForUIItems;    
        }   
        
    }
    
    
    // need to get out of loop to update the array you are iterating through
    
    if(objectDropped && objectBeingHit){
        
        // create an instance (a copy) of the menu item
        MenuItemCell *menuBlock = [[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:nil][0];
        
        // set view components
        menuBlock.textLabel.text = @"blow"; //sender.name;
        menuBlock.imageView.image = [UIImage imageNamed: sender.imageLocation];
        
        menuBlock.frame = CGRectMake(objectBeingHit.frame.origin.x, objectBeingHit.frame.origin.y, objectBeingHit.frame.size.width, objectBeingHit.frame.size.height); 
        menuBlock.backgroundColor = colorDefaultForUIItems;
        
        
        // set properties
        menuBlock.delegate = self;
        menuBlock.name = sender.name;
        menuBlock.imageLocation = sender.imageLocation;
        menuBlock.parentName = objectBeingHit.parentName;
        menuBlock.type = @"UIObject";
        menuBlock.viewLevel = sender.viewLevel;
        menuBlock.defaultPositionX = objectBeingHit.frame.origin.x;
        menuBlock.defaultPositionY = objectBeingHit.frame.origin.y;
        menuBlock.isSelected = FALSE;          
        NSLog(@"%@", menuBlock.imageLocation);
        // defaultColor = colorDefaultForUIItems;
        // highlightedColor = colorHighlightedForUIItems;
        // dragColor;
        
        // add to view
        [self.view addSubview:menuBlock];  // NEST OBJECTS?????
        
        // add to data structures (currently arrayUI and uiObjects on the screen)
        [arrayUI addObject:menuBlock];
        [uiObjectsOnScreen addObject:menuBlock];
        
    } 
    
}

-(void)dragCompletedUnhighlightAll
{
    for(MenuItemCell *z in uiObjectsOnScreen)
    {
        z.backgroundColor = colorDefaultForUIItems;               
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Menu Items (just temp data)

-(void)makeNewMenuItem_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type viewLevel:(NSString *)viewLevel;
{
    MenuItem *nextMenuItem = [MenuItem new];
    
    nextMenuItem.name = name;
    nextMenuItem.imageLocation = imageLocation;
    nextMenuItem.parentName = parentName;
    nextMenuItem.parentType = @"drink";        // FIX ME!!!
    nextMenuItem.type = type;
    nextMenuItem.viewLevel = viewLevel;
    
    [menuItemsArray addObject:nextMenuItem];
}


// REFACTOR OUT
-(void)makeNewUIItem_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type viewLevel:(NSString *)viewLevel;
{
    MenuItem *nextMenuItem = [MenuItem new];
    
    nextMenuItem.name = name;
    nextMenuItem.imageLocation = imageLocation;
    nextMenuItem.parentName = parentName;
    nextMenuItem.parentType = @"drink";        // FIX ME!!!
    nextMenuItem.type = type;
    nextMenuItem.viewLevel = viewLevel;
    
    [arrayUI addObject:nextMenuItem];
}


-(void)makeSomeData
{
    
    
    // name, imageLocation, parentName, type, viewLevel    
    
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    
    [self makeNewMenuItem_Name:@"Sprite" imageLocation:@"sprite.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"bud.png" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Budweiser" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Sprite" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Budweiser" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Sprite" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Budweiser" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    [self makeNewMenuItem_Name:@"Coke" imageLocation:@"coke.jpg" parentName:@"Drinks" type:@"menu item" viewLevel:@"all"];
    
    
    arrayUI = [NSMutableArray new];
    
    // name, imageLocation, parentName, type, viewLevel    
    
    [self makeNewUIItem_Name:@"Drink 1" imageLocation:@"" parentName:@"" type:@"" viewLevel:@""];
    [self makeNewUIItem_Name:@"Drink 2" imageLocation:@"" parentName:@"" type:@"" viewLevel:@""];
    [self makeNewUIItem_Name:@"Drink 3" imageLocation:@"" parentName:@"" type:@"" viewLevel:@""];
    [self makeNewUIItem_Name:@"Drink 4" imageLocation:@"" parentName:@"" type:@"" viewLevel:@""];
    [self makeNewUIItem_Name:@"Drink 5" imageLocation:@"" parentName:@"" type:@"" viewLevel:@""];
}






@end

/*
 multipleTouchEnabled  property
 exclusiveTouch  property
 userInteractionEnabled  property
 
 – bringSubviewToFront:
 – insertSubview:atIndex:
 
 hidden  property
 alpha  property
 opaque  property
 tintColor  property
 [button setTintColor:[UIColor grayColor]];
 This is equivalent to hightlight tint option in IB and is applied only for highlighted state.
 
 Update: In order to implement this for all the buttons in app, use this:
 
 [[UIButton appearance] setTintColor:[UIColor orangeColor]]; */


