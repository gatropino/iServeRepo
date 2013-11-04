//
//  SKViewController.m
//  iServe
//
//  Created by Greg Tropino on 11/3/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "SKViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"

@interface SKViewController ()
@end

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}


@end
