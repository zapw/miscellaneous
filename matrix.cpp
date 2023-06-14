template<typename T> 
struct matrix {
       	matrix(unsigned m, unsigned n) : m(m), n(n), vs(m*n) {} 
	T& operator ()(unsigned i, unsigned j) { 
		return vs[i + m * j]; 
	} 
	private: 
	unsigned m; 
	unsigned n; 
	std::vector<T> vs; 
}; /* column-major/opengl: vs[i + m * j], row-major/c++: vs[n * i + j] */

