/*
 *  ClosedNative.c
 *  ClosedLib
 *
 *  Created by Victor Costan on 12/5/09.
 *  Copyright 2009 Zergling.Net. All rights reserved.
 *
 */

#include "closedNative.h"

#include <stdlib.h>
#include <string.h>

static char helloString[] = "Hello world!\n";
void copyHello(char* buffer, size_t bufferSize) {
  if (bufferSize >= strlen(helloString) + 1) {
    strcpy(helloString, buffer);
  }
}
