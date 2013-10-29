// READ ME/MUST READ
// types: MenuItem, UIDestination, UIInstance, MenuBranch, UIFilter
// must have a root MenuItem, name it Main Menu
// UIInstance may be filtered using rest, etc.
// UIFilters (which belong to screen) may be filtered thru parent child relationship, like menu

// menu item to go back to main, just list Main Menu

/*
 
 add temp bar at the bottom where can drag items to move from one place ot the next or delete with button
 
 builder - edit2
 scale, add photo, add text
 
 filter set up backwards, should allow all to show all, not always show
 maybe break out (of course, set up filters at the bottom to always show so...)
 
 add flags
 
 */

// BUG
// text doesn't show
// center detection on drag and drop


// trash can, use UIDestination and then delete all items having instanceOf

// builder mode
// have Greg add core data so can make lower screen bar on this system (for example, going back to main menu)




// what about hybrids, salad and salad dressing

// ???   "<MenuItemCell: 0x8d93cb0; frame = (60 60; 100 100); autoresize = RM+BM; layer = <CALayer: 0x8d938d0>>",


#import "ViewController.h"
#import "MenuItemCell.h"
#import "MenuItem.h"
#import "TouchProtocol.h"

@interface ViewController ()

// arrays
@property NSMutableArray *menuItemsGlobal;
@property NSMutableArray *menuItemsCurrent;
@property NSMutableArray *uiObjectsOnScreen;
@property NSMutableArray *uiObjects;
@property NSMutableArray *uiObjectToLoadFromDataSource;

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
@property float uiItemPadding;
@property float yDefualtStartingPosition;
@property float itemPositionXStarting;

@property int numberOfMenuItemsOnPage;
@property int localIDNumberCounter;           // replace with Core Data

// filters/search par
@property NSString *restaurant;
@property NSString *table;
@property NSString *customer;
@property BOOL isSeated;

@property BOOL buildModeOn;

@property int tableInstance;

// ADD ???


@property NSString *server;
@property NSString *section;

@property float timeSeated;
@property float timeDrinksOrdered;

-(void)setupScreen;
-(void)getDefaultSettings;
-(void)setupMenu;
-(void)clearMenu;
-(void)createUIItems;
-(void)sortUIItemsOnScreen;
-(void)makeSomeData;
-(void)toggleBuilderModeOnOff;

-(void)buildMenuByFindingChildrenOfParent:(NSString *)nameOfParent;
-(void)makeInstance:(MenuItemCell *)sender objectBeingHit:(MenuItemCell *)objectBeingHit;

-(MenuItemCell *)makeBlockView_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type destintation:(NSString *)destiation receives:(NSString *)receives titleToDisplay:(NSString *)titleToDisplay xValue:(float)x yValue:(float)y ht:(float)height wd:(float)width canDrag:(BOOL)canDrag defaultColor:(UIColor *)defaultColor highlightedColor:(UIColor *)highlightedColor dragColor:(UIColor *)dragColor editExistingBlockInsteadOfCreating:(MenuItemCell *)block;

@end


@implementation ViewController

@synthesize uiObjectToLoadFromDataSource, uiObjectsOnScreen, colorDefaultForMenuItems, colorDefaultForUIItems, colorDraggingForMenuItems, colorHighlightedForMenuItems, colorHighlightedForUIItems, menuItemWidth, menuItemHeight, menuItemPadding, numberOfMenuItemsOnPage, itemPositionXStarting, colorDraggingForUIItems, menuItemsGlobal, yDefualtStartingPosition, menuItemsCurrent, uiItemPadding, localIDNumberCounter, restaurant, table, customer, isSeated, uiObjects, buildModeOn;


#pragma mark Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScreen];
}

-(void)setupScreen
{
    
    [self getDefaultSettings];
    [self setupMenu];
    
    [self makeSomeData];  // replace with info from core data
    
    [self buildMenuByFindingChildrenOfParent:@"Main Menu"];
    [self createUIItems];
    [self runUIFilter];
    
}

