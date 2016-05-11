#include <stdio.h>
#include <stdlib.h>

static int Prop_0_RVC_state = 0;

int HasNext_Prop_0_start = 0;
int HasNext_Prop_0_safe = 0;
int HasNext_Prop_0_unsafe = 0;
void __RVC_HasNext_reset(void)
{
Prop_0_RVC_state = 0;
}
const static int HasNext_hasnext[] = {1, 1, 1, 3, };
const static int HasNext_next[] = {2, 0, 2, 3, };




void __RVC_HasNext_hasnext(Iterator i)
{

{}
Prop_0_RVC_state = HasNext_hasnext[Prop_0_RVC_state];
start = Prop_0_RVC_state == 0
safe = Prop_0_RVC_state == 1
unsafe = Prop_0_RVC_state == 2
if (HasNext_Prop_0_unsafe) {
{
fprintf(stderr, "next called without hasNext!\n");
   }
}

}



void __RVC_HasNext_next(Iterator i)
{

{}
Prop_0_RVC_state = HasNext_next[Prop_0_RVC_state];
start = Prop_0_RVC_state == 0
safe = Prop_0_RVC_state == 1
unsafe = Prop_0_RVC_state == 2
if (HasNext_Prop_0_unsafe) {
{
fprintf(stderr, "next called without hasNext!\n");
   }
}

}


