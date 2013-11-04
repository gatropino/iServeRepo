//
//  MyScene.m
//  iServe
//
//  Created by Greg Tropino on 11/3/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 70;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        //[self addChild:myLabel];
        
        
        SKVideoNode *sample = [SKVideoNode videoNodeWithVideoFileNamed:@"sample_iPod.m4v"];
        sample.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
        
        //[self addChild: sample];
        [sample play];
        
        
        /*
        SKCropNode *cropNode = [[SKCropNode alloc] init];
        myLabel.position = CGPointMake(CGRectGetMidX(self.bounds),
                                          CGRectGetMidY(self.bounds));
        
        cropNode.maskNode = [[SKSpriteNode alloc] initWithImageNamed:@"cup"];
        [cropNode addChild: gamePlayNode];
        [self addChild:cropNode];
        [self addChild:gameControlNodes];
*/

    }
    return self;
}

- (void) cropNodes
{
    // the parent node i will add to screen
    SKSpriteNode *picFrame = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(100, 100)];
    picFrame.position = CGPointMake(200, 200);
    
    // the part I want to run action on
    SKSpriteNode *pic = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    pic.name = @"PictureNode";
    
    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(80, 50)];
    
    SKCropNode *cropNode = [SKCropNode node];
    [cropNode addChild:pic];
    [cropNode setMaskNode:mask];
    [picFrame addChild:cropNode];
    [self addChild:picFrame];
    
    // run action in this scope
    //[pic runAction:[SKAction moveBy:CGVectorMake(30, 30) duration:10]];
    
    // outside scope - pass its parent
    [self moveTheThing:cropNode];
}

- (void) moveTheThing:(SKNode *) theParent
{
    // the child i want to move
    SKSpriteNode *moveThisThing = (SKSpriteNode *)[theParent   childNodeWithName:@"PictureNode"];
    [moveThisThing runAction:[SKAction moveBy:CGVectorMake(30, 30) duration:10]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0.0);
        [[UIImage imageNamed:@"Spaceship"] drawInRect:CGRectMake(0, 0, 20, 20)];
        UIImage *spaceShip = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        SKSpriteNode *sprite = [SKSpriteNode new];
        
        SKTexture *tex = [SKTexture textureWithImage:spaceShip];
        sprite.texture = tex;
        sprite.size = tex.size;
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width * 0.5];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
