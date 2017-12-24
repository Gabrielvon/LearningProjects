######### All S+ code below is R code compliant  - except for colMaxs

# vectors by concatination/seq/rep etc. or assignment
x.vec = rnorm(5)

# matrix creation by matrix function

x.mat = matrix(rnorm(25),5,5)

# post muliply (5x5)*(5x1) => (5x1)  column vector

z.mat1 = x.mat%*%x.vec 

# premultiply (1x5)*(5x5) => (1x5) row vector

z.mat2 = t(x.vec)%*%x.mat 

# pre and post muliply to a scalar

z.mat3 = t(x.vec)%*%x.mat%*%x.vec  

#invert x.mat 

x.mat.inv = solve(x.mat) 

# check  x.mat%*%x.mat.inv = I  

  I.check  =  x.mat%*%x.mat.inv
  max.off.diag = max(abs(I.check- diag(5)))

matrix(1:6, nrow =2)

matrix(1:6, nrow=2, byrow=T)

# wt, ht, waist (inches)

my.data = c(150, 65, 32, 180, 68, 34, 120, 67, 30, 135, 67, 31)

people.dat = matrix(my.data, 4,3, byrow = T)  

dimnames(people.dat)
dimnames(people.dat)= list(c("p1", "p2", "p3", "p4"), c("Weight", "Height", "Waist")) 
dimnames(people.dat)

Gender = c(1,0,1,0)

people.dat.2 = cbind(people.dat,Gender)

colMeans(people.dat.2)
colSums(people.dat.2)
# colMaxs(people.dat.2)  S+
#  colMax(people.dat.2)   #for R   package xcms


people.dat.2[,"Gender"]

people.dat.2[1,1]

people.dat.2[2:3,2:3]
#######################################################

Gender.smpl  = people.dat.2[,"Gender"] > 0
people.dat.3 = people.dat.2[Gender.smpl,]
class(people.dat.3)


#data frames 
people.df1 = data.frame(people.dat.2)

Category = c("a","b","c","d")

people.df3 = cbind(people.df1, Category)

name = dimnames(people.df3)
#dimnames(people.df3)[[2]][5] = "Category"

# Lists  aggregations of unlike data types

allKinds = list(5, x.vec, x.mat, people.df1) 

allKinds

allKinds[[1]]

allKinds[[2]]
  
allKinds[[2]][2]

allKinds[[3]]

allKinds[[3]][1,2:3]

allKinds[[4]]

allKinds[[4]] [2:3, 3:4]
