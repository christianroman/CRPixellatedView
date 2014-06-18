//
//  DemoViewController.m
//  CRPixellatedViewDemo
//
//  Created by Christian Roman on 6/18/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import "DemoViewController.h"
#import "CRPixellatedView.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
    CRPixellatedView *pixellatedView = [[CRPixellatedView alloc] initWithFrame:CGRectMake(0, 50, 320, 320)];
    pixellatedView.image = [UIImage imageNamed:@"Image"];
    pixellatedView.pixelScale = 20.0f;
    pixellatedView.animationDuration = 4.0f;
    [self.view addSubview:pixellatedView];
    
    [pixellatedView animateWithCompletion:^(BOOL finished) {
        NSLog(@"completed");
    }];
     */
    
    
     CRPixellatedView *pixellatedView2 = [[CRPixellatedView alloc] initWithFrame:CGRectMake(0, 50, 320, 320)];
     pixellatedView2.image = [UIImage imageNamed:@"Image5"];
     pixellatedView2.pixelScale = 30.0f;
     pixellatedView2.animationDuration = 4.0f;
     pixellatedView2.reverse = NO;
     [self.view addSubview:pixellatedView2];
     [pixellatedView2 animateWithCompletion:^(BOOL finished) {
     NSLog(@"completed");
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
