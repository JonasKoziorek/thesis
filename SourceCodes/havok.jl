using DynamicalSystems
using LinearAlgebra
using ControlSystems
using Plots; plotly()

dx = Systems.lorenz([-8.0, 8.0, 27.0]; σ = 10.0, ρ = 28.0, β = 8/3)

time = 200.0
dt = 0.001
xdat,t = trajectory(dx, time-dt; Δt = dt)

function embed2(data, stackmax)
    H = zeros(stackmax,length(data)-stackmax);
    for k = 1:stackmax
        H[k,:] = data[k:end-stackmax-1+k]
    end  
    return H
end

stackmax = 100
H = embed2(xdat[:,1], stackmax);

U,S,V = svd(H)

# COMPUTE DERIVATIVES (4TH ORDER CENTRAL DIFFERENCE)
r = 15 # rank of havok model
# dV = zeros(maximum(size(V))-5,r)
# for i=3:maximum(size(V))-3
#     for k=1:r
#         dV[i-2,k] = (1/(12*dt))*(-V[i+2,k]+8*V[i+1,k]-8*V[i-1,k]+V[i-2,k])
#     end
# end
# trim first and last two that are lost in derivative
# V = V[3:end-3,1:r]
# # BUILD HAVOK REGRESSION MODEL ON TIME DELAY COORDINATES
# Xi = V\dV
# A = transpose(Xi[1:r-1,1:r-1])
# B = Xi[end,1:r-1]

x = V[1:end-1,1:r]
xprime = V[2:end,1:r]
Xi = xprime\x
B = Xi[1:r-1,r]
A = Xi[1:r-1,1:r-1]

sys = ss(A,B,I(r-1),0*B,dt)
L = 1:40000
xL = x[L,r]
xL = reshape(xL, (1,length(xL)))
y,t = lsim(sys,xL,dt*(L.-1); x0 = x[1,1:r-1])

sol = transpose(y[1:3, :])
plot(sol[:,1], sol[:,2], sol[:,3])
plot(V[:,1], V[:,2], V[:,3])
plot(xdat[:,1], xdat[:,2], xdat[:,3])

a = 1
# sigs = diag(S)
# beta = size(H,1)/size(H,2)
# thresh = optimal_SVHT_coef(beta,0) * median(sigs)
# r = length(sigs(sigs>thresh))
# r=min(rmax,r)

# # COMPUTE DERIVATIVES
# # compute derivative using fourth order central difference
# # use TVRegDiff if more error 
# dV = zeros(length(V)-5,r)
# for i=3:length(V)-3
#     for k=1:r
#         dV[i-2,k] = (1/(12*dt))*(-V[i+2,k]+8*V[i+1,k]-8*V[i-1,k]+V[i-2,k])
#     end
# end  
# # concatenate
# x = V(3:end-3,1:r)
# dx = dV

# #  BUILD HAVOK REGRESSION MODEL ON TIME DELAY COORDINATES
# # This implementation uses the SINDY code, but least-squares works too
# # Build library of nonlinear time series
# polyorder = 1
# Theta = poolData(x,r,1,0)
# # normalize columns of Theta (required in new time-delay coords)
# for k=1:size(Theta,2)
#     normTheta(k) = norm(Theta(:,k))
#     Theta(:,k) = Theta(:,k)/normTheta(k)
# end 
# m = size(Theta,2)
# # compute Sparse regression: sequential least squares
# # requires different lambda parameters for each column
# for k=1:r-1
#     Xi[:,k] = sparsifyDynamics(Theta,dx(:,k),lambda*k,1)  # lambda = 0 gives better results 
# end
# Theta = poolData(x,r,1,0)
# for k=1:length(Xi)
#     Xi(k,:) = Xi(k,:)/normTheta(k)
# end
# A = Xi(2:r+1,1:r-1).T
# B = A(:,r)
# A = A(:,1:r-1)
# %
# L = 1:50000
# sys = ss(A,B,eye(r-1),0*B)
# [y,t] = lsim(sys,x(L,r),dt*(L-1),x(1,1:r-1))