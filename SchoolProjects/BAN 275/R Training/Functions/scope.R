"scope" = function()
{
	i = 100000000
	a = 3
	
	for(i in 1:2) {
		b = i
		cat("\n In Scope for loop c = ", c, "\n") # global c = 6
		c = 2*c
	}
	a = b
	cat("\n In Scope a = ", a, "\n")
	cat("\n In Scope b = ", b, "\n")
	cat("\n In Scope c = ", c, "\n")
	cat("\n In Scope i = ", i, "\n")
	
	# index variable  i cannot be seen outside of the for loop

	cat("\n")
}
