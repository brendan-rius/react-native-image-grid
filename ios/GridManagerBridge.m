//
//  GridManagerBridge.m
//  SortableGrid
//
//  Created by Brendan Rius on 9/19/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(GridViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(urls, NSArray)
RCT_EXPORT_VIEW_PROPERTY(onOrderChange, RCTDirectEventBlock)

@end
