//
//  DefaultData.m
//  iServe
//
//  Created by xcode on 10/29/13.
//  Copyright (c) 2013 Greg Tropino. All rights reserved.
//

#import "DefaultData.h"
#import "CoreData.h"

@implementation DefaultData

+(void)getDefaultData
{

    // UIDestination Cells
   [[CoreData myData] makeNewUIItem_parentName:@"Respective Tables" 
                                          name:@"Drink" 
                                titleToDisplay:@"+ Drink" 
                                 imageLocation:@"drink"
                                          type:@"UIDestination" 
    
                                 localIDNumber:@"d1" 
                                    instanceOf:@"Prototype" 
                                   
                                   destination:@"" 
                                      receives:@"" 
                                    
                                    restaurant:@"" 
                                         table:@"table 1"  
                                      customer:@""  
                              
                              filterRestaurant:@"" 
                                   filterTable:@"" 
                                filterCustomer:@"" 
                                    
                                    isSelected:false canDrag:false placeInstancesInHorizontalLine:FALSE isSeated:false filterIsSeated:false 
                              
                              defaultPositionX:200
                              defaultPositionY:200 
                                     buildMode:@0    ];



    [[CoreData myData] makeNewUIItem_parentName:@"Respective Tables" 
                                           name:@"Pizza" 
                                 titleToDisplay:@"+ Pizza" 
                                  imageLocation:@"pizza"
                                           type:@"UIDestination" 
     
                                  localIDNumber:@"d2" 
                                     instanceOf:@"Prototype" 
     
                                    destination:@"" 
                                       receives:@"" 
     
                                     restaurant:@"" 
                                          table:@"table 1"  
                                       customer:@""   
     
                               filterRestaurant:@"" 
                                    filterTable:@"" 
                                 filterCustomer:@"" 
     
                                     isSelected:false canDrag:false placeInstancesInHorizontalLine:FALSE isSeated:false filterIsSeated:false 
     
                               defaultPositionX:200 
                               defaultPositionY:330 
                                      buildMode:@0    ];
    
    
    [[CoreData myData] makeNewUIItem_parentName:@"" 
                                           name:@"Table 1" 
                                 titleToDisplay:@"Table" 
                                  imageLocation:@"plate" 
                                           type:@"UIFilter" 
     
                                  localIDNumber:@"d3" 
                                     instanceOf:@"Prototype" 
     
                                    destination:@"" 
                                       receives:@"" 
     
                                     restaurant:@"" 
                                          table:@"Main View"  
                                       customer:@""  
     
                               filterRestaurant:@"" 
                                    filterTable:@"table 1" 
                                 filterCustomer:@"" 
     
                                     isSelected:false canDrag:false placeInstancesInHorizontalLine:true isSeated:false filterIsSeated:false 
     
                               defaultPositionX:300 
                               defaultPositionY:300 
                                      buildMode:@0    ];
    
    
    [[CoreData myData] makeNewUIItem_parentName:@"" 
                                           name:@"Pizza Image Display" 
                                 titleToDisplay:@"" 
                                  imageLocation:@"pizzaStart-transparent" 
                                           type:@"Pizza Image Display" 
     
                                  localIDNumber:@"d4" 
                                     instanceOf:@"" 
     
                                    destination:@"" 
                                       receives:@"" 
     
                                     restaurant:@"" 
                                          table:@"table 1"  
                                       customer:@""  
     
                               filterRestaurant:@"" 
                                    filterTable:@"" 
                                 filterCustomer:@"" 
     
                                     isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:FALSE filterIsSeated:FALSE 
     
                               defaultPositionX:200 
                               defaultPositionY:460 
                                      buildMode:@0    ];
    
    
    
    
    
    // MENU BRANCHES
    [[CoreData myData]      makeNewMenuItemFromData_parentName:@"Main Menu" 
                                                          name:@"Pizza Menu" 
                                                titleToDisplay:@"Pizza" 
                                                 imageLocation:@"pizza" 
                                                          type:@"MenuBranch"  
     
                                                 localIDNumber:@"" 
                                                    instanceOf:@"" 
                                                   destination:@"" 
                                                      receives:@"" 
                                                    restaurant:@"" 
                                                         table:@"" 
                                                      customer:@"" 
                                              filterRestaurant:@"" 
                                                   filterTable:@"" 
                                                filterCustomer:@"" 
                                                    isSelected:FALSE 
                                                       canDrag:FALSE 
                                placeInstancesInHorizontalLine:FALSE
                                                      isSeated:TRUE 
                                                filterIsSeated:true 
                                              defaultPositionX:0 
                                              defaultPositionY:0 
                                                     buildMode:@0      ];
    
    [[CoreData myData]      makeNewMenuItemFromData_parentName:@"Main Menu" 
                                                          name:@"Drinks Menu" 
                                                titleToDisplay:@"Drinks" 
                                                 imageLocation:@"drink" 
                                                          type:@"MenuBranch"
     
                                                 localIDNumber:@"" instanceOf:@"" destination:@""receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:TRUE defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    // MENU ITEMS - DRINKS
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Drinks Menu" 
                                                              name:@"Coke" 
                                                    titleToDisplay:@"Coke" 
                                                     imageLocation:@"coke.jpg" 
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Drink" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:TRUE defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Drinks Menu" 
                                                              name:@"Sprite" 
                                                    titleToDisplay:@"Sprite" 
                                                     imageLocation:@"sprite.jpg"
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Drink"
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:TRUE defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Drinks Menu" 
                                                              name:@"Beer" 
                                                    titleToDisplay:@"Budweiser" 
                                                     imageLocation:@"bud.png" 
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Drink" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:TRUE defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    //MENU ITEMS PIZZA
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Pizza Menu" 
                                                              name:@"Cheese Pizza" 
                                                    titleToDisplay:@"Cheese Pizza" 
                                                     imageLocation:@"cheese" 
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Pizza" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:TRUE defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Pizza Menu" 
                                                              name:@"Pepperoni Pizza" 
                                                    titleToDisplay:@"Pepperoni Pizza" 
                                                     imageLocation:@"pepperoni" 
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Pizza" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:TRUE defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    

    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Pizza Menu" 
                                                              name:@"Veggie Pizza" 
                                                    titleToDisplay:@"Veggie Pizza" 
                                                     imageLocation:@"veggiePizza" 
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Pizza" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];    
    
    
    
    
    
    
    
    
    
  }

@end
