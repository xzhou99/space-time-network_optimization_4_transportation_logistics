// ConsoleApplication1.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

#include <iostream>
#include <fstream>
using namespace std;

// Linear congruential generator 
#define LCG_a 17364
#define LCG_c 1
#define LCG_M 65521  // it should be 2^32, but we use a small 16-bit number to save memory

unsigned int m_RandomSeed;
float GetRandomRatio()  // get link_specific random seed
{
	m_RandomSeed = (LCG_a * m_RandomSeed + LCG_c) % LCG_M;  //m_RandomSeed is automatically updated.

	return float(m_RandomSeed) / LCG_M;
}

int main()
{ 
	m_RandomSeed = 0;
	for (int i = 0; i < 100; i++)
	{
		cout << GetRandomRatio() << endl;
	}


	//
	ofstream f_out;
	
	f_out.open("output.txt");
	f_out << "write in file" << endl;
	for (int i = 0; i < 100; i++)
	{
		f_out << GetRandomRatio() << endl;
	}


	f_out << "generating arrival times" << endl;
	float t = 0;
	float lambda = 0.005;

	for (int i = 0; i < 100; i++)
	{
		float u = GetRandomRatio();
		float interval= -1/lambda*log(1-u);
		t = t + interval;
		f_out << t << endl;
		cout << i << " = " << t << endl;

	}
	getchar();
    return 0;
}