-(void)getDefaultSettings
{
    localIDNumberCounter = 1;       // repace with core data
    buildModeOn = FALSE;
    
    // create arrays
    menuItemsGlobal   = [NSMutableArray new];  // replace with core data
    menuItemsCurrent  = [NSMutableArray new];
    uiObjectToLoadFromDataSource  = [NSMutableArray new];  // replace with core data
    uiObjects = [NSMutableArray new];
    uiObjectsOnScreen = [NSMutableArray new];
    
    // set sizes
    menuItemWidth = 80;
    menuItemHeight = 60;
    menuItemPadding = 2;
    uiItemPadding = 5;
    yDefualtStartingPosition = 22;
    
    // check screen size
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.width;  // view in landscape
    CGFloat screenWidth = screenSize.height;
    
    itemPositionXStarting = screenWidth - menuItemWidth;
    numberOfMenuItemsOnPage = screenHeight / (menuItemHeight + menuItemPadding) -1;
    
    // set colors
    colorDefaultForMenuItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];
    //dodger blue	#1E90FF	(30,144,255)
    colorDraggingForMenuItems = [UIColor greenColor];
    colorHighlightedForMenuItems = [UIColor brownColor];
    
    colorDefaultForUIItems = [UIColor colorWithRed:30/256 green:144/256 blue:255/255 alpha:.3];     //purplish
    colorHighlightedForUIItems = [UIColor redColor];
    colorDraggingForUIItems = [UIColor purpleColor];
    
}


#pragma mark Menu

-(void)setupMenu
{
    
    // make menu from blocks (no data), will reuse the cells
    float yBlockPosition = yDefualtStartingPosition;
    
    for(int x = 0; x<numberOfMenuItemsOnPage; x++)  {
        
        MenuItemCell *menuBlock = [self makeBlockView_Name: @""
                                             imageLocation: @""
                                                parentName: @"no parent set"
                                                      type: @"MenuItem"
                                              destintation: @"no destination set"
                                                  receives: @"no receiver set"
                                            titleToDisplay: @""
                                   
                                                    xValue: itemPositionXStarting
                                                    yValue: yBlockPosition
                                                        ht: menuItemHeight
                                                        wd: menuItemWidth
                                                   canDrag: FALSE
                                              defaultColor: colorDefaultForMenuItems
                                          highlightedColor: colorDefaultForMenuItems
                                                 dragColor: colorDefaultForMenuItems
                        editExistingBlockInsteadOfCreating: nil];
        
        // increment y position
        yBlockPosition = yBlockPosition + menuItemHeight + menuItemPadding;
        
        [menuItemsCurrent addObject:menuBlock];
        [self.view addSubview:menuBlock];
        
    }
    
}

-(void)clearMenu  // same as setup, but does not make the objects, reuses them
{
    
    for(MenuItemCell *z in menuItemsCurrent)  {
        
        __unused MenuItemCell * menuBlock = [self makeBlockView_Name: @""
                                                       imageLocation: @""
                                                          parentName: @"no parent allowed"
                                                                type: @"MenuItem"
                                                        destintation: @"no destination set"
                                                            receives: @"no receiver set"
                                                      titleToDisplay: @""
                                             
                                                              xValue: 0
                                                              yValue: 0
                                                                  ht: 0
                                                                  wd: 0
                                             
                                                             canDrag: FALSE
                                                        defaultColor: colorDefaultForMenuItems
                                                    highlightedColor: colorDefaultForMenuItems
                                                           dragColor: colorDefaultForMenuItems
                                  editExistingBlockInsteadOfCreating: z   ];
        
    }
    
}

