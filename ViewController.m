// READ ME/MUST READ
// types: MenuItem, UIDestination, UIInstance, MenuBranch, UIFilter
// must have a root MenuItem, name it Main Menu
// to add MenuItem to the root view, set table = @"Main View" (whereas to add to all views, set = @"")
// UIInstance may be filtered using rest, etc.
// UIFilters (which belong to screen) may be filtered restaurant, table, customer
// to add to build menu, set instanceOf = @"Prototype"

// menu item to go back to main, just list Main Menu

// ???????
// how distingish between table and table1, when filtering????
// table should correspond to instance, rest is unnec, and customer should be a tag
// BUILDER - default - restaurant, table, customer, plate, appetizer, 
// these are prototype cells, but can customize instance, if want
// all pieces you see on screen and can remove by drag???

// when a customer is seated, it should create a new instance of a customized universal table screen
// it should have customers; appitizers, shared dishes, and desserts; timers; trademarking and menu (using WallStreetJournal style scrolling)

// the table screen should have the timing mechanism in place
// rather than nesting an array for each table, may which to use table numbers as index
//   (place a series of filters on the left)
// scaling is handled here (a local variable)
// a table comes with seats around it, but you can add or move people (using a table builder function)
// flags and alerts also belong to tables

// all items are potentially present in table and detail views, it is simply an issue of rearranging them
//  or hiding them
// nesting salad dressings?  (don't think so, just create additional entry location)
// in table view, is the identical customer view repeated for each person 

// maybe use subclassing to distingish between category types
// and categories to add functionality???
// make state driven? (but how know when it can be selected, it is a system state ... could pass system state
//  eg drag and drop in prog ... don't know

/*
 

 builder - edit2
 scale, add photo, add text
 
 filter set up backwards, should allow all to show all, not always show
 maybe break out (of course, set up filters at the bottom to always show so...)
 
 add flags
 
 */


// center detection on drag and drop


// trash can, use UIDestination and then delete all items having instanceOf
// what about hybrids, salad and salad dressing


#import "ViewController.h"
#import "MenuItemCell.h"
#import "DefaultData.h"
#import "TouchProtocol.h"

@interface ViewController ()

// arrays
@property NSMutableArray *menuItemsGlobal;
@property NSMutableArray *menuItemsCurrent;
@property NSMutableArray *menuItemHistory;

@property NSMutableArray *uiObjectsOnScreen;
@property NSMutableArray *uiObjects;
@property NSMutableArray *uiBuildMenuPrototypeCells;

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

@property float uiItemWidth;
@property float uiItemHeight;
@property float uiItemPadding;
@property float yDefualtStartingPosition;
@property float itemPositionXStarting;

@property int numberOfMenuItemsOnPage;
@property int localIDNumberCounter;           // replace with Core Data

// filters/search par
@property NSString *restaurant;             // would have been better to use appearsIn for general
@property NSString *table;                  // and maybe another field for parent???
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
-(void)toggleBuilderModeOnOff;
-(void)createPizzaImage;
-(void)refreshBuildMenuItems;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)mainMenuButtonPressed:(id)sender;
- (IBAction)confirmOrderButtonPressed:(id)sender;
 
-(void)buildMenuByFindingChildrenOfParent:(NSString *)nameOfParent; 
-(void)makeInstance:(MenuItemCell *)sender objectBeingHit:(MenuItemCell *)objectBeingHit;

-(MenuItemCell *)makeBlockView_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type destintation:(NSString *)destiation receives:(NSString *)receives titleToDisplay:(NSString *)titleToDisplay xValue:(float)x yValue:(float)y ht:(float)height wd:(float)width canDrag:(BOOL)canDrag defaultColor:(UIColor *)defaultColor highlightedColor:(UIColor *)highlightedColor dragColor:(UIColor *)dragColor editExistingBlockInsteadOfCreating:(MenuItemCell *)block;

@end


@implementation ViewController

@synthesize uiObjectsOnScreen, colorDefaultForMenuItems, colorDefaultForUIItems, colorDraggingForMenuItems, colorHighlightedForMenuItems, colorHighlightedForUIItems, menuItemWidth, menuItemHeight, menuItemPadding, numberOfMenuItemsOnPage, itemPositionXStarting, colorDraggingForUIItems, menuItemsGlobal, yDefualtStartingPosition, menuItemsCurrent, uiItemPadding, localIDNumberCounter, restaurant, table, customer, isSeated, uiObjects, buildModeOn, menuItemHistory, uiBuildMenuPrototypeCells, uiItemHeight, uiItemWidth;


#pragma mark Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScreen];
}

-(void)setupScreen
{
    
    // check to see if anything in core data, if not, load up the prereqs.
    if ([[[CoreData myData] fetchUIItems] count]==0) {
        
        [DefaultData getDefaultData];  } // creates objects in core data
    
    
    [self getDefaultSettings];
    [self setupMenu];
    [self createPizzaImage];
    
    [self buildMenuByFindingChildrenOfParent:@"Main Menu"];
    [self createUIItems];
    [self refreshBuildMenuItems];
    [self runUIFilter];
    
}

