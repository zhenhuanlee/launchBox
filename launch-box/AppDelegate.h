//
//  AppDelegate.h
//  launch-box
//
//  Created by jude on 2019/2/26.
//  Copyright © 2019 jude. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;


@end

