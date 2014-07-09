//
//  ToDoTableViewController.h
//  iToDo
//
//  Created by Bilal ARSLAN on 05/07/14.
//  Copyright (c) 2014 Bilal ARSLAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddToDoViewController.h"

@interface ToDoTableViewController : UITableViewController
<AddToDoViewControllerDelegate>

- (IBAction)addToDo:(id)sender;

@end
