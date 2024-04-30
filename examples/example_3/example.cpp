// (C) Copyright 2016-2022 Xilinx, Inc.
// All Rights Reserved.
//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#include <iostream>

constexpr size_t N = 50;

using namespace std;

void example_5(int in[N], int out[N]) {

  for (size_t i = 0; i < N; ++i) {
    out[i] = in[i] / 8;
  }

  for (size_t i = 0; i < N; ++i) {
    out[i] = in[i] * 8;
  }

  for (size_t i = 0; i < N; ++i) {
    out[i] = in[i] / 8;
  }
}

void example_4(int in[N], int out[N]) {

  for (size_t i = 0; i < N; ++i) {
    out[i] = in[i] * 8;
  }
  example_5(out, out);

}

void example_3(int in[N], int out[N]) {

  for (size_t i = 0; i < N; ++i) {
    out[i] = in[i] / 2;
  }
  example_4(out, out);

}

void example_2(int in[N], int out[N]) {

  for (size_t i = 0; i < N; ++i) {
    out[i] = in[i] * 2;
  }
  example_3(out, out);

}

void example(int a[N], int b[N]) {
#pragma HLS INTERFACE m_axi port = a depth = N
#pragma HLS INTERFACE m_axi port = b depth = N
#pragma HLS interface s_axilite register port=return
#pragma HLS RealProbe

  int buff[N];
  for (size_t i = 0; i < N; ++i) {
#pragma HLS PIPELINE II = 1
    buff[i] = a[i];
    buff[i] = buff[i] + 100;
    b[i] = buff[i];
  }
  example_2(b, b);
}

int main() {

  int in[N], res[N];
  for (size_t i = 0; i < N; ++i) {
    in[i] = i;
  }

  example(in, res);

  for (int i = 0; i < N; ++i)
    if (res[i] != i + 100) {
      cout << "Test failed.\n";
      return 1;
    }

  cout << "Test passed.\n";
  return 0;
}
