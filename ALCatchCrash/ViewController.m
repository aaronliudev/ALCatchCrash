//
//  ViewController.m
//  ALCatchCrash
//
//  Created by Alan on 23/10/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonOCException:(id)sender {
    [[NSArray array] objectAtIndex:5];
}

- (IBAction)signalBusException:(id)sender {
    //SIGBUS，内存地址未对齐
    //EXC_BAD_ACCESS(code=1,address=0x1000dba58)
    char *s = "hello world";
    *s = 'H';
    
//    [self.view addSubview:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
