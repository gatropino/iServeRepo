

#import "MenuItemCell.h"
#import "ViewController.h"

@implementation MenuItemCell
  @synthesize textLabel, imageView, name, parentName, type, titleToDisplay, imageLocation, delegate, canDrag, defaultColor, isSelected, defaultPositionX, defaultPositionY, destination, receives, highlightedColor, dragColor;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    isSelected = (isSelected + 1) % 2;
    
    if (isSelected == TRUE){

        self.backgroundColor = dragColor; 
        
    } else {
        self.backgroundColor = defaultColor;
    }
    
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
        
        // check collision
        [delegate collisionCheck:self x:x y:y transactionComplete:TRUE];
        
        // set to default position and color
        self.frame = CGRectMake(self.defaultPositionX, defaultPositionY, self.frame.size.width, self.frame.size.height);
        self.backgroundColor = defaultColor;
        isSelected = FALSE;
        
        [delegate dragCompletedUnhighlightMenuItems]; 
        
    }
}

@end
