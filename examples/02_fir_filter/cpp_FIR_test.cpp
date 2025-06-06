/*
 * Copyright 2020 Xilinx, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "cpp_FIR.h"

int main()
  {
    ofstream result;
    data_t output[251]={0,};
    data_t input[251]={0,};

	int retval=0;


		// Open a file to save the results
    result.open("result.dat");

    for (int i = 0; i <= 250; i++)
      input[i] = (data_t)i;
		// Apply stimuli, call the top-level function and save the results
    cpp_FIR(input, output);

    for (int i = 0; i <= 250; i++)
      {
        result << setw(10) << i;
        result << setw(20) << output[i];
        result << endl;
        cout << "input: " << i << ", output: " << output[i] << endl;

      }
    result.close();

	// Compare the results file with the golden results
	//retval = system("diff --brief -w result.dat result.golden.dat");
  retval = system("fc /W /L result.dat result.golden.dat");
	if (retval != 0) {
		printf("Test failed  !!!\n"); 
		retval=1;
	} else {
		printf("Test passed !\n");
  }

	// Return 0 if the test passes
  return retval;
  }

