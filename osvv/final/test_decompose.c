#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdbool.h>
#include <assert.h>
#include "flow.h"


int main() {
    //greater sized tree with n=10 (including source and sink) and m = 14
    //node *a1, *a2, *a3, *a4, *a5, *a6, *a7, *a8, *source, *sink;
    
    long s = 9;
    long t = 10;
    
    long tempH[14] = {1, 2, 3, 4, 5, 6, 6, 7, 8, 8, t, t, t, t};
    long *heads = tempH;
    long tempT[14] = {s, s, s, 1, 1, 1, 2, 2, 2, 3, 4, 5, 6, 7};
    long *tails = tempT;
    long tempF[14] = {2, 1, 2, 0, 2, 1, 1, 2, 0, 1, 2, 2, 1, 2};
    long *flows = tempF;
    
    int *output_set = NULL;
    long *mheads = NULL;
    long *mtails = NULL;
    long *mweights = NULL;
    long nedges, fflow;
    int route_flag = 1;
    
    //call of function, hipr that is being tested, :
    hipr(10, 14, tails, heads, flows, s, t, &output_set, &mheads, &mtails, &mweights, &nedges, &fflow, route_flag);
    //testing the mheads, mtails, mweights which is what was changed by the decomposition of the paths
    
    //
    
    //the kth path is at the 2kth index
    
    /*for(int i=0; i<10; i++){
        printf("%li\n", (*mheads)[i]);
    }*/
    
    assert(mheads[0]==1);
    assert(mtails[0]==5);
    assert(mweights[0]==2);

    assert(mheads[2]==2);
    assert(mtails[2]==7);
    assert(mweights[2]==1);
    
    return 0;
       
}