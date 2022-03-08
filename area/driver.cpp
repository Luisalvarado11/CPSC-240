#include <stdio.h>

extern "C" double area();

int main(int argc, char* argv[]) {
  double triangle_area = 0.0;

  printf("Welcome to Amazing Triangles programmed by Luis Alvarado on Febraury 2, 2022. \n");

  triangle_area = area();

  printf("The driver has recieved the number %.11lf and will simply keep it. \n", triangle_area);
  printf("An integer zero will now be sent to the operation system. Have a good day. bye\n");

  return 0;
}
