//****************************************************************************************************************************
//Program name: "Euclidean Length".
// This program will allow a user to input float numbers in an array of size 7, and display the contents. It will also
// perform the Euclid function called length.
// Copyright (C) 2022 Kyle Chan.                                                                           *
//                                                                                                                           *
//This file is part of the software program "Euclidean Length".
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY// without even the implied          *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************

//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Kyle Chan
//  Author email: kchan21@csu.fullerton.edu
//
//Program information
//  Program name: Euclidean Length
//  Programming languages: Assembly, C++, bash
//  Date program began: 2022 October 12
//  Date of last update: 2022 October 12
//  Date of reorganization of comments: 2022 October 18
//  Files in this program: driver.cpp, manager.asm, displayArray.cpp, sumArray.asm, fillArray.asm, run.sh
//  Status: Finished.  The program was tested extensively with no errors in WSL 2022 Edition.
//
//This file
//   File name: driver.cpp
//   Language: C++
//   Max page width: 132 columns
//   Compile: g++ -c -Wall -no-pie -m64 -std=c++17 -o displayArray.o displayArray.cpp
//   Link: g++ -m64 -no-pie -o final.out manager.o driver.o fillArray.o isFloat.o displayArray.o sumArray.o -std=c++17
//   Purpose: This is function takes in an array and it's size and prints out the values of the array.
//========================================================================================================

#include <iostream>

extern "C" void displayArray(double arr[], int arr_size);

//Prints the contents of the array, up to arr_size, determined by the fill asm module
void displayArray(double arr[], int arr_size) {
  for (int i = 0; i < arr_size; i++)
  {
    printf("%.10lf\n", arr[i]);
  }
}
