//
//  ViewController.m
//  launch-box
//
//  Created by jude on 2019/2/26.
//  Copyright © 2019 jude. All rights reserved.
//

#import "ViewController.h"

@interface ViewController() <NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    NSTableView *_tableView;
    NSTableCellView *_cellView;
}


@property (weak) IBOutlet NSTextField *searchBox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self createTableView];
    [self editSearchBoxView];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)controlTextDidChange:(NSNotification *)obj {
    NSLog(@"zl");
}

- (void)createTableView {
    NSLog(@"create view");
    //
    _tableView = [[NSTableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //
    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"column first"];
    column.title = @"col";
    [column setWidth:100];
    [_tableView addTableColumn:column];
    
    //
    CGSize size = self.view.frame.size;
    NSScrollView *tableContainerView = [[NSScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-50)];
    [_tableView setHeaderView:nil];
    [tableContainerView setDocumentView:_tableView];
    
    [self.view addSubview:tableContainerView];
}

- (void)editSearchBoxView {
    [_searchBox setDelegate:self];
    
    [_searchBox setFocusRingType:NSFocusRingTypeNone];
    [_searchBox setBackgroundColor: [NSColor clearColor]];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 10;
}

#pragma mark - tableview datasource
- (id)valueAtIndex:(NSUInteger)index inPropertyWithKey:(NSString *)key {
    return @"xx";
}

@end
