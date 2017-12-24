"root.finder" = function(coefs = c(1,-0.7259,-0.0758 ), ar.order = T)
{
        # Program is set up to receive AR(p) roots from an arima.mle fit object.
        # as per Zivot and Wang page 83, for the characteristic eqn of the 
        # form a(z) = 1 - a1*z . . . ap*z^p = 0 
        # If used this way for AR coeffficients - stationarity requiress all unit roots to 
        # lie OUTSIDE the unit circle see the plot.
        # You can use the program for polynomials in the form a1*x^p + ... + ap*x + c = 0
        # by using the concatenate command c(c,a1, ... ap) in the function call 
        # The default plot axes limits are set at [-5,+5] in both dimensions. 
        # If a root falls outside this range you will get a warning. 
        
        coef = as.complex(coefs)
        p = length(coef)
        params <- vector("complex", p)
        if(!ar.order) {
                for(i in 1:p)
                        params[(p + 1 - i)] = coef[i]
        }
        else params <- coef
        roots <- polyroot(params)
        plot(roots, xlim = c(-5, 5), ylim = c(-5, 5))
        symbols(0, 0, circles = 1, add = T, inches = F, col = 5)
        cat("\n  Lag polynomial coefficients: ", coefs)
        cat("\n\n\t Polynomial Roots  \t Modulus \n")
        if(length(roots) == 1)
                cat("\n\t ", round(roots, digits = 4), "\t\t", round(abs(roots), digits = 4), "\n")
        else for(i in 1:length(roots))
                cat("\n \t ", round(roots[i], digits = 4), "\t\t", round(abs(roots[i]), digits = 4), "\n")
        cat("\n")
}

root.finder(coefs = c(1,-0.7259,-0.0758 ), ar.order = T)

