package rvm;



#include <stdlib.h>
static int __RVC_state = 0; 



int __RVC_HasNext_unsafe = 0;

void
__RVC_HasNext_reset(void)
{
  __RVC_state = 0;
 }

static int __RVC_HASNEXT_NEXT[] = {2, 0, 2, };
static int __RVC_HASNEXT_HASNEXT[] = {1, 1, 1, };

void
__RVC_HasNext_next(Iterator i)
{
{}
__RVC_state = __RVC_HASNEXT_NEXT[__RVC_state];
  __RVC_HasNext_unsafe = __RVC_state == 2;
if(__RVC_HasNext_unsafe)
{
{
fprintf(stderr, "next called without hasNext!\n");
   }}
}

void
__RVC_HasNext_hasnext(Iterator i)
{
{}
__RVC_state = __RVC_HASNEXT_HASNEXT[__RVC_state];
  __RVC_HasNext_unsafe = __RVC_state == 2;
if(__RVC_HasNext_unsafe)
{
{
fprintf(stderr, "next called without hasNext!\n");
   }}
}


