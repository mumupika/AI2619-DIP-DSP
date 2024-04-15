# %% [markdown]
# # DFT experiment
# ### In the following experiment, we implement the Discrete Fourier Transformation in four different ways, the naive way, the divide and conquer way, using numpy's FFT, and using sparse matrix multiplication, and evaluate the executing time.

# %% [markdown]
# ## Step 0: import all necessary toolkits.

# %%
import numpy as np
import scipy as scp
import time
import math
import matplotlib.pyplot as plt
from math import cos as cos
from math import sin as sin
from math import pi as pi
from math import log2 as log2
from math import log10 as lg
from math import exp
from scipy.sparse import block_diag
from scipy import sparse

# %% [markdown]
# ## Step 1: Generating sequences
# ### from 2 to $2^{24}$ ,and check one of the seuqence.

# %%
# 1.Generating integer sequences;
sequences=[]
for i in range(1,24):
    sample=[]
    for j in range(2**(i)):
        sample.append(np.random.randint(0,10))
    sequences.append(sample)

# %%
print(sequences[4]) #This is 2**5.

# %% [markdown]
# ## Step 2: Using for iteration to compute DFT (Naive way)
# ### This needs $O(n^2)$.

# %% [markdown]
# ### Naive DFT:
# The naive dft can be expressed as: $\displaystyle X[k]=\sum_{n=0}^{N-1}x[n]W_N^{k}$, with $\displaystyle W_N^k=e^{-j\dfrac{2\pi}{N}nk}$, with $j$ is the unit imaginary.
# 
# For each k, it will operate multiplication and add for $2n-1$ times and $n$ times to calculate all $X[k]$. So the asymptotic time complexity is $O(n^2)$.
# 
# For a better result output, we round the bits to 8 digit.

# %%
def DFT_0(sample):
    sample_output=[]
    N=len(sample)
    for i in range(N):
        real=0
        img=0
        for j in range(N):
            real+=sample[j]*cos(-2*pi*i*j/N)
            img+=sample[j]*sin(-2*pi*i*j/N)    # in fact this should be count in complexity.
        # After inner iteration
        real=round(real,8)
        img=round(img,8)
        output=complex(real,img)
        end_time=time.time()
        sample_output.append(output)
    return sample_output

# %%
test_sample=[0,1,2,3,4,5,6,7]
output=DFT_0(test_sample)
for i in range(len(test_sample)):
    print(output[i],end=',')
    if i%3==2:
        print('\n')
np.fft.fft(test_sample)

# %% [markdown]
# ## Step 2: Use Divide and conquer to do DFT.
# Note that the recurse of python is time comsuming, we developed a new method that compute DFT in iteration.
# ### Step 2.1 Bit reverse and data pre_load.

# %% [markdown]
# ### The following method is called the gold raden algorithm. The time complexity for getiing the bit reversed is $O(n\log{n})$.
# From: An_improved_FFT_digit-reversal_algorithm,1989
# 
# <img src="./1.png" align="center" width="370" height="400">
# 

# %% [markdown]
# ### But we implemented a faster liniear bit reverse algorithm of $O(n)$.
# 
# We started from 0. we can easy find that $bitRev(0)=0$. When implementing $bitRev(x)$, $bitRev(\lfloor \dfrac{x}{2}\rfloor)$ is known. So we can rigfht shift x, then flip, then rigt shift one bit, we can have the bit reverse result except LSB.
# 
# Consider LSB now. If LSB is 0, then MSB after flip is 0. Else,MSB is 1. So we should add $2^{N-1}$ for a N digit bit reverse.
# 
# For example, set N=5.
# 
# 1. For $(1100)_2$, the left shift of it stores $(00110)_2$. Right shift this again get $(00011)_2$.
# 
# 2. For LSB, it is 1, so we should add $2^4$. Here we can implement by bitOR.
# 
# 3. Identify LSB is 1 or 0, we can use bitAND with 1 to judge it. So $(i\&1)<<(l-1)$ is: when LSB is 1, we add $2^{N-1}$. Else keep it.

# %% [markdown]
# ### The algorithm is developed by Elster, 1989.
# 
# From: Fast Bit-Reversal algorithms.
# 
# <img src='./2.png'>

# %%
def bitrev(inv):
    l=1
    n=len(inv)
    while (1 << l) < n: l+=1
    for i in range(len(inv)):
        inv[i]=(inv[i>>1]>>1) | (i&1)<<(l-1) # This is a magic function!!!

