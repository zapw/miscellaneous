dimensions

Because the array will decay to pointer and to calculate offset to the elements of the array you do not need to know the innermost dimension.
Offset to a[i][j][k] is i*nj*nk+j*nk+k (where nj and nk are corresponding dimensions).




a[i][j] is really (address of a) + i*sizeof(int)*second_dimension + j*sizeof(int)
a[i][j][k] is really (address of a) + i*sizeof(int)*second_dimension*third_dimension + j*sizeof(int)*third_dimension + k*sizeof(int)
a[i][j][k][m] is really (address of a) + i*sizeof(int)*second_dimension*third_dimension*fourdimension + j*sizeof(int)*third_dimension*forth_dimension + k*sizeof(int)*fourdimension + m*sizeof(int)



Only the innermost dimension can be omitted. The size of elements in an array are deduced for the type given to the array variable. The type of elements must therefore have a known size.

char a[]; has elements (e.g. a[0]) of size 1 (8bit), and has an unknown size.
char a[6]; has elements of size 1, and has size 6.
char a[][6]; has elements (e.g. a[0], which is an array) of size 6, and has an unknown size.
char a[10][6]; has elements of size 6. and has size 60.
Not allowed:

char a[10][]; would have 10 elements of unknown size.
char a[][]; would have an unknown number of elements of unknown size.
The size of elements is mandatory, the compiler needs it to access elements (through pointer arithmetic).
