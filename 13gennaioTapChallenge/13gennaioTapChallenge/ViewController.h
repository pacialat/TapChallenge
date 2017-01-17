//
//  ViewController.h
//  13gennaioTapChallenge
//
//  Created by Maurizio on 13/01/17.
//  Copyright © 2017 Maurizio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *tapsCountLabel;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

-(IBAction)buttonPressed:(id)sender;

@end

