//****************************************************************************************************************************
//Program name: "Float Comparison".  This program takes two floats as input. Then compares them and returns the larger float. 
//Copyright (C) 2022 Kyle Chan.
//                                                                                                                           *
//This file is part of the software program "Float Comparison".                                                                   *
//Float Comparison is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
//version 3 as published by the Free Software Foundation.                                                                    *
//Float Comparison is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
// Author name: Kyle Chan
// Author email: kchan21@csu.fullerton.edu
//
//Program information
// Program name: Float Comparison
// Programming languages: Two modules in c++ and one module in X86
// Date program began: 2022 Aug 31
// Date of last update: 2022 Sep 4
//
//  Files in this program: driver.cpp, isFloat.cpp, floatComparison.asm, run.sh
//  Status: Finished.
//
//This file
//   File name: isFloat.cpp
//   Language: C++
//   Max page width: 132 columns
//   Compile: g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp
//   Link: g++ -m64 -no-pie -o final.out floatComparison.o driver.o isFloat.o -std=c++17
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================

#include <iostream>

extern "C" bool isFloat(char [ ]);

bool isFloat(char w[ ])
{   bool result = true;
    bool onepoint = false;
    int start = 0;
    if (w[0] == '-' || w[0] == '+') start = 1;
    unsigned long int k = start;
    while (!(w[k] == '\0') && result )
    {    if (w[k] == '.' && !onepoint)
               onepoint = true;
         else
               result = result && isdigit(w[k]) ;
         k++;
     }
     return result && onepoint;
}