"C" = function()
{
	## A demonstration of variable scope, pass by value and search behavior for non-local variables 
	## in a sequence of function calls. 
	## funC calls funcD and then funcE (internally defined) then wfcnE (externally defined).  
	## x is local to C, but there is also a global x in the database (first on the search path x =100
	## z is only global.   z = 400
	## the pass of local x in C to wfcncE demonstrates that R and S+ use by pass-by-value (not by-reference)
	## in function D, z is local to D, but x is initially a free variable.  Here S+ and R look to the database for x.
	## However, the function  E (fcnE) is defined in function C it has free variable x, here S+ looks to the database (x=100)
 	## and assignes 10000 to local x - not global x which is unchanged.  However R, looks to the environment that 
	## E was defined in, to resolve the free variable - finds x in C and assigns x =3 to create local x = 9 local to E, without 
 	## changing x in C which is local to C.
	## function W is externally defined, but is otherwise the same as E, note it goes to the database to resolve free value x
	## Note - This sequence of function calls works the same way in R.   
	
	x = 3
	D()
	
	E = function()
    {
	   x = x^2
	  cat("\n in E x = ", x, "\n")
    }
	
	E()
    W()       # same as E, but externally defined                     
		
	cat("\n in C, local x = ", x, "\n")
    
	
}
