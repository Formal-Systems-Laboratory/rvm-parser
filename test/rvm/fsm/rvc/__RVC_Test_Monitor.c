#include <stdio.h>
#include <stdlib.h>

int foo = 2; 


   
static int Prop_0_RVC_state = 0;

static int Prop_1_RVC_state = 0;

int Test_Prop_0_start = 0;
int Test_Prop_0_safe = 0;
int Test_Prop_0_unsafe = 0;
int Test_Prop_1_start2 = 0;
int Test_Prop_1_safe2 = 0;
int Test_Prop_1_unsafe2 = 0;
void __RVC_Test_reset(void)
{
Prop_0_RVC_state = 0;
Prop_1_RVC_state = 0;
}
const static int Test_Prop_0_hasnext[]= {1, 1, 1, 3, };
const static int Test_Prop_0_next[]= {2, 0, 2, 3, };
const static int Test_Prop_1_hasnext[]= {1, 1, 1, 3, };
const static int Test_Prop_1_next[]= {2, 0, 2, 3, };




void __RVC_Test_hasnext(Iterator i)
{

{}
Prop_0_RVC_state = Test_Prop_0_hasnext[Prop_0_RVC_state];
start = Prop_0_RVC_state == 0
safe = Prop_0_RVC_state == 1
unsafe = Prop_0_RVC_state == 2
Prop_1_RVC_state = Test_Prop_1_hasnext[Prop_1_RVC_state];
start2 = Prop_1_RVC_state == 0
safe2 = Prop_1_RVC_state == 1
unsafe2 = Prop_1_RVC_state == 2
if (Test_Prop_0_start) {
{
		int j;
fprintf(stderr, "Start!\n");
	}
}
if (Test_Prop_0_unsafe) {
{
	fprintf(stderr, "It's not safe.\n");
	}
}
if (Test_Prop_1_unsafe2) {
{
		int k;
fprintf(stderr, "It's in state unsafe2.\n");
	}
}

}



void __RVC_Test_next(Iterator i)
{

{ int i = 0; {i--;} int j=i+ 2 ;
{{{}}} }
Prop_0_RVC_state = Test_Prop_0_next[Prop_0_RVC_state];
start = Prop_0_RVC_state == 0
safe = Prop_0_RVC_state == 1
unsafe = Prop_0_RVC_state == 2
Prop_1_RVC_state = Test_Prop_1_next[Prop_1_RVC_state];
start2 = Prop_1_RVC_state == 0
safe2 = Prop_1_RVC_state == 1
unsafe2 = Prop_1_RVC_state == 2
if (Test_Prop_0_start) {
{
		int j;
fprintf(stderr, "Start!\n");
	}
}
if (Test_Prop_0_unsafe) {
{
	fprintf(stderr, "It's not safe.\n");
	}
}
if (Test_Prop_1_unsafe2) {
{
		int k;
fprintf(stderr, "It's in state unsafe2.\n");
	}
}

}