-(void)getDefaultSettings
{
    localIDNumberCounter = 1;       // REPLACE WITH CORE DATA (YOU MAY GET BUGS)
    buildModeOn = FALSE;
    restaurant = @"";
    table = @"Main View";
    customer = @"";
    
    // create arrays
    menuItemsGlobal   = [NSMutableArray new];  // replace with core data
    menuItemsCurrent  = [NSMutableArray new];
    menuItemHistory = [NSMutableArray new];
    
    uiObjects = [NSMutableArray new];
    uiObjectsOnScreen = [NSMutableArray new];
    
    uiBuildMenuPrototypeCells = [NSMutableArray new];
    
    // set sizes
    menuItemWidth = 80;
    menuItemHeight = 60;
    menuItemPadding = 2;
    
    uiItemWidth = 100;
    uiItemHeight = 100;
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
    
    /* I think what you mean is you want the backgroundColor of your UIView to be semi transparent? If you want white/transparent use this:
     
     myView.backgroundColor = [UIColor colorWithWhite:myWhiteFloat alpha:myAlphaFloat];
     else if you want it to be another color use the general UIColor method: +colorWithRed:green:blue:alpha:
     */ 
    
}

-(void)createPizzaImage
{
    // create a single pizza image for the screen, a cell that will be reused and modified
    // it will be hidden by filtering when not in table view
    
    MenuItemCell *menuBlock = [self    makeBlockView_Name: @"Custom Cell: Pizza Image"
                                            imageLocation: @"pizzaStart.png"
                                               parentName: @""
                                                     type: @"Custom"
                                             destintation: @""
                                                 receives: @""
                                           titleToDisplay: @"+ Pizza"
                               
                                                   xValue: 200
                                                   yValue: 250
                                                       ht: 300
                                                       wd: 400
                               
                                                  canDrag: FALSE
                                             defaultColor: colorDefaultForUIItems
                                         highlightedColor: colorHighlightedForUIItems
                                                dragColor: colorDraggingForUIItems
                       editExistingBlockInsteadOfCreating: nil];
    
    // add additional data
    menuBlock.restaurant = @"";
    menuBlock.table = @"table 1";
    menuBlock.customer = @"";
    
    
    menuBlock.imageView.frame = CGRectMake(0, 0, menuBlock.frame.size.width, menuBlock.frame.size.height - 15);
    [menuBlock.imageView reloadInputViews];
    // store all UI objects in an Array
    [uiObjects addObject:menuBlock];
    [uiObjectsOnScreen addObject:menuBlock];
    [self.view addSubview:menuBlock];
    
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

- (IBAction)mainMenuButtonPressed:(id)sender {
    
    [self buildMenuByFindingChildrenOfParent:@"Main Menu"];
    
    // make sure that history count isn't getting too big
    if([menuItemHistory count]>100){
    
        [menuItemHistory removeObjectsInRange:NSMakeRange(0, 30)];
    
    }
}




- (IBAction)backButtonPressed:(id)sender 
{
    // pop off stack
    if([menuItemHistory count] > 1) { 
        [menuItemHistory removeLastObject]; 
        [self buildMenuByFindingChildrenOfParent:[menuItemHistory objectAtIndex: [menuItemHistory count] - 1]]; }
    else {
        [self buildMenuByFindingChildrenOfParent:@"Main Menu"];
    }

}

-(void)addMenuSelectionToHistory:(NSString *)menuSelection
{
    
    [menuItemHistory addObject: menuSelection];

}
     
-(void)buildMenuByFindingChildrenOfParent:(NSString *)nameOfParent
{
    
    NSArray *menuData = [[CoreData myData] fetchMenuItems];

    // clean out the old menu and store last location
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
                                                           ht: uiItemHeight
                                                           wd: uiItemWidth
                                   
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
        
        menuBlock.instanceOf = z.instanceOf;
        
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
        
      //  NSLog(@"%@ %@ %@", restaurant, table, customer );  
      //  NSLog(@"%@ %@ %@ %@", z.name, z.restaurant, z.table, z.customer ); 
        
        
        if(([restaurant isEqualToString:@""]   ||                   // ie, the filter is off
            [z.restaurant isEqualToString:restaurant]   ||          // the value = the same as the filter
            [z.restaurant isEqualToString:@""])                     // or the value is marked as always show
           &&
           ([table isEqualToString:@""]  ||
            [z.table isEqualToString:table]   ||
            [z.table isEqualToString:@""])
           &&
           ([customer isEqualToString:@""]  ||
            [z.customer isEqualToString:customer]  ||
            [z.customer isEqualToString:@""]))   {
              
               z.hidden = FALSE;
               [uiObjectsOnScreen addObject:z];  
               [self unhighlightUIObjects];}

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
            BOOL placeInstancesInHorizontalLine = z.placeInstancesInHorizontalLine;
            
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
    
    [self loadPizzaImage];
    
}

-(void)loadPizzaImage
{


    for(MenuItemCell *z in uiObjectsOnScreen)
    {
    

    
    
    }
    
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
    
    NSLog(@"in drop file ok");
    
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
                                                    ht: uiItemHeight
                                                    wd: uiItemWidth
                               
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
    
        // 0 = build mode off  1 = can drag from menu to create instance  2 = instance created 
        // create enum, or more trouble than worth (passing is weird)
    
    // add to view
    [self.view addSubview:menuBlock];
    
    // add to data structures (currently arrayUI and uiObjects on the screen)
    [uiObjects addObject:menuBlock];
    [uiObjectsOnScreen addObject:menuBlock];
    
    // send menu item back to menu bar
    sender.frame = CGRectMake(sender.defaultPositionX, sender.defaultPositionY, sender.frame.size.width, sender.frame.size.height);
    
}

- (IBAction)deleteMeForTestingOnly:(id)sender 
{
    

   [self toggleBuilderModeOnOff];
    
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


#pragma mark Build Mode

-(void)refreshBuildMenuItems
{

    // clear old objects and search uiObjects for anything with instanceOf field == @"Prototype"
    //  (all of these items should also be UIFilter or UIDestination cells, but no need to waste proc. cycles)
    
    [uiBuildMenuPrototypeCells removeAllObjects];
    
    for(MenuItemCell *z in uiObjects){
    NSLog(@"%@", z.instanceOf);
            if([z.instanceOf isEqualToString:@"Prototype"]){
       
                [uiBuildMenuPrototypeCells addObject: z];  } 

    }
    
}



-(void)menuForBuildMode
{
    
    // clean out the old menu
    [self clearMenu];
    
    // for each item, create new build menu cell
    int counter = 0;
    for(MenuItemCell *z in uiBuildMenuPrototypeCells){
 
        //filter for item looking at (same basic code as in run filters)
        
      /*  if(([restaurant isEqualToString:@""]   ||                   // ie, the filter is off
            [z.restaurant isEqualToString:restaurant]   ||          // the value = the same as the filter
            [z.restaurant isEqualToString:@""])                     // or the value is marked as always show
           &&
           ([table isEqualToString:@""]  ||
            [z.table isEqualToString:table]   ||
            [z.table isEqualToString:@""])
           &&
           ([customer isEqualToString:@""]  ||
            [z.customer isEqualToString:customer]  ||
            [z.customer isEqualToString:@""]))   {*/
               
        
            // need unique id number, so increment localIDcounter
               localIDNumberCounter +=1;
            NSLog(@"%i", counter);
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
            menuBlock.table = [NSString stringWithFormat:@"%@%i", z.name, localIDNumberCounter];
            menuBlock.customer = customer;
      
            menuBlock.filterRestaurant = z.filterRestaurant;
            menuBlock.filterTable = [NSString stringWithFormat:@"%@ %i", z.name, localIDNumberCounter];
            menuBlock.filterCustomer = z.filterCustomer;
            menuBlock.filterIsSeated = z.filterIsSeated;
         NSLog(@"there%@", menuBlock.filterTable );             
            menuBlock.buildMode = 1;
            
            counter +=1; }
   // }
    
}

-(void)toggleBuilderModeOnOff
{
    
    buildModeOn = (buildModeOn +1)%2;
    
    if(buildModeOn) {
        
        for(MenuItemCell *z in uiObjects){
            
            z.canDrag = TRUE;
            z.buildMode = 2;  // menu items not in uiObjects
            
                // 0 = off
                // 1 means it is a menu item you can drag and drop to create a new instance
                // 2 means it is an instance, which you can drag around
            
            z.backgroundColor = colorDefaultForUIItems;}
        
        [self menuForBuildMode]; }
    
    else {
        
        for(MenuItemCell *z in uiObjects){
            
            if ([z.type isEqualToString:@"Menu Item"]){
                z.canDrag = TRUE; }
            else {
                z.canDrag = FALSE; }
            
            z.buildMode = 0;  
    
            
            [self buildMenuByFindingChildrenOfParent:@"Main Menu"]; }
    }
    
}


#pragma mark TIME SEQUENCES

- (IBAction)confirmOrderButtonPressed:(id)sender {
    
    [self confirmOrderAndSendToCoreData]; 
}


-(void)confirmOrderAndSendToCoreData
{

    NSMutableArray *listOfConfirmedOrders = [NSMutableArray new];

    // get all non-confirmed orders
    //  add to array and send to core
    //  change property to confirmed
    
    for(MenuItemCell *z in uiObjectsOnScreen){
    
        if([z.type isEqualToString:@"UIInstance"] && z.orderConfirmed == FALSE){
        
            [listOfConfirmedOrders addObject: z];
            
            z.orderConfirmed = TRUE;  }
    
    }

    for(MenuItemCell *z in listOfConfirmedOrders){
        NSLog(@"%@", z.titleToDisplay ); }
    
    [[CoreData myData] placeOrderWithArray: listOfConfirmedOrders];
}


// HAVE CELL RUN DETAIL DISPLAY

// AND A RESIZE DISPLAY

// LOOK AT SCALING (SO CAN ASK)


@end
