"RvsS" = function(n)
{
	# Example taken from: An Introduction to RNotes on R: A Programming Environment for Data Analysis 
	# and Graphics Version 2.12.0 (2010-10-15) by W. N. Venables, D. M. Smith and the R Development Core Team.
	# This cubing function demonstrates one of the fundamental differences between R and S coding. 
	# Note that n is not a local variable - it is a parameter in the initial function call.
	# However, the function sq() (declared in-line) has a free variable n in it - it is not a parameter there.  
	# S+ (static scope) resolves this by searching the database for n and if it finds it the will square 
	# the value and then multiply it by the value the user assigned it when invoking the function.  
	# In general, this is not likely to give the right answer! 
	# R (lexical scope), on the other hand, looks back through the sequence of nested calls and uses the 
	# first actively bound n it can find, which here is the n that is a parameter in the RvsS(n) function.  
	# So the code works in R. If R fails to find an n in the function call sequence it will end up looking in the 
	# database, as per S+. (However, if n assigned a new value in the calling function RvsS(), the new value would be used.) 
	# Motto - Code very carefully! 
	       
	sq = function(){ n * n}
	n * sq()
}
