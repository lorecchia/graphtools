#include "stdio.h"
#include "stdlib.h"
#include "stddef.h"
#include "stdbool.h"
#include "assert.h"
#include "flow.c"


int main() {
    //greater sized tree with n=10 (including source and sink) and m = 14
    node *a1, *a2, *a3, *a4, *a5, *a6, *a7, *a8, *source, *sink;
    
    long s = 9;
    long t = 10;
    
    long tempT[14] = {1, 2, 3, 4, 5, 6, 6, 7, 8, 8, t, t, t, t};
    long *tails = tempT;
    long tempH[14] = {s, s, s, 1, 1, 1, 2, 2, 2, 3, 4, 5, 6, 7};
    long *heads = tempH;
    long tempF[14] = {2, 1, 2, 0, 2, 1, 1, 2, 0, 1, 2, 2, 1, 2};
    long *flows = tempF;
    
    int **output_set[8];
    long **mheads, **mtails, **mweights;
    long *nedges, *fflow;
    int route_flag;
    
    //call of function, hipr that is being tested, :
    hipr(10, 14, tails, heads, flows, s, t, output_set, mheads, mtails, mweights, nedges, fflow, route_flag);
    
    //testing the mheads, mtails, mweights which is what was changed by the decomposition of the paths
    
    //checking if mheads, mweights, mtails are of correct length
    assert (sizeOf(mheads)==12);
    assert (sizeOf(mtails)==12);
    assert (sizeOf(mweights)==12);
    
    
    //the kth path is at the 2kth index
    
    assert(mheads[0]==1);
    assert(mtails[0]==5);
    assert(mweights[0]==2);
    
    assert(mheads[2]==1);
    assert(mtails[2]==6);
    assert(mweights[2]==1);
    
    assert(mheads[4]==2);
    assert(mtails[4]==a6);
    assert(mweights[4]==1);
    
    assert(mheads[6]==2);
    assert(mtails[6]==7);
    assert(mweights[6]==1);
    
    assert(mheads[8]==a2);
    assert(mtails[8]==a8);
    assert(mweights[8]==0);
    
    assert(mheads[10]==a3);
    assert(mtails[10]==a8);
    assert(mweights[10]==1);
    
    
    return 0;
}