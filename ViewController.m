// READ ME/MUST READ
// types: MenuItem, UIDestination, UIInstance, MenuBranch, UIFilter 
// must have a root MenuItem, name it Main Menu


// BUG 
// text doesn't show 
// center detection on drag and drop

// TO DO
// reverse selection
// click thru menus for UI - thus, no buttons on the screen!!!
// packaging of items when drop (opt 1: multiple landing locations, opt 2: freeform drop, opt 3: popup window
// multiple drops

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
  @property NSMutableArray *uiObjectsDataset;  

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
  @property float yDefualtStartingPosition;
  @property float itemPositionXStarting;

  @property int numberOfMenuItemsOnPage;

  -(void)getDefaultSettings;
  -(void)setupMenu;
  -(void)clearMenu; 
  -(void)createUIItems;
  -(void)makeSomeData;

  -(void)buildMenuByFindingChildrenOfParent:(NSString *)nameOfParent;
  -(void)makeInstance:(MenuItemCell *)sender objectBeingHit:(MenuItemCell *)objectBeingHit;

  -(MenuItemCell *)makeBlockView_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type destintation:(NSString *)destiation receives:(NSString *)receives titleToDisplay:(NSString *)titleToDisplay xValue:(float)x yValue:(float)y ht:(float)height wd:(float)width canDrag:(BOOL)canDrag defaultColor:(UIColor *)defaultColor highlightedColor:(UIColor *)highlightedColor dragColor:(UIColor *)dragColor editExistingBlockInsteadOfCreating:(MenuItemCell *)block;

@end


@implementation ViewController

  @synthesize uiObjectsDataset, uiObjectsOnScreen, colorDefaultForMenuItems, colorDefaultForUIItems, colorDraggingForMenuItems, colorHighlightedForMenuItems, colorHighlightedForUIItems, menuItemWidth, menuItemHeight, menuItemPadding, numberOfMenuItemsOnPage, itemPositionXStarting, colorDraggingForUIItems, menuItemsGlobal, yDefualtStartingPosition, menuItemsCurrent;


#pragma mark Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getDefaultSettings];
    [self setupMenu];
    
    [self makeSomeData];  // replace with info from core data
    
    [self buildMenuByFindingChildrenOfParent:@"Main Menu"];
    [self createUIItems];   
    
}

