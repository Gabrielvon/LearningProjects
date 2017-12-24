day.max = function()
{
  require(quantmod) 
  require(timeSeries)
  require(tseries)
  
  getSymbols("AAPL")     # from quantmod
  dimnames(AAPL)
  AAPL.ts = timeSeries(AAPL)
  
  weeklyMax    = apply.weekly(AAPL.ts,FUN=function(x){ max = max(Ad(x))}) 
  weeklyMaxDay = apply.weekly(AAPL.ts,FUN=function(x){ max = max(Ad(x));
	                                                 index = match(max,Ad(x)); 
													 date = Ad(as.timeSeries(x))@positions[index];
													 date }) 

temp  = Ad(as.timeSeries(AAPL.ts))@positions
temp2 = as.POSIXct(temp, tz = "GMT", format = "%Y-%m-%d", origin = "1970-01-01")
max.dates = strptime(temp2,tz = "GMT", format = "%Y-%m-%d") 

dayOfweeklyMax = cbind(as.data.frame(weeklyMax),as.data.frame(as.character(dayOfweeklyMax)), Weekday)
Weekday = weekdays(dayOfweeklyMax)

colnames(maxAndDay) = c("Weekly Max","Date", "Weekday")  
print(head(maxAndDay))
print(head(AAPL.ts,21))
counts = table(maxAndDay[ ,"Weekday"])
barplot(counts, main = "Weekday Maxima", col = "steelblue")
}

day.max()

