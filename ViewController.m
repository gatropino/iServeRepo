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

  // arrays
  @property NSMutableArray *menuItemsArray;
  @property NSMutableArray *arrayObjectsForUI;  
  @property NSMutableArray *uiObjectsOnScreen;

  // colors
  @property UIColor *colorDefaultForMenuItems;
  @property UIColor *colorHighlightedForMenuItems;
  @property UIColor *colorDraggingForMenuItems;

  @property UIColor *colorDefaultForUIItems;
  @property UIColor *colorHighlightedForUIItems;
  @property UIColor *colorDraggingForUIItems;

  // sizes
  @property float menuItemWidth;
  @property float menuItemHeight;
  @property float menuItemPadding;
  @property float positionYStarting;
  @property float itemPositionXStarting;

  @property int numberOfMenuItemsOnPage;


  -(void)setup;
  -(void)createMenuList;
  -(void)createUIItems;
  -(void)makeSomeData;

  -(MenuItemCell *)makeBlockView_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type parentType:(NSString *)parentType viewLevel:(NSString *)viewLevel xValue:(float)x yValue:(float)y ht:(float)height wd:(float)width canDrag:(BOOL)canDrag defaultColor:(UIColor *)defaultColor highlightedColor:(UIColor *)highlightedColor dragColor:(UIColor *)dragColor;

@end


@implementation ViewController

  @synthesize menuItemsArray, arrayObjectsForUI, uiObjectsOnScreen, colorDefaultForMenuItems, colorDefaultForUIItems, colorDraggingForMenuItems, colorHighlightedForMenuItems, colorHighlightedForUIItems, menuItemWidth, menuItemHeight, menuItemPadding, positionYStarting, numberOfMenuItemsOnPage, itemPositionXStarting, colorDraggingForUIItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    [self makeSomeData];  // replace with info from core data
    
    [self createMenuList];
    [self createUIItems];   
    
}

-(void)setup
{
    // create arrays
    menuItemsArray = [NSMutableArray new];
    arrayObjectsForUI = [NSMutableArray new];
    uiObjectsOnScreen = [NSMutableArray new];    

    // set sizes
    menuItemWidth = 80;
    menuItemHeight = 60;
    menuItemPadding = 2;
    positionYStarting = 22;
    
    // check screen size
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;  
    CGFloat screenHeight = screenSize.width;  // view in landscape
    CGFloat screenWidth = screenSize.height;
    
    itemPositionXStarting = screenWidth - menuItemWidth;
    numberOfMenuItemsOnPage = screenHeight / (menuItemHeight + menuItemPadding) -1;
    
    // set colors
    colorDefaultForMenuItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];     //dodger blue	#1E90FF	(30,144,255)   
    colorDraggingForMenuItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];    
    colorHighlightedForMenuItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];  
    
    colorDefaultForUIItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];     //purplish
    colorHighlightedForUIItems = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:.3];    
    colorHighlightedForUIItems = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:.1];
    
}


#pragma mark Making Blocks
-(void)createMenuList
{
    
    for(int x = 0; x<numberOfMenuItemsOnPage; x++)
    {
        //fetch data
        MenuItem *z =[menuItemsArray objectAtIndex:x];
        
        MenuItemCell *menuBlock = [self makeBlockView_Name:z.name imageLocation:z.imageLocation parentName:z.parentName type:z.type parentType:z.parentType viewLevel:z.viewLevel xValue:itemPositionXStarting yValue:positionYStarting ht:menuItemHeight wd:menuItemHeight canDrag:TRUE defaultColor:colorDefaultForMenuItems highlightedColor:colorHighlightedForMenuItems dragColor:colorDraggingForMenuItems];
        
        // increment y position
        positionYStarting = positionYStarting + menuItemHeight + menuItemPadding;
        
        [self.view addSubview:menuBlock];
    }
    
}

