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
                                 imageLocation:@"cup.png" 
                                          type:@"UIDestination" 
    
                                 localIDNumber:@"" 
                                    instanceOf:@"Prototype" 
                                   
                                   destination:@"" 
                                      receives:@"" 
                                    
                                    restaurant:@"" 
                                         table:@"table 1"  
                                      customer:@""  
                              
                              filterRestaurant:@"" 
                                   filterTable:@"" 
                                filterCustomer:@"" 
                                    
                                    isSelected:false canDrag:false placeInstancesInHorizontalLine:TRUE isSeated:false filterIsSeated:false 
                              
                              defaultPositionX:250 
                              defaultPositionY:150 
                                     buildMode:@0    ];



    [[CoreData myData] makeNewUIItem_parentName:@"Respective Tables" 
                                           name:@"Pizza" 
                                 titleToDisplay:@"+ Pizza" 
                                  imageLocation:@"" 
                                           type:@"UIDestination" 
     
                                  localIDNumber:@"" 
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
     
                               defaultPositionX:650 
                               defaultPositionY:300 
                                      buildMode:@0    ];
    
    [[CoreData myData] makeNewUIItem_parentName:@"" 
                                           name:@"Trash" 
                                 titleToDisplay:@"TRASH" 
                                  imageLocation:@"" 
                                           type:@"UIDestination" 
     
                                  localIDNumber:@"" 
                                     instanceOf:@"Prototype" 
     
                                    destination:@"" 
                                       receives:@"ALL" 
     
                                     restaurant:@"" 
                                          table:@"Main View"  
                                       customer:@""    
     
                               filterRestaurant:@"" 
                                    filterTable:@"" 
                                 filterCustomer:@"" 
     
                                     isSelected:false canDrag:false placeInstancesInHorizontalLine:TRUE isSeated:false filterIsSeated:false 
     
                               defaultPositionX:600 
                               defaultPositionY:650 
                                      buildMode:@0    ];
    

    [[CoreData myData] makeNewUIItem_parentName:@"" 
                                           name:@"Trash" 
                                 titleToDisplay:@"TRASH" 
                                  imageLocation:@"" 
                                           type:@"UIDestination" 
     
                                  localIDNumber:@"" 
                                     instanceOf:@"Prototype" 
     
                                    destination:@"" 
                                       receives:@"ALL" 
     
                                     restaurant:@"" 
                                          table:@"table"  
                                       customer:@""    
     
                               filterRestaurant:@"" 
                                    filterTable:@"" 
                                 filterCustomer:@"" 
     
                                     isSelected:false canDrag:false placeInstancesInHorizontalLine:TRUE isSeated:false filterIsSeated:false 
     
                               defaultPositionX:600 
                               defaultPositionY:650 
                                      buildMode:@0    ];
    
    
    
    // UIView Cells
    [[CoreData myData] makeNewUIItem_parentName:@"Respective Tables" 
                                           name:@"Restaurant" 
                                 titleToDisplay:@"Restaurant View" 
                                  imageLocation:@"" 
                                           type:@"UIFilter" 
     
                                  localIDNumber:@"" 
                                     instanceOf:@"" 
     
                                    destination:@"" 
                                       receives:@"" 
     
                                     restaurant:@"" 
                                          table:@""  
                                       customer:@""  
     
                               filterRestaurant:@"" 
                                    filterTable:@"Main View" 
                                 filterCustomer:@"" 
     
                                     isSelected:false canDrag:false placeInstancesInHorizontalLine:true isSeated:false filterIsSeated:false 
     
                               defaultPositionX:0 
                               defaultPositionY:670 
                                      buildMode:@0    ];
    
    
    
    [[CoreData myData] makeNewUIItem_parentName:@"" 
                                           name:@"Table 1" 
                                 titleToDisplay:@"Table" 
                                  imageLocation:@"" 
                                           type:@"UIFilter" 
     
                                  localIDNumber:@"" 
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
     
                               defaultPositionX:100 
                               defaultPositionY:400 
                                      buildMode:@0    ];
    
    [[CoreData myData] makeNewUIItem_parentName:@"" 
                                           name:@"Table 2" 
                                 titleToDisplay:@"Table 2" 
                                  imageLocation:@"" 
                                           type:@"UIFilter" 
     
                                  localIDNumber:@"" instanceOf:@"" 
     
                                    destination:@"" 
                                       receives:@"" 
     
                                     restaurant:@"" 
                                          table:@"Main View"  
                                       customer:@""  
     
                               filterRestaurant:@"" 
                                    filterTable:@"table 2" 
                                 filterCustomer:@"" 
     
                                     isSelected:false canDrag:false placeInstancesInHorizontalLine:true isSeated:false filterIsSeated:false 
     
                               defaultPositionX:200 
                               defaultPositionY:200 
                                      buildMode:@0    ];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MENU BRANCHES
    [[CoreData myData]      makeNewMenuItemFromData_parentName:@"Main Menu" 
                                                          name:@"Pizza Menu" 
                                                titleToDisplay:@"Pizza" 
                                                 imageLocation:@"" 
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
                                                 imageLocation:@"" 
                                                          type:@"MenuBranch"
     
                                                 localIDNumber:@"" instanceOf:@"" destination:@""receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    // MENU ITEMS - DRINKS
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Drinks Menu" 
                                                              name:@"Coke" 
                                                    titleToDisplay:@"Coke" 
                                                     imageLocation:@"coke.jpg" 
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Drink" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Drinks Menu" 
                                                              name:@"Sprite" 
                                                    titleToDisplay:@"Sprite" 
                                                     imageLocation:@"sprite.jpg"
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Drink"
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Drinks Menu" 
                                                              name:@"Beer" 
                                                    titleToDisplay:@"Budweiser" 
                                                     imageLocation:@"bud.png" 
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Drink" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    //MENU ITEMS PIZZA
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Pizza Menu" 
                                                              name:@"Cheese" 
                                                    titleToDisplay:@"Cheese Pizza" 
                                                     imageLocation:@"" 
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Pizza" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Pizza Menu" 
                                                              name:@"Pepperoni Pizza" 
                                                    titleToDisplay:@"Pepperoni Pizza" 
                                                     imageLocation:@"" 
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Pizza" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    [[CoreData myData]          makeNewMenuItemFromData_parentName:@"Pizza Menu" 
                                                              name:@"Veggie Pizza"
                                                    titleToDisplay:@"Veggie Pizza" 
                                                     imageLocation:@""
                                                              type:@"MenuItem"
     
                                                     localIDNumber:@"" instanceOf:@"" 
     
                                                       destination:@"Pizza" 
     
                                                          receives:@"" restaurant:@"" table:@"" customer:@"" filterRestaurant:@"" filterTable:@"" filterCustomer:@"" isSelected:FALSE canDrag:FALSE placeInstancesInHorizontalLine:TRUE isSeated:TRUE filterIsSeated:true defaultPositionX:0 defaultPositionY:0 buildMode:@0      ];
    
    
    
    
    

}

@end
