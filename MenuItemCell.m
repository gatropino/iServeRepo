

#import "MenuItemCell.h"
#import "ViewController.h"

@implementation MenuItemCell
  @synthesize textLabel, imageView, name, parentName, type, titleToDisplay, imageLocation, delegate, canDrag, defaultColor, isSelected, defaultPositionX, defaultPositionY, destination, receives, highlightedColor, dragColor, instanceOf, localIDNumber, restaurant, table, customer, isSeated, filterRestaurant, filterCustomer, filterTable, filterIsSeated, placeInstancesInHorizontalLine, buildMode, orderConfirmed;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [delegate bringThisViewToFront:self];

    // if type = UIDestination
    if ([self.type isEqualToString:@"UIDestination"]) {
        
            if(buildMode == 0){  
                [self toggleThisBlocksColor];
                [delegate unhighlightMenu]; }
            else {

                [self toggleThisBlocksColor];
            }
        
        
    // if type = UIFilter       
    } else if ([self.type isEqualToString:@"UIFilter"]) { 

            if(buildMode == 0){  

                // fetch subdirectory and update screen
                [delegate unhighlightUIObjects];
                [self toggleThisBlocksColor];
                [delegate changeFilters:self]; }
        
            else {
        NSLog(@"%i", buildMode);            
                [self toggleThisBlocksColor];
                return;
                
            }
    
    // if type = Pizza Image    
    } else if ([self.type isEqualToString:@"Pizza Image Display"]) { 
        
        if(buildMode != 0){  
           
            [self toggleThisBlocksColor];
            return;
        }
        
        
    // if in build mode, do not respond to other input    
    } else if (buildMode > 0) { 
        
            return; 
        
    
    // if type = MenuItem
    } else if ([self.type isEqualToString:@"MenuItem"]) {
        
            [delegate unhighlightMenu];
            [self toggleThisBlocksColor];
    
            // check to see if UI items highlighted, if so, perform reverse drag and drop
            BOOL didDrop = [delegate reverseDragAndDrop_Sender: self];
        
            if(didDrop){
                [UIView animateWithDuration:1 animations:^{
                    self.backgroundColor = defaultColor;
                } completion:^(BOOL finished) {
                    [delegate updateScreenLocationsAfterDragAndDrop];
                    [delegate unhighlightMenu];
                    [delegate unhighlightUIObjects];
                }];}
    
        
    // if type = MenuBranch
    } else if([self.type isEqualToString:@"MenuBranch"]) {
            
            // fetch subdirectory and update screen
            [delegate viewSubMenu:(MenuItemCell *)self];
        

    // if type = UIInstance       
    } else if ([self.type isEqualToString:@"UIInstance"]) {
       
            [self toggleThisBlocksColor];
        
    } else { 
        NSLog(@"Custom Screen Item"); }
    
    
    
}

-(void)toggleThisBlocksColor
{

    isSelected = (isSelected + 1) % 2;

    if (isSelected == TRUE){
        self.backgroundColor = dragColor; 
    } else {
        self.backgroundColor = defaultColor;}

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    if(canDrag){

        UITouch *touch = [touches anyObject];  
    
        // get CGPoint with postion info (returns value relative to origin this subview)
        CGPoint changeInLocation = [touch locationInView: self];
    
        float x = self.frame.origin.x - self.frame.size.width /2 + changeInLocation.x ;
        float y = self.frame.origin.y - self.frame.size.height/2 + changeInLocation.y ;
    
        // highlight possible drop locations and highlight in another color when over drop location
        [delegate collisionCheck:self x:x y:y transactionComplete:FALSE];
 
 
        self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
    
        self.backgroundColor = self.dragColor; 
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];

    // if moved object then
    if (self.frame.origin.x != defaultPositionX || self.frame.origin.y != defaultPositionY)
    { 
        
        
        // get location
        CGPoint changeInLocation = [touch locationInView: self];
        float x = self.frame.origin.x - self.frame.size.width /2 + changeInLocation.x ;
        float y = self.frame.origin.y - self.frame.size.height/2 + changeInLocation.y ;
        
        // set to default position and color 
        if([self.type isEqualToString:@"MenuItem"]){
            
                self.frame = CGRectMake(self.defaultPositionX, defaultPositionY, self.frame.size.width, self.frame.size.height);
        
                // check collision
                [delegate collisionCheck:self x:x y:y transactionComplete:TRUE];
                [delegate updateScreenLocationsAfterDragAndDrop];
        
        } else if ([self.type isEqualToString:@"UIFilter"] || [self.type isEqualToString:@"UIDestination"]){
                
                if(buildMode == 1){
                    
                    [delegate dropBuildObject:self];  }
            
                else if (buildMode == 2){
                    defaultPositionX = self.frame.origin.x;
                    defaultPositionY = self.frame.origin.y;  }
            
                else { return; }
            
        } else if ([self.type isEqualToString:@"UIInstance"]){

                [delegate collisionCheck:self x:x y:y transactionComplete:TRUE];
                [delegate updateScreenLocationsAfterDragAndDrop];
            
        } else if ([self.type isEqualToString:@"MenuBranch"]){
        
        } else if (@"Pizza Image Display") {
                       
        } else { NSLog(@"Custom Name Called"); }
        
        [delegate unhighlightUIObjects];
        [delegate unhighlightMenu];
        [delegate deselectClipBoardItems]; 
        
    }
}




@end
