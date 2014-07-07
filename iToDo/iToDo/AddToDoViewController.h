//
//  AddToDoViewController.h
//  iToDo
//
//  Created by Bilal ARSLAN on 07/07/14.
//  Copyright (c) 2014 Bilal ARSLAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToDoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;

- (IBAction)SaveToDo:(id)sender;

@end
