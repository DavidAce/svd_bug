# svd_bug

Eigen::BDCSVD fails on this particular matrix with segmentation fault, presumably due to an AVX-related alignment error
when linking with Intel MKL and using the flag `EIGEN_USE_BLAS`
