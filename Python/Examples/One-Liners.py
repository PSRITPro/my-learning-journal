#Swap two numbers

n1,n2=1,2
n1, n2 = n2, n1  

print(n1, n2) # - n2)

#Reverse string
str = "ABCD"
print(str[::-1])

#Factorial of a number
fact = lambda n:[1,0][n>1]
print(fact)

#palindrome
print(str == str[::-1])

from datetime import datetime
now = datetime.now()
formatted_time = now.strftime("%Y%m%d%H%M%S%f")

print(formatted_time)