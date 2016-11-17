//
//  iHMemory.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHMemory.h"
#include <sys/sysctl.h>
#include <mach/mach.h>

@implementation iHMemory

//- (double)availableMemory {
//    vm_statistics_data_t vmStats;
//    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
//    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
//    
//    if(kernReturn != KERN_SUCCESS) {
//        return NSNotFound;
//    }
//    
//    double freturn =  ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
//    //    if(freturn < 10)
//    NSLog(@"avalible memory %f",freturn);
//    return freturn;
//}

+ (NSString *)getCurrentMemoryStatus {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return @"Failed to fetch vm statistics";
    }
    
    /* Stats in bytes */
    double wired = vm_stat.wire_count * pagesize / (1024 * 1024);
    double active = vm_stat.active_count * pagesize / (1024 * 1024);
    double inactive = vm_stat.inactive_count * pagesize / (1024 * 1024);
    double free = vm_stat.free_count * pagesize / (1024 * 1024);
    double used = active + inactive + wired;
    
    return [NSString stringWithFormat:@"========Used: %fM ========Free: %fM", used, free];
}


@end