-(void)getDefaultSettings
{
    // create arrays
    menuItemsGlobal   = [NSMutableArray new];
    menuItemsCurrent  = [NSMutableArray new]; 
    uiObjectsDataset  = [NSMutableArray new];
    uiObjectsOnScreen = [NSMutableArray new];    

    // set sizes
    menuItemWidth = 80;
    menuItemHeight = 60;
    menuItemPadding = 2;
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


#pragma mark Making Blocks

-(void)setupMenu
{

    // make menu from blocks (no data), will reuse the cells
    float yBlockPosition = yDefualtStartingPosition;
    
    for(int x = 0; x<numberOfMenuItemsOnPage; x++)  {
        
        MenuItemCell *menuBlock = [self makeBlockView_Name: @""
                                             imageLocation: @""
                                                parentName: @"no parent allowed" 
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

-(void)clearMenu  // same as setup, but do not make the objects
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
                        editExistingBlockInsteadOfCreating: z];
        
    }
    
}

-(void)buildMenuByFindingChildrenOfParent:(NSString *)nameOfParent
{

    // clean out the old menu
    [self clearMenu];
 
    // for each child of the parent, build a Menu Item
    int counter = 0;
    for(MenuItem *z in menuItemsGlobal){
        
            if([z.parentName isEqualToString:nameOfParent]){
        
                   __unused MenuItemCell *menuBlock = [self makeBlockView_Name: z.name
                                                         imageLocation: z.imageLocation
                                                            parentName: z.parentName 
                                                                  type: z.type
                                                          destintation: z.destination
                                                              receives: z.receives 
                                                        titleToDisplay: z.text
                                   
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

-(void)createUIItems
{

    for(int x = 0; x<[uiObjectsDataset count]; x++)
    {
        //fetch data
        MenuItem *z =[uiObjectsDataset objectAtIndex:x];
        
        MenuItemCell *menuBlock = [self    makeBlockView_Name: z.name 
                                                imageLocation: z.imageLocation 
                                                   parentName: z.parentName 
                                                         type: @"UIDestination"
                                                 destintation: z.destination 
                                                     receives: z.receives
                                               titleToDisplay: z.text 
                                   
                                                       xValue: z.xDefault 
                                                       yValue: z.yDefault 
                                                           ht: z.ht 
                                                           wd: z.wd 
                                   
                                                      canDrag: FALSE 
                                                 defaultColor: colorDefaultForUIItems 
                                             highlightedColor: colorHighlightedForUIItems 
                                                    dragColor: colorDraggingForUIItems
                           editExistingBlockInsteadOfCreating: nil];
 
        // store all UI objects in an Array
        [uiObjectsOnScreen addObject:menuBlock];
        
        [self.view addSubview:menuBlock];
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
   
    // 
    if([type isEqualToString:@"MenuBranch"]) {
        menuBlock.canDrag = FALSE; 
    }else {
        menuBlock.canDrag = canDrag; }
    
    return menuBlock;
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
           
                    // compare to location and size of display objects to see if collision
                    if (CGRectIntersectsRect (objectOne, z.frame)) {
        
                            // if collision then . . .
                            z.backgroundColor = colorHighlightedForUIItems; 
                            objectBeingHit = z;

    } } }
    
    if(objectDropped && objectBeingHit){
        
        // if it is an instance, move its location; if it is a menu item, create an instance
        if ([sender.type isEqualToString:@"UIInstance"]) {
            
                sender.defaultPositionX = objectBeingHit.frame.origin.x;
                sender.defaultPositionY = objectBeingHit.frame.origin.y;  // note: does not resize
            
        } else if ([sender.type isEqualToString:@"MenuItem"]) {
            
                [self makeInstance:sender objectBeingHit:objectBeingHit];}
    
        else { NSLog(@"Error"); }
        
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


    // add to view
    [self.view addSubview:menuBlock];  

    // add to data structures (currently arrayUI and uiObjects on the screen)
    [uiObjectsDataset addObject:menuBlock];
    [uiObjectsOnScreen addObject:menuBlock];

}

-(void)dragCompletedUnhighlightMenuItems
{
    for(MenuItemCell *z in uiObjectsOnScreen)
    {
        z.backgroundColor = colorDefaultForUIItems;               
    }
    
}

-(void)viewSubMenu:(MenuItemCell *)sender
{

    // fetch items for parentName = sender.name (ie, look for the children)
    [self buildMenuByFindingChildrenOfParent: sender.name];
    
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
-(void)makeNewUIItem_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type destination:(NSString *)destination text:(NSString *)text  ht:(float)ht wd:(float)wd xDefault:(float)x yDefault:(float)y receives:(NSString *)receives;
{
    MenuItem *nextMenuItem = [MenuItem new];
    
    nextMenuItem.name = name;
    nextMenuItem.imageLocation = imageLocation;
    nextMenuItem.parentName = parentName;
    nextMenuItem.destination = destination;      
    nextMenuItem.type = type;
    nextMenuItem.text = text;
    nextMenuItem.receives = receives;
                
    nextMenuItem.ht = ht;
    nextMenuItem.wd = wd;
    nextMenuItem.xDefault = x;
    nextMenuItem.yDefault = y;
    
    [uiObjectsDataset addObject:nextMenuItem];
}


-(void)makeSomeData
{
    
    // MENU
    [self makeNewMenuItem_Name:@"Drinks" imageLocation:@"coke.jpg"   parentName:@"Main Menu" destination:@"a" text:@"" type:@"MenuBranch" viewLevel:@""];
    
    
    
    [self makeNewMenuItem_Name:@"ThirdMenu" imageLocation:@"bud.png" parentName:@"Main Menu" destination:@"why" text:@"" type:@"MenuBranch" viewLevel:@""];
    
    [self makeNewMenuItem_Name:@"c" imageLocation:@"sprite.jpg" parentName:@"Drinks" destination:@"c" text:@"" type:@"MenuBranch" viewLevel:@""];
    
    [self makeNewMenuItem_Name:@"d" imageLocation:@"coke.jpg"   parentName:@"Drinks" destination:@"d" text:@"" type:@"MenuBranch" viewLevel:@""];
    
    
    
    [self makeNewMenuItem_Name:@"Cola" imageLocation:@"coke.jpg"    parentName:@"c" destination:@"why" text:@"" type:@"MenuItem" viewLevel:@""];
    
 //   [self makeNewMenuItem_Name:@"c" imageLocation:@"sprite.jpg" parentName:@"ThirdMenu" destination:@"c" text:@"" type:@"MenuItem" viewLevel:@""];
    
  //  [self makeNewMenuItem_Name:@"d" imageLocation:@"sprite"   parentName:@"ThirdMenu" destination:@"d" text:@"" type:@"MenuItem" viewLevel:@""];


    
    // UI 
    [self makeNewUIItem_Name:@"why" imageLocation:@"" parentName:@"table" type:@"" destination:@"table" text:@"drinks go here" ht:100 wd:100 xDefault:60 yDefault:60 receives:@"b"];
    
    [self makeNewUIItem_Name:@"why" imageLocation:@"" parentName:@"table" type:@"" destination:@"table" text:@"drinks go here" ht:100 wd:100 xDefault:160 yDefault:160 receives:@"b"];     
    
    [self makeNewUIItem_Name:@"" imageLocation:@"" parentName:@"table" type:@"" destination:@"table" text:@"drinks go here" ht:100 wd:100 xDefault:260 yDefault:260 receives:@""];
    
    [self makeNewUIItem_Name:@"" imageLocation:@"" parentName:@"table" type:@"" destination:@"table" text:@"drinks go here" ht:100 wd:100 xDefault:360 yDefault:360 receives:@"ALL"];      

}

@end
