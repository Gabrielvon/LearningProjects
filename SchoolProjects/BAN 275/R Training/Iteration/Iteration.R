#  R code compliant


#################      for loop iteration

sum = 0

#simple iteration
for(i in 1:5) sum = sum + i     # note i is seen outside the iterative loop
	
cat("\n\n\t sum = ", sum,"\n") 
cat("\n\n\t i = ", i,"\n")  

#multiple line iteration
for(i in 1:5)
	{ 
		 sum = sum + i  
	    # other code in this code block	
	    # variables created in here seen outside
		b = 3*i
}      

cat("\n\n\t sum = ", sum,"\n") 
cat("\n\n\t b = ", b,"\n")  

sum = 0

for(i in 1:12)
	{ 
		 sum = sum + i  
	    # other code in this code block	
	    # variables created in here seen outside
		i = 2*i                        #  TWO i's ?????????
		cat("\n\t i = ", i)
}      

cat("\n\n\t sum = ", sum,"\n") 
cat("\n\n\t i = ", i,"\n")  




##############   while loop iteration  

sum = 0
j = 1 

while( j < 6) 	
	{
	    sum = sum + j     
	    cat("\n j = ", j , "\n")
	    j = j+1           # MUST increase iteration counter
	    
   }

cat("\n\n\t sum = ", sum,"\t j = ", j, "\n" )  # look at j


#############   repeat loop iteration - always entered into at least once
	
k = 0
sum = 0 

repeat
{
	k = k+1
	sum = sum +k
	if( sum >= 15) break
	cat("\n k = ", k , "\n")
} 	
	
cat("\n\n\t sum = ", sum,"\t k = ", k, "\n" )  # look at k  


# avoiding iteration by apply()

x <- matrix(20:1, nrow=5)
apply(x, 2, mean, trim=.25)