-(void)createUIItems
{

    for(int x = 0; x<[arrayObjectsForUI count]; x++)
    {
        //fetch data
        MenuItem *z =[arrayObjectsForUI objectAtIndex:x];
        
        MenuItemCell *menuBlock = [self makeBlockView_Name:z.name imageLocation:z.imageLocation parentName:z.parentName type:z.type parentType:z.parentType viewLevel:z.viewLevel xValue:z.xDefault yValue:z.xDefault ht:z.ht wd:z.wd canDrag:FALSE defaultColor:colorDefaultForUIItems highlightedColor:colorHighlightedForUIItems dragColor:colorDraggingForUIItems];
        
        // increment y position
        positionYStarting = positionYStarting + menuItemHeight + menuItemPadding;
        
        // store all UI objects in an Array
        [uiObjectsOnScreen addObject:menuBlock];
        
        [self.view addSubview:menuBlock];
    }
    
}


-(MenuItemCell *)makeBlockView_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type parentType:(NSString *)parentType viewLevel:(NSString *)viewLevel xValue:(float)x yValue:(float)y ht:(float)height wd:(float)width canDrag:(BOOL)canDrag defaultColor:(UIColor *)defaultColor highlightedColor:(UIColor *)highlightedColor dragColor:(UIColor *)dragColor
{

    // create menu block
    MenuItemCell *menuBlock = [[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:nil][0];
    
    // set view components
    menuBlock.textLabel.text = name;
    menuBlock.imageView.image = [UIImage imageNamed: imageLocation];
    
    menuBlock.frame = CGRectMake(x,y,width, height);  
    menuBlock.backgroundColor = colorDefaultForMenuItems;    
    
    // set properties
    menuBlock.delegate = self;
    menuBlock.name = name;
    menuBlock.imageLocation = imageLocation;
    menuBlock.parentName = parentName;
    menuBlock.type = type;
    menuBlock.parentType = parentType;
    menuBlock.viewLevel = viewLevel;
    menuBlock.defaultPositionX = x;
    menuBlock.defaultPositionY = y;
    
    menuBlock.canDrag = canDrag; 
    menuBlock.defaultColor = defaultColor; 
    menuBlock.highlightedColor = highlightedColor; 
    menuBlock.dragColor=dragColor;
    menuBlock.isSelected = FALSE;

    return menuBlock;
}


#pragma mark Delegate
-(void)collisionCheck:(MenuItemCell *)sender x:(float)x y:(float)y transactionComplete: (BOOL)objectDropped;
{
    
    
    MenuItemCell *objectBeingHit = nil;
    
    // get location and size of drag object (just where your finger is, so reduce size of frame)
    CGRect objectOne = CGRectMake(x, y, 5, 5);
    
    
    
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
        [arrayObjectsForUI addObject:menuBlock];
        [uiObjectsOnScreen addObject:menuBlock];
        
    } 
    
}

-(void)dragCompletedUnhighlightMenuItems
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
-(void)makeNewUIItem_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type viewLevel:(NSString *)viewLevel ht:(float)ht wd:(float)wd xDefault:(float)x yDefault:(float)y;
{
    MenuItem *nextMenuItem = [MenuItem new];
    
    nextMenuItem.name = name;
    nextMenuItem.imageLocation = imageLocation;
    nextMenuItem.parentName = parentName;
    nextMenuItem.parentType = @"drink";        // FIX ME!!!
    nextMenuItem.type = type;
    nextMenuItem.viewLevel = viewLevel;
    
    nextMenuItem.ht = ht;
    nextMenuItem.wd = wd;
    nextMenuItem.xDefault = x;
    nextMenuItem.yDefault = y;
    
    [arrayObjectsForUI addObject:nextMenuItem];
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
    
    
    // name, imageLocation, parentName, type, viewLevel    
    
    [self makeNewUIItem_Name:@"1" imageLocation:@"" parentName:@"Drinks" type:@"UIObject" viewLevel:@"" ht:100 wd:100 xDefault:100 yDefault:50];

    
    [self makeNewUIItem_Name:@"1" imageLocation:@"" parentName:@"Drinks" type:@"UIObject" viewLevel:@"" ht:100 wd:100 xDefault:200 yDefault:150];
    
    [self makeNewUIItem_Name:@"1" imageLocation:@"" parentName:@"Drinks" type:@"UIObject" viewLevel:@"" ht:100 wd:100 xDefault:300 yDefault:250];
    
    [self makeNewUIItem_Name:@"1" imageLocation:@"" parentName:@"Drinks" type:@"UIObject" viewLevel:@"" ht:100 wd:100 xDefault:400 yDefault:350];
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


