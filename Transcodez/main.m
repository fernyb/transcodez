//
//  main.m
//  Transcodez
//
//  Created by fernyb on 1/11/13.
//  Copyright (c) 2013 fernyb. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
  return macruby_main("rb_main.rb", argc, argv);
}