def gen_inv(N):
    inv=[]
    for i in range(N):
        inv.append(i)
    return inv

def data_deal(sample):
    N=len(sample)
    sample_dealed=[]
    inv=gen_inv(N)
    bitrev(inv)
    for i in range(N):
        sample_dealed.append(sample[inv[i]])
    return sample_dealed

# %%
inv=gen_inv(8)
bitrev(inv)
(inv)

# %% [markdown]
# ## Step 2: Implement the DFT by Divide and Conquer.
# ### By divide and conquer, we theoretically achieved $O(n\log{n})$. But in-built python may elapse more time.

# %%
def DFT_1_no_iter(sample):
    '''Use for 2**n sequences.'''
    sample=data_deal(sample)
    N=len(sample)
    output=list(sample)
    h=2
    while h<=N:
        j=0
        while j<N:
            for k in range(j,j+(h>>1)):
                w=complex(round(cos(-2*pi*(k-j)/h),8),round(sin(-2*pi*(k-j)/h),8))
                x=output[k]
                y=w*output[(h>>1)+k]
                output[k]=x+y
                output[(h>>1)+k]=x-y
            j+=h
        h <<= 1
    return output

# %% [markdown]
# The following is the verification of the correctness of our code.

# %%
print(np.fft.fft(sequences[4]))
output=DFT_1_no_iter(sequences[4])
for i in range(len(sequences[4])):
    print(output[i],end=',')
    if i%2==1:
        print('\n',end='')

# %% [markdown]
# ## Step 3: Using Matrix multiplication
# ### To calculate the DFT by matrix.
# ### Note that naive matrix multiplication is $O(n^3)$, and by sparse matrix multiplication, we use compress by row matrix to calculate it. Thus it is $O(an^2+bn^2)$ for a and b are compressed row numbers.

# %%
def Matrix_gen(N):
    count = 1
    j=complex(0,1)
    final_matrix=sparse.identity(N)
    N=N >> 1
    while N>0:
        identity=np.identity(N)
        omega=np.diag([w:=complex(round(cos(-2*pi*i/(N << 1)),8),round(sin(-2*pi*i/(N << 1)),8)) for i in range(N)])
        factor=np.concatenate((np.concatenate((identity,omega),axis=1),np.concatenate((identity,(-1)*omega),axis=1)),axis=0)
        B=factor
        for _ in range(count-1):
            B=block_diag((B,factor))
        B=sparse.csr_matrix(B)
        final_matrix=final_matrix.dot(B)
        N=N >> 1
        count=count << 1
    return final_matrix

def matrix_fft(sample):
    N=len(sample)
    sample_dealed=np.array(data_deal(sample)).reshape((len(sample),1))
    sample_dealed=sparse.csr_matrix(sample_dealed)
    matrix=Matrix_gen(N)
    output=matrix.dot(sample_dealed)
    return output

# %%
sample=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
print(np.fft.fft(sample))
print(matrix_fft(sample))

# %% [markdown]
# ## Step 4: Evaluate all times.
# ### Record their time.

# %%
times_DFT0=[]
times_DFT1=[]
times_FFT=[]
times_matrix=[]
for i in range(15):
    start_time=time.time()
    DFT_0(sequences[i])
    end_time=time.time()
    times_DFT0.append(end_time-start_time)
    

    start_time=time.time()
    matrix_fft(sequences[i])
    end_time=time.time()
    times_matrix.append(end_time-start_time)
    
for i in range(23):
    start_time=time.time()
    DFT_1_no_iter(sequences[i])
    end_time=time.time()
    times_DFT1.append(end_time-start_time)
    
    start_time=time.time()
    np.fft.fft(sequences[i])
    end_time=time.time()
    times_FFT.append(end_time-start_time)
    
print(times_matrix)
print(times_DFT0)
print(times_DFT1)
print(times_FFT)

# %%
plt.plot([log2(times_DFT0[i]) for i in range(len(times_DFT0))],'r',label="DFT_original")
plt.plot([log2(times_DFT1[i]) for i in range(len(times_DFT1))],'g',label="DFT_opt")
plt.plot([log2(times_FFT[i]) for i in range(len(times_FFT))],'b',label="numpy_FFT")
plt.plot([log2(times_matrix[i]) for i in range(len(times_matrix))],'y',label="matrix_fft")
plt.xticks([i for i in range(len(sequences))],[i+1 for i in range(len(sequences))])
plt.xlabel("Signal Length in log")
plt.ylabel("time in log2")
plt.legend()
plt.show()


