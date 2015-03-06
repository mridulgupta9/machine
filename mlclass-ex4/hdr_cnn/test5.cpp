#include<cstdio>
#include<cstdlib>
#include<cmath>
#include<algorithm>
#include<iostream>

using namespace std;


long fact( long n, long k )
{
    if (k > n) return 0;
    if (k * 2 > n) k = n-k;
    if (k == 0) return 1;

    long result = n;
    for( long i = 2; i <= k; ++i ) {
        result *= (n-i+1);
        result /= i;
    }
    return result;
}

int main(){

	int t,i;
	long n,r,x;
	scanf("%d",&t);
	for(i=0;i<t;++i){
		scanf("%ld%ld",&n,&r);
		x=fact(n,r);
		printf("%ld",x);

	}

return 0;
}