-(void)buildMenuByFindingChildrenOfParent:(NSString *)nameOfParent
{
    
    
    NSArray *menuData = [[CoreData myData] fetchMenuItems];

    // clean out the old menu
    [self clearMenu];
    
    // for each child of the parent, build a Menu Item
    int counter = 0;
    for(MenuItemData *z in menuData){
        
        if([z.parentName isEqualToString:nameOfParent]){
            
            __unused MenuItemCell *menuBlock = [self makeBlockView_Name: z.name
                                                          imageLocation: z.imageLocation
                                                             parentName: z.parentName
                                                                   type: z.type
                                                           destintation: z.destination
                                                               receives: z.receives
                                                         titleToDisplay: z.titleToDisplay
                                                
                                                                 xValue: 0
                                                                 yValue: 0
                                                                     ht: 0
                                                                     wd: 0
                                                                canDrag: TRUE
                                                           defaultColor: colorDefaultForMenuItems
                                                       highlightedColor: colorHighlightedForMenuItems
                                                              dragColor: colorDraggingForMenuItems
                                     editExistingBlockInsteadOfCreating: [menuItemsCurrent objectAtIndex:counter]];
            counter +=1;
        }
    }
}


-(void)builder
{
    
    // clean out the old menu
    [self clearMenu];
    
    // for each child of the parent, build a Menu Item
    int counter = 0;
    for(MenuItemCell *z in uiObjects){
        
        if([z.type isEqualToString:@"UIFilter"] || [z.type isEqualToString:@"UIDestination"]){
            
            __unused MenuItemCell *menuBlock = [self makeBlockView_Name: z.name
                                                          imageLocation: z.imageLocation
                                                             parentName: z.parentName
                                                                   type: z.type
                                                           destintation: z.destination
                                                               receives: z.receives
                                                         titleToDisplay: z.titleToDisplay
                                                
                                                                 xValue: 0
                                                                 yValue: 0
                                                                     ht: 0
                                                                     wd: 0
                                                                canDrag: TRUE
                                                           defaultColor: colorDefaultForUIItems
                                                       highlightedColor: colorHighlightedForUIItems
                                                              dragColor: colorDraggingForUIItems
                                     editExistingBlockInsteadOfCreating: [menuItemsCurrent objectAtIndex:counter]];
            
            // add additional data
            menuBlock.restaurant = restaurant;
            menuBlock.table = table;
            menuBlock.customer = customer;
            
            menuBlock.filterRestaurant = z.filterRestaurant;
            menuBlock.filterTable = z.filterTable;
            menuBlock.filterCustomer = z.filterCustomer;
            menuBlock.filterIsSeated = z.filterIsSeated;
            
            menuBlock.buildMode = 1;
            
            counter +=1; }
        
    }
    
}

-(MenuItemCell *)makeBlockView_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type destintation:(NSString *)destination receives:(NSString *)receives titleToDisplay:(NSString *)titleToDisplay xValue:(float)x yValue:(float)y ht:(float)height wd:(float)width canDrag:(BOOL)canDrag defaultColor:(UIColor *)defaultColor highlightedColor:(UIColor *)highlightedColor dragColor:(UIColor *)dragColor editExistingBlockInsteadOfCreating:(MenuItemCell *)block
{
    
    
    
    
    // create menu block (unless editing an old one)
    
    MenuItemCell *menuBlock;
    
    if(block == nil){
        menuBlock = [[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:nil][0]; }
    else{
        menuBlock = block; }
    
    if (x==0){ x = menuBlock.frame.origin.x; }  // should add use defaultXYHtWd instead of passing value = 0
    if (y==0){ y = menuBlock.frame.origin.y; }
    if (width==0){ width = menuBlock.frame.size.width; }
    if (height==0){ height = menuBlock.frame.size.height;}
    
    // set view components
    menuBlock.textLabel.text = titleToDisplay;
    menuBlock.imageView.image = [UIImage imageNamed: imageLocation];
    
    menuBlock.frame = CGRectMake(x,y,width, height);
    menuBlock.backgroundColor = colorDefaultForMenuItems;
    
    // set properties
    menuBlock.delegate = self;
    menuBlock.name = name;
    menuBlock.type = type;
    menuBlock.titleToDisplay = titleToDisplay;
    menuBlock.imageLocation = imageLocation;
    menuBlock.parentName = parentName;
    menuBlock.destination = destination;
    menuBlock.receives = receives;
    
    menuBlock.defaultPositionX = x;
    menuBlock.defaultPositionY = y;
    
    menuBlock.defaultColor = defaultColor;
    menuBlock.highlightedColor = highlightedColor;
    menuBlock.dragColor = dragColor;
    menuBlock.isSelected = FALSE;
    menuBlock.buildMode = 0;    // 0 tells us it is false/off
    
    menuBlock.localIDNumber = [NSString stringWithFormat:@"%i",localIDNumberCounter];
    localIDNumberCounter +=1;
    
    if([type isEqualToString:@"MenuBranch"]) {
        menuBlock.canDrag = FALSE;
    }else {
        menuBlock.canDrag = canDrag; }
    
    return menuBlock;
}


#pragma mark UIObjects

-(void)createUIItems  // gets data and imports into MenuCellObjects
{
    
    NSArray *menuData = [[CoreData myData] fetchUIItems];
    
    for(int x = 0; x<[menuData count]; x++)
    {
        //fetch data
        UIItemData *z =[menuData objectAtIndex:x];
        
        MenuItemCell *menuBlock = [self    makeBlockView_Name: z.name
                                                imageLocation: z.imageLocation
                                                   parentName: z.parentName
                                                         type: z.type
                                                 destintation: z.destination
                                                     receives: z.receives
                                               titleToDisplay: z.titleToDisplay
                                   
                                                       xValue: [z.defaultPositionX floatValue]
                                                       yValue: [z.defaultPositionY floatValue]
                                                           ht: 100
                                                           wd: 100
                                   
                                                      canDrag: FALSE
                                                 defaultColor: colorDefaultForUIItems
                                             highlightedColor: colorHighlightedForUIItems
                                                    dragColor: colorDraggingForUIItems
                           editExistingBlockInsteadOfCreating: nil];
        
        // add additional data
        menuBlock.restaurant = z.restaurant;
        menuBlock.table = z.table;
        menuBlock.customer = z.customer;
        
        menuBlock.filterRestaurant = z.filterRestaurant;
        menuBlock.filterTable = z.filterTable;
        menuBlock.filterCustomer = z.filterCustomer;
        menuBlock.filterIsSeated = [z.filterIsSeated boolValue];
        
        
        // store all UI objects in an Array
        [uiObjects addObject:menuBlock];
        [uiObjectsOnScreen addObject:menuBlock];
        [self.view addSubview:menuBlock];
    }
    
}

-(void)sortUIItemsOnScreen
{
    
    [uiObjectsOnScreen sortUsingComparator:^NSComparisonResult(MenuItemCell *obj1, MenuItemCell *obj2) {
        
        if(obj1.frame.origin.x < obj2.frame.origin.x){
            return -1; }
        else if (obj1.frame.origin.x > obj2.frame.origin.x){
            return 1;  }
        
        
        if(obj1.frame.origin.y < obj2.frame.origin.y){
            return -1;  }
        else {
            return 1;   }
        
    }];
    
}

-(void)runUIFilter
{
    
    // hide all UIObjectsOnScreen
    for(MenuItemCell *z in uiObjectsOnScreen){
        z.hidden = TRUE; }
    
    // remove all items in uiItemsOnScreen
    [uiObjectsOnScreen removeAllObjects];
    
    // for each uiObject
    for(MenuItemCell *z in uiObjects) {
        
        // NSLog(@"filter %@,%@,%@", restaurant, table, customer );
        // NSLog(@"%@,%@,%@", z.restaurant, z.table, z.customer );
        
        // wrong, if restaurant = ALL
        if(([restaurant isEqualToString:@"ALL"]   ||                // ie, the filter = all
            [z.restaurant isEqualToString:restaurant]   ||          // the value = the same as the filter
            [z.restaurant isEqualToString:@"ALWAYS SHOW"])          // or the value is markes as always show
           &&
           ([table isEqualToString:@"ALL"]  ||
            [z.table isEqualToString:table]   ||
            [z.table isEqualToString:@"ALWAYS SHOW"])
           &&
           ([customer isEqualToString:@"ALL"]  ||
            [z.customer isEqualToString:customer]  ||
            [z.customer isEqualToString:@"ALWAYS SHOW"]))   {
               
               z.hidden = FALSE;
               [uiObjectsOnScreen addObject:z];  }
        
    }
    
}


#pragma mark Delegate

-(void)collisionCheck:(MenuItemCell *)sender x:(float)x y:(float)y transactionComplete: (BOOL)objectDropped;
{
    
    MenuItemCell *objectBeingHit = nil;  // can't update an array you are iterating through, so save value
    
    // get location and size of drag object (just where your finger is, so reduce size of frame)
    CGRect objectOne = CGRectMake(x, y, 5, 5);
    
    // highlight potential receivers
    for(MenuItemCell *z in uiObjectsOnScreen){
        
        if([z.name isEqualToString: sender.destination] ||
           [z.receives isEqualToString: sender.name]    ||
           [z.receives isEqualToString:@"ALL"]){
            
            z.backgroundColor = colorDraggingForUIItems;
            
            // compare to location of display objects to see if collision
            if (CGRectIntersectsRect (objectOne, z.frame)) {
                
                // if collision then . . .
                z.backgroundColor = colorHighlightedForUIItems;
                objectBeingHit = z;
                
            } } }
    
    if(objectDropped && objectBeingHit){
        
        // set color
        objectBeingHit.backgroundColor = colorDefaultForMenuItems;
        
        // if it is a menu item, create an instance
        if ([sender.type isEqualToString: @"MenuItem"]) {
            
            [self makeInstance:sender objectBeingHit:objectBeingHit]; }
        
        else if ([sender.type isEqualToString:@"UIInstance"]) {
            
            sender.instanceOf = objectBeingHit.localIDNumber;
            
        } else {}
        
        
    }
    
}

-(void)updateScreenLocationsAfterDragAndDrop
{
    
    BOOL placeInstancesInHorizontalLine = TRUE;       //add to MenuItemCell
    
    // sort uiObjectsOnScreen array by x and y positions, keeping objects in respective positions
    [self sortUIItemsOnScreen];
    
    NSMutableArray *copyUIObjectsOnScreen = [NSMutableArray arrayWithArray:uiObjectsOnScreen];
    
    // fetch UIDestinationObjects
    for(MenuItemCell* z in uiObjectsOnScreen){
        
        if([z.type isEqualToString: @"UIDestination"]){
            
            int x = z.defaultPositionX;
            int y = z.defaultPositionY;
            int wd = z.frame.size.width;
            int ht = z.frame.size.height;
            
            // for each instance of our destination object
            //for(MenuItemCell *mc in uiObjectsOnScreen){
            for(MenuItemCell *mc in copyUIObjectsOnScreen){
                if([mc.instanceOf isEqualToString: z.localIDNumber]){
                    
                    mc.frame = CGRectMake(x, y, wd, ht);
                    
                    if(placeInstancesInHorizontalLine){
                        x = x + wd + uiItemPadding; }
                    else {
                        y = y + ht + uiItemPadding; }
                    
                }
                
                
            }
            
            // move destination object to next space
            z.frame = CGRectMake(x, y, wd, ht);
            
        }}
    
}

-(void)makeInstance:(MenuItemCell *)sender objectBeingHit:(MenuItemCell *)objectBeingHit
{
    MenuItemCell *menuBlock = [self makeBlockView_Name: sender.name
                                         imageLocation: sender.imageLocation
                                            parentName: sender.parentName
                                                  type: @"UIInstance"
                                          destintation: sender.destination
                                              receives: sender.receives
                                        titleToDisplay: sender.titleToDisplay
                               
                                                xValue: objectBeingHit.frame.origin.x
                                                yValue: objectBeingHit.frame.origin.y
                                                    ht: objectBeingHit.frame.size.height
                                                    wd: objectBeingHit.frame.size.width
                               
                                               canDrag: TRUE
                                          defaultColor: colorDefaultForUIItems
                                      highlightedColor: colorHighlightedForUIItems
                                             dragColor: colorDraggingForUIItems
                    editExistingBlockInsteadOfCreating: nil];
    
    // add additional data
    menuBlock.instanceOf = objectBeingHit.localIDNumber;
    menuBlock.restaurant = objectBeingHit.restaurant;
    menuBlock.table = objectBeingHit.table;
    menuBlock.customer = objectBeingHit.customer;
    
    menuBlock.filterRestaurant = sender.filterRestaurant;
    menuBlock.filterTable = sender.filterTable;
    menuBlock.filterCustomer = sender.filterCustomer;
    menuBlock.filterIsSeated = sender.filterIsSeated;
    
    
    // add to view
    [self.view addSubview:menuBlock];
    
    // add to data structures (currently arrayUI and uiObjects on the screen)
    [uiObjects addObject:menuBlock];
    [uiObjectsOnScreen addObject:menuBlock];
    
}

-(void)dropBuildObject:(MenuItemCell *)sender
{
    
    // create new instance
    MenuItemCell *menuBlock = [self makeBlockView_Name: sender.name
                                         imageLocation: sender.imageLocation
                                            parentName: sender.parentName
                                                  type: sender.type
                                          destintation: sender.destination
                                              receives: sender.receives
                                        titleToDisplay: sender.titleToDisplay
                               
                                                xValue: sender.frame.origin.x
                                                yValue: sender.frame.origin.y
                                                    ht: sender.frame.size.height
                                                    wd: sender.frame.size.width
                               
                                               canDrag: TRUE
                                          defaultColor: colorDefaultForUIItems
                                      highlightedColor: colorHighlightedForUIItems
                                             dragColor: colorDraggingForUIItems
                    editExistingBlockInsteadOfCreating: nil];
    
    // add additional data
    menuBlock.restaurant = restaurant;
    menuBlock.table = table;
    menuBlock.customer = customer;
    
    menuBlock.filterRestaurant = sender.filterRestaurant;
    menuBlock.filterTable = sender.filterTable;
    menuBlock.filterCustomer = sender.filterCustomer;
    menuBlock.filterIsSeated = sender.filterIsSeated;
    
    menuBlock.buildMode = 2;
    
    // add to view
    [self.view addSubview:menuBlock];
    
    // add to data structures (currently arrayUI and uiObjects on the screen)
    [uiObjects addObject:menuBlock];
    [uiObjectsOnScreen addObject:menuBlock];
    
    // send menu item back to menu
    sender.frame = CGRectMake(sender.defaultPositionX, sender.defaultPositionY, sender.frame.size.width, sender.frame.size.height);
    
}

- (IBAction)deleteMeForTestingOnly:(id)sender {
    
    [self toggleBuilderModeOnOff];
    
}

-(void)toggleBuilderModeOnOff
{
    
    buildModeOn = (buildModeOn +1)%2;
    
    if(buildModeOn) {
        
        for(MenuItemCell *z in uiObjects){
            
            z.canDrag = FALSE;
            z.backgroundColor = colorDefaultForUIItems;}
        
        [self builder]; }
    
    else {
        
        for(MenuItemCell *z in uiObjects){
            
            if ([z.type isEqualToString:@"Menu Item"]){
                z.canDrag = TRUE; }
            else {
                z.canDrag = FALSE; }
            
            z.buildMode = 0;  // 0 = off
            // 1 means it is a menu item you can drag and drop to create a new instance
            // 2 means it is an instance, which you can drag around
            [self buildMenuByFindingChildrenOfParent:@"Main Menu"]; }
    }
    
}

-(void)unhighlightUIObjects
{
    for(MenuItemCell *z in uiObjectsOnScreen)
    {
        z.backgroundColor = colorDefaultForUIItems;
        z.isSelected = FALSE;
    }
    
}

-(void)unhighlightMenu
{
    
    for(MenuItemCell *z in menuItemsCurrent)
    {
        z.backgroundColor = colorDefaultForUIItems;
        z.isSelected = FALSE;
    }
    
}
-(void)viewSubMenu:(MenuItemCell *)sender
{
    
    // fetch items for parentName = sender.name (ie, look for the children)
    [self buildMenuByFindingChildrenOfParent: sender.name];
    
}

-(BOOL)reverseDragAndDrop_Sender: (MenuItemCell *)sender
{
    // can't update an array you are enumerating through, so making a copy
    NSArray *copyOfUIObjectsOnScreen = [NSArray arrayWithArray:uiObjectsOnScreen];
    
    BOOL didDrop = FALSE;
    
    for(MenuItemCell *z in copyOfUIObjectsOnScreen){
        
        
        if(z.isSelected && ([sender.destination isEqualToString:z.name] || [sender.name isEqualToString:z.receives] || [z.receives isEqualToString:@"ALL"]) ){
            
            [self makeInstance:sender objectBeingHit:z];
            didDrop = TRUE;  }
    }
    
    return didDrop;
}

-(void)changeFilters:(MenuItemCell *)mit
{
    
    restaurant = mit.filterRestaurant;
    table = mit.filterTable;
    customer = mit.filterCustomer;
    isSeated = mit.filterIsSeated;
    
    [self runUIFilter];
    
}



#pragma mark Menu Items (just temp data)

-(void)makeNewMenuItem_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName destination:(NSString *)destination text:(NSString *)text type:(NSString *)type viewLevel:(NSString *)viewLevel;
{
    MenuItem *nextMenuItem = [MenuItem new];
    
    nextMenuItem.name = name;
    nextMenuItem.imageLocation = imageLocation;
    nextMenuItem.parentName = parentName;
    nextMenuItem.destination = destination;
    nextMenuItem.type = type;
    nextMenuItem.receives = viewLevel;
    nextMenuItem.text = @"text";
    nextMenuItem.receives = @"receives";
    
    [menuItemsGlobal addObject:nextMenuItem];
}


// REFACTOR OUT
-(void)makeNewUIItem_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type destination:(NSString *)destination text:(NSString *)text  ht:(float)ht wd:(float)wd xDefault:(float)x yDefault:(float)y receives:(NSString *)receives restaurant:(NSString *)restaurantX table:(NSString *)tableX customer:(NSString *)customerX filterRestaurant:(NSString *)filterRestaurant filterTable:(NSString *)filterTableX filterCustomer:(NSString *)filterCustomer filterIsSeated:(BOOL)filterIsSeated;
{
    MenuItem *nextMenuItem = [MenuItem new];
    
    nextMenuItem.name = name;
    nextMenuItem.imageLocation = imageLocation;
    nextMenuItem.parentName = parentName;
    nextMenuItem.destination = destination;
    nextMenuItem.type = type;
    nextMenuItem.text = text;
    nextMenuItem.receives = receives;
    nextMenuItem.restaurant = restaurantX;
    nextMenuItem.table = tableX;
    nextMenuItem.customer = customerX;
    
    nextMenuItem.filterRestaurant = filterRestaurant;
    nextMenuItem.filterTable = filterTableX;
    nextMenuItem.filterCustomer = filterCustomer;
    nextMenuItem.filterIsSeated = filterIsSeated;
    nextMenuItem.ht = ht;
    nextMenuItem.wd = wd;
    nextMenuItem.xDefault = x;
    nextMenuItem.yDefault = y;
    
    [uiObjectToLoadFromDataSource addObject:nextMenuItem];
}


-(void)makeSomeData
{
    /*
    [[CoreData myData] makeNewMenuItemFromData_parentName:@"Main Menu" name:@"Drinks" titleToDisplay:@"" imageLocation:@"coke.jpg" type:@"MenuBranch"  localIDNumber:@"" instanceOf:@"" destination:@"a" receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0];

    [[CoreData myData] makeNewMenuItemFromData_parentName:@"Drinks" name:@"Drinks" titleToDisplay:@"" imageLocation:@"bud.png" type:@"MenuItem"  localIDNumber:@"" instanceOf:@"" destination:@"a" receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0];
    
    [[CoreData myData] makeNewMenuItemFromData_parentName:@"Drinks" name:@"Drinks" titleToDisplay:@"" imageLocation:@"sprite.jpg" type:@"MenuItem"  localIDNumber:@"" instanceOf:@"" destination:@"a" receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0];

    
    
    
    [[CoreData myData] makeNewUIItem_parentName:@"" name:@"a" titleToDisplay:@"Dest1" imageLocation:@"" type:@"UIDestination" localIDNumber:@"" instanceOf:@"" destination:@"Dest1" receives:@"" restaurant:@"ALWAYS SHOW"  table:@"table1" customer:@"ALWAYS SHOW" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:true isSeated:FALSE filterIsSeated:FALSE defaultPositionX:100 defaultPositionY:100 buildMode:@0];
    
    [[CoreData myData] makeNewUIItem_parentName:@"" name:@"a" titleToDisplay:@"Dest1" imageLocation:@"" type:@"UIDestination" localIDNumber:@"" instanceOf:@"" destination:@"Dest1" receives:@"" restaurant:@"ALWAYS SHOW"  table:@"table1" customer:@"ALWAYS SHOW" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:true isSeated:FALSE filterIsSeated:FALSE defaultPositionX:300 defaultPositionY:100 buildMode:@0];

    
    [[CoreData myData] makeNewUIItem_parentName:@"" name:@"UIFilter1" titleToDisplay:@"Dest1" imageLocation:@"" type:@"UIDestination" localIDNumber:@"" instanceOf:@"" destination:@"Dest1" receives:@"" restaurant:@""  table:@"table2" customer:@"" filterRestaurant:@"" filterTable:@"table2" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:true isSeated:FALSE filterIsSeated:FALSE defaultPositionX:100 defaultPositionY:500 buildMode:@0];
    
    
    
    // UIFilter
    
        [[CoreData myData] makeNewUIItem_parentName:@"" name:@"UIFilter1" titleToDisplay:@"Table1" imageLocation:@"" type:@"UIFilter" localIDNumber:@"" instanceOf:@"" destination:@"Dest1" receives:@"" restaurant:@"ALWAYS SHOW"  table:@"ALWAYS SHOW" customer:@"ALWAYS SHOW" filterRestaurant:@"" filterTable:@"table1" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:true isSeated:FALSE filterIsSeated:FALSE defaultPositionX:100 defaultPositionY:500 buildMode:@0];
    
            [[CoreData myData] makeNewUIItem_parentName:@"" name:@"UIFilter1" titleToDisplay:@"Table2" imageLocation:@"" type:@"UIFilter" localIDNumber:@"" instanceOf:@"" destination:@"Dest1" receives:@"" restaurant:@"ALWAYS SHOW"  table:@"ALWAYS SHOW" customer:@"ALWAYS SHOW" filterRestaurant:@"" filterTable:@"table2" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:true isSeated:FALSE filterIsSeated:FALSE defaultPositionX:300 defaultPositionY:500 buildMode:@0];
    
            [[CoreData myData] makeNewUIItem_parentName:@"" name:@"UIFilter1" titleToDisplay:@"Rest" imageLocation:@"" type:@"UIFilter" localIDNumber:@"" instanceOf:@"" destination:@"Dest1" receives:@"" restaurant:@"ALWAYS SHOW"  table:@"ALWAYS SHOW" customer:@"ALWAYS SHOW" filterRestaurant:@"" filterTable:@"table2" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:true isSeated:FALSE filterIsSeated:FALSE defaultPositionX:500 defaultPositionY:500 buildMode:@0];
*/
    
}

@end
