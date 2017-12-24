
#####   All of the code below this point runs correctly under S+ 

# atomic data types: numeric (integer, double precision, complex), character, logical

##########   numeric data, assignements and arithmetic operators   #################

x = 2        # assignment operator
x <- 2       # alternate assignment operator

3 -> y       # can do but is ugly 

print(x)     # one way to look at a value in a variable 

y            # another way look at a value in a variable 
 

x + y
y/x

as.integer(y/x) # assign in integer form 

as.integer(y/x + x/y)              # note the difference 
as.integer(y/x) + as.integer(x/y)  # note the difference 

z = c(x,y)   # creates a vector 

zz = vector( "numeric" , 5)  # creates a vector of length 5 
zz

# arithmetic operators  
#   +, -, *, /, ^, %/% - last is the mod operator
# functios abs(), sine(), ...     
#

#  arithmetic operator effects on vectors - we will cover matrix/vector operators later

v1 = c(1,2,3)
v2 = c(10,11,12) 
x*v1                      # elementwise operation
v1*v2                     # elementwise operation
v1/v2                     # elementwise operation
  
my.complex = 4+3i
my.complex
abs(my.complex)

#  some useful functions

1:5 

seq(1,7)
seq(1,9,2) 
seq(9,1,-2)
seq(1, by = 0.7, length = 6) 

rep(4,6)
rep(c(0,1),3) 
rep(c("a","b","c"),2)
rep(1:3, 5)
rep(1:4, 1:4) 


#####     character data  ############

g = "b"
g

g = 'c' 
g

g = "First" 
g

h = 'Last'
h

c(h,g)
paste(g,h, sep =", ")

my.list = c("a", "b", "c")
my.list


my.list = c( c("a", "b", "c"), c(1,2,3))
class(my.list)


# logical (boolean) variables <  >  <=  >=  ==  != , & |

set.seed(100)
zz = sample(1:20, 10)
zz <= 10
(zz < 5 | zz > 13)
sum(as.integer((zz < 5 | zz > 13)))
sum(zz < 5 | zz > 13)
class((zz < 5 | zz > 13))

#####   complex data ########
w = 3+3i
plot(runif(50, -pi, pi))
unit.disk <- complex(arg=runif(50, -pi, pi))
plot(unit.disk, ,ylab ="Im",xlab="Re")
plot(complex(arg= c(-pi, -0.75*pi, -0.5*pi, - 0.25*pi, 0,  0.25*pi, 0.5*pi, 0.75*pi, pi)),ylab ="Im",xlab="Re")
c(-pi, -0.75*pi, -0.5*pi, - 0.25*pi, 0,  0.25*pi, 0.5*pi, 0.75*pi, pi)*57.2957795 


z = seq(0, 2*pi,length = 1000)
x = sin(z)
y = cos(z)
plot(x,y, type = "l")


plot(unit.disk, ,ylab ="Im",xlab="Re")
lines(x,y)

plot(complex(arg= c(-pi, -0.75*pi, -0.5*pi, - 0.25*pi, 0,  0.25*pi, 0.5*pi, 0.75*pi, pi)),ylab ="Im",xlab="Re")
lines(x,y)