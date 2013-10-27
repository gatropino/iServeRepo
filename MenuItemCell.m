

#import "MenuItemCell.h"
#import "ViewController.h"

@implementation MenuItemCell
  @synthesize textLabel, imageView, name, parentName, type, titleToDisplay, imageLocation, delegate, canDrag, defaultColor, isSelected, defaultPositionX, defaultPositionY, destination, receives, highlightedColor, dragColor, instanceOf, localIDNumber;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // if type = MenuBranch
    if([self.type isEqualToString:@"MenuBranch"]) {
        
            // fetch subdirectory and update screen
            [delegate viewSubMenu:(MenuItemCell *)self];
       
        
    // if type = UIFilter       
    } else if ([self.type isEqualToString:@"UIFilter"]) { 
        
            // fetch subdirectory and update screen
        
        
    // if type = MenuItem
    } else if ([self.type isEqualToString:@"MenuItem"]) {
        
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
                }];

        }
        
    // if type = UIDestination
    } else if ([self.type isEqualToString:@"UIDestination"]) {
        
            [self toggleThisBlocksColor];
                
            [delegate unhighlightMenu];
        
        
    // if type = UIInstance       
    } else if ([self.type isEqualToString:@"UIInstance"]) {
        
            [self toggleThisBlocksColor];
        
    } else { 
        NSLog(@"Error in naming conventions"); }
    
    
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
                [delegate unhighlightUIObjects];
                [delegate unhighlightMenu]; 
        
        } else if ([self.type isEqualToString:@"UIFilter"]){
        
        } else if ([self.type isEqualToString:@"UIDestination"]){
            
                // UIDestination should never been moved by user
                // but it will be moved off its default, so be careful because it will make it into here
                // but better to leave in current format, the refactored version was too hard to follow
            
        } else if ([self.type isEqualToString:@"UIInstance"]){
            
                [delegate collisionCheck:self x:x y:y transactionComplete:TRUE];
                [delegate updateScreenLocationsAfterDragAndDrop];
                [delegate unhighlightUIObjects];
                [delegate unhighlightMenu]; 
            
        } else if ([self.type isEqualToString:@"MenuBrach"]){}
        
    }
}

@end
