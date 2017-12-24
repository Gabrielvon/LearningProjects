price.prob = function( po, mu, sigma, dist, t, pt, greater ) {
        # po - is the current price
        # mu -  is the drift term (the mean of the error distribution)
        # sigma - the standard deviation of the error distribution
        # dist - the distribution to be used, the choices are: “N” for the normal distribution and “LN” for the lognormal distribution. 
        # t - the number of days forward
        # pt - the price at time t
        # greater - a Boolean variable (TRUE/FASLSE) If TRUE return P( Price > =pt ), if FALSE return P( Price < pt ).        
        
        # Ex1: po=60, sigma=.25, mu=.01, find P(P>62) after 36 days
        # Ex2: po=60, mu=.002, sigma=.06, find (P36>65)
        
        if (dist == 'N') {
                E = po + mu*t
                s.d. = sigma * sqrt(t)        
                price.prob = 1 - pnorm((pt-E)/s.d., lower.tail = greater)
                # better way: price.prob=pnorm(pt,E,s.d.) #default is LOWER.TAIL
        } else if (dist == 'LN') {
                meanLog = log(po) + mu*t
                sdLog = sigma*sqrt(t)
                price.prob = 1 - plnorm(pt, meanlog = meanLog, 
                                        sdlog = sdLog, lower.tail = greater)
                # better way: price.prob=plnorm(pt,meanLog,sdLog)
        }

        cat('\n The probability of price that greater than',as.character(pt),'after', as.character(t),'days. \n')
        price.prob
}

price.prob(60,0.01,0.25,'N',36,62,T)
price.prob(60,0.002,0.06,'LN',36,65,T)

