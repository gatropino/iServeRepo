// multitouch option
// 
//  select one, deselects others?

//  use notificaiton center
//  but what about off screen

//  array of current objects in main view
//  send message to delegate, delegate sends message back to each object

//  collision control?  
//  - array
//  - position sent out to relevant pieces (notification or del)
//  - touch (overlap, touch thru other object (just recognize second object, store drop as state in view controller)

// when dragging, lock everyone else out!  (or just have interface objects turned to off)

// unhighlight - call delegate, filter for all menu items but self, thus our strategy seems to be to change the data and let the display catch up?  or should it just run through all the displays and turn them off (skipping self)

// view runs delegate method to filter data set for things that can receive it
// highlight them


#import "MenuItemCell.h"
#import "ViewController.h"

@implementation MenuItemCell
  @synthesize textLabel, imageView, name, parentName, type, viewLevel, imageLocation, delegate, canDrag, defaultColor, isSelected, defaultPositionX, defaultPositionY, parentType, highlightedColor, dragColor;

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
