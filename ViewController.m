// types: MenuBranch (a filter), MenuItem, UIDestination, UIInstance
// can set destination to @"ALL"


// BUG text doesn't show and receives???

// 1) allow moves to another location (ie trash)
// 2) reverse selection
//


// ??? 
// multiple drops
// packaging of items when drop

// allowing to move item to trash or to another loc 

// click thru menus (both UI and menu) - thus, no buttons on the screen!!!


// what about hybrids, salad and salad dressing



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

-(MenuItemCell *)makeBlockView_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type destintation:(NSString *)destiation receives:(NSString *)receives titleToDisplay:(NSString *)titleToDisplay xValue:(float)x yValue:(float)y ht:(float)height wd:(float)width canDrag:(BOOL)canDrag defaultColor:(UIColor *)defaultColor highlightedColor:(UIColor *)highlightedColor dragColor:(UIColor *)dragColor;

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
    colorHighlightedForUIItems = [UIColor redColor];    
    colorDraggingForUIItems = [UIColor purpleColor];
    
}


#pragma mark Making Blocks

-(void)createMenuList
{
    // figure out how many objects to put on a page
    int numberOfItems;

    if (numberOfMenuItemsOnPage > [menuItemsArray count]) {
        numberOfItems = [menuItemsArray count]; }
    else {
        numberOfItems = numberOfMenuItemsOnPage;
    }

    
    // make blocks
    for(int x = 0; x<numberOfItems; x++)
    {
        //fetch data
        MenuItem *z =[menuItemsArray objectAtIndex:x];
        
        MenuItemCell *menuBlock = [self makeBlockView_Name: z.name
                                             imageLocation: z.imageLocation
                                                parentName: z.parentName 
                                                      type: z.type 
                                              destintation: z.destination
                                                  receives: z.receives 
                                            titleToDisplay: z.text 
                                   
                                                    xValue: itemPositionXStarting
                                                    yValue: positionYStarting 
                                                        ht: menuItemHeight 
                                                        wd: menuItemWidth 
                                                   canDrag: TRUE 
                                              defaultColor: colorDefaultForMenuItems 
                                          highlightedColor: colorHighlightedForMenuItems 
                                                 dragColor: colorDraggingForMenuItems];
        
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

        MenuItemCell *menuBlock = [self    makeBlockView_Name: z.name 
                                                imageLocation: z.imageLocation 
                                                   parentName: z.parentName 
                                                         type: z.type 
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
                                                    dragColor: colorDraggingForUIItems];
 
        
        // increment y position
        positionYStarting = positionYStarting + menuItemHeight + menuItemPadding;
        
        // store all UI objects in an Array
        [uiObjectsOnScreen addObject:menuBlock];
        
        [self.view addSubview:menuBlock];
    }
    
}


-(MenuItemCell *)makeBlockView_Name:(NSString *)name imageLocation:(NSString *)imageLocation parentName:(NSString *)parentName type:(NSString *)type destintation:(NSString *)destination receives:(NSString *)receives titleToDisplay:(NSString *)titleToDisplay xValue:(float)x yValue:(float)y ht:(float)height wd:(float)width canDrag:(BOOL)canDrag defaultColor:(UIColor *)defaultColor highlightedColor:(UIColor *)highlightedColor dragColor:(UIColor *)dragColor;
{
    // create menu block
    MenuItemCell *menuBlock = [[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:nil][0];
  
    // set view components
    menuBlock.textLabel.text = @"you"; //text;
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
    
    MenuItemCell *objectBeingHit = nil;  // can't update an array you are iterating through, so save value
    
    // get location and size of drag object (just where your finger is, so reduce size of frame)
    CGRect objectOne = CGRectMake(x, y, 5, 5);
    
    // highlight potential receivers
    for(MenuItemCell *z in uiObjectsOnScreen){
        NSLog(@"%@", z.receives);
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
        
        MenuItemCell *menuBlock = [self makeBlockView_Name: sender.name
                                             imageLocation: sender.imageLocation
                                                parentName: sender.parentName 
                                                      type: sender.type 
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
                                                 dragColor: colorDraggingForUIItems];
        
        
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
    
    [menuItemsArray addObject:nextMenuItem];
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
    
    [arrayObjectsForUI addObject:nextMenuItem];
}


-(void)makeSomeData
{
    
    // MENU
    [self makeNewMenuItem_Name:@"a" imageLocation:@"coke.jpg"   parentName:@"a" destination:@"a" text:@"" type:@"MenuItem" viewLevel:@""];
    
    [self makeNewMenuItem_Name:@"b" imageLocation:@"bud.png"    parentName:@"b" destination:@"b" text:@"" type:@"MenuItem" viewLevel:@""];
    
    [self makeNewMenuItem_Name:@"c" imageLocation:@"sprite.jpg" parentName:@"c" destination:@"c" text:@"" type:@"MenuItem" viewLevel:@""];
    
    [self makeNewMenuItem_Name:@"d" imageLocation:@"coke.jpg"   parentName:@"d" destination:@"d" text:@"" type:@"MenuItem" viewLevel:@""];
    
    // UI 
    [self makeNewUIItem_Name:@"" imageLocation:@"" parentName:@"table" type:@"" destination:@"table" text:@"drinks go here" ht:100 wd:100 xDefault:60 yDefault:60 receives:@"b"];
    
    [self makeNewUIItem_Name:@"" imageLocation:@"" parentName:@"table" type:@"" destination:@"table" text:@"drinks go here" ht:100 wd:100 xDefault:160 yDefault:160 receives:@"b"];     
    
    [self makeNewUIItem_Name:@"" imageLocation:@"" parentName:@"table" type:@"" destination:@"table" text:@"drinks go here" ht:100 wd:100 xDefault:260 yDefault:260 receives:@""];
    
    [self makeNewUIItem_Name:@"" imageLocation:@"" parentName:@"table" type:@"" destination:@"table" text:@"drinks go here" ht:100 wd:100 xDefault:360 yDefault:360 receives:@""];      

}

@end
