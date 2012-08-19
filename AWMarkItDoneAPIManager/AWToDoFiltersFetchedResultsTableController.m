//
//  AWToDoFiltersFetchedResultsTableController.m
//  iPhoneMarkItDone
//
//  Created by Artur Wdowiarski on 8/14/12.
//
//

#import "AWToDoFiltersFetchedResultsTableController.h"
#import "AWMarkItDoneAPIManager.h"
#import "AWToDoFilterSectionHeaderView.h"

@interface RKFetchedResultsTableController (PullToRefreshEnabled)

- (void)isLoadingDidChange;
- (BOOL)pullToRefreshDataSourceIsLoading:(UIGestureRecognizer *)gesture;

@end

@implementation AWToDoFiltersFetchedResultsTableController

-(BOOL)isLoading{
    return isLoadingToDoContexts || isLoadingToDoContexts;
}

- (void)pullToRefreshStateChanged:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if ([self pullToRefreshDataSourceIsLoading:gesture])
            return;
        AWMarkItDoneAPIManager *apiManager = [AWMarkItDoneAPIManager sharedManager];
        isLoadingToDoContexts = isLoadingToDoLists = YES;
        [apiManager loadToDoListsWithCallback:^(NSArray *toDoLists){
            isLoadingToDoLists = NO;
            if (![self isLoading]) {
                [self isLoadingDidChange];
            }
        }];
        [apiManager LoadToDoContextsWithCallback:^(NSArray *toDoContexts){
            isLoadingToDoContexts = NO;
            if (![self isLoading]) {
                [self isLoadingDidChange];
            }
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = [self tableView:tableView heightForHeaderInSection:section];
    
    AWToDoFilterSectionHeaderView *headerView = [[AWToDoFilterSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, 360, headerHeight)];
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    headerView.titleLabel.text = title;
    
    return headerView;
}

@end
