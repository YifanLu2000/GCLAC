function [inliers, H] = MCDG_A(X0,Y0,threshold, epsilon)

motion_coherent = estimate_motion_coherent(X0, Y0, epsilon);

[inliers,H] = MCDG_affine_solver(X0, Y0, motion_coherent, threshold);
end