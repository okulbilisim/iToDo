//
//  AddToDoViewController.h
//  iToDo
//
//  Created by Bilal ARSLAN on 07/07/14.
//  Copyright (c) 2014 Bilal ARSLAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddToDoViewControllerDelegate
@required
-(void)editingInfoWasFinished;
@end


@interface AddToDoViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;
@property (nonatomic, strong) id<AddToDoViewControllerDelegate> delegate;
@property (nonatomic) int recordIDToEdit;

- (IBAction)SaveToDo:(id)sender;

@end
