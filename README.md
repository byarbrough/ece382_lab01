ece382_lab01
============

Assembly Language - "A Simple Calculator"

###Objective
This lab saw the development of a simple calculator which took values from ROM and outputted results into RAM. The calculator was able to add, subtract, multiply, and clear until either the end command was recieved or RAM was filled (there was no prention of the latter; the program would have just crashed).

###Preliminary Design
Originally, I intended to build the program based on the following flowchart:

_Prelab Flowchart_

![alt text](https://raw.githubusercontent.com/byarbrough/ece382_lab01/master/FlowChart.jpg "Basic Flowchart")

This design had a couple of flaws. First, I was not consistent in what exactly how I wanted to store things or when I wanted to read from anything. The basic idea was good though: store the first number and the operation instruction and then interpret the insturcion before deciding what to do next. I wanted to take advantage of loops to avoid writting redundant code, so depending on if there was a clear instruciton or not, the loop needed to go back to a differnet point (would the next value from ROM be a number or an instruciton?). After reconsidering these things and clarifying some of the instructions, this is a much more acurate flowchart for basic functionality.

_Rethought Flowchart_
*having computer difficulties, standby*

###Hardware
Hardware in this lab was relatively straightforward. The only two concerns on the MSP430 were ROM and RAM limitations. Because there is much more ROM on the chip than RAM, the user must be sure to not enter more values than there is space in RAM to store results from. Doing this would cause an overflow into other zones of the chip and would likely cause huge problems.

Also, it is important to note that the calculator only handles bytes. This means that the numbers must be positive integers ranging from 0-255 (0x00-0xFF)

###Code
Please see main.asm for code.

The code is organized into four segments:
1. Setup the calculator
2. Check for end or clear (and jump appropriately)
3. Check for add, subtract, or multiply (and perform appropriate action)
4. Submethods for storing, clearing, and handling overflow

I likely could have accomplished this project with fewer lines of code or more effeciently processor wise, but considering the resources available on the chip, I chose this method. Although I do use six registers (which is likely more than necesary) I think that my method prevents misinterpretation of numbers and safeguards agains overflow better. Additionally, it is simpler for a human to follow - this is good for debugging or for accesibility to other developers.

###Debugging
The basic addition and subtraction methods were extremely simple. The debugger was useful for verifying that things worked as intended, but there were not major issues.

####Multiplication
I didn't encounter a real problem until I began working with multiplicaiton. At first I considered it neccesary to determine if the number was odd or even so I would know if it was divisible by two. This would allow me to roatate the number a certian number of times (this method is far faster than simply adding in a loop). I accomplished this by popping off the LSB into the carry flag. After looking at some Wikipedia pages on the basics of 3rd grade long multiplication I realized that I didn't need to determine the eveness of the number; I could itteratively rotate through the carry and multiply almost exactly like the base ten method. I verified this with some hand calculations.

Getting this almost working introduced my most signifigant debugging issue. While attempting to detect overflow I realized that I would get 0xFF for things that definitly did not overflow and sometimes the loop would not end when it was supposed to. After extensive dubugging and a candy bar or two, I realized that when the MSB was 1 to begin with it was rotated through the carry out of order with the check. I simply had to rearange the order that some things happened in and it was dandy!

###Testing Methodology
Having test benches was convinent to know exactly what the instructor was looking for, but honestly they were kind of boring test benches. Most of my testing was done by working out random numbers by hand first to see exactly the bits should be doing. I could then put the same numebrs into ROM and compare the results. This made debugging ncie because I knew exactly what to expect and could almost immediately find out where something went wrong by observing the registers.

In addition to verifying that the calculator could do the numbers it was suposed to, I put in safeguards against overflow and negatives. These were easily testable by inserting absurd numbers and seeing what happened.

###Conclusions
Ultimately, I was very pleased with the performance of this calculator. Part of me (the one that doesn't like sleeping... or weekends) wishes we could have thrown in division as well - I figure it is essentially the opposite of multiplication, but maybe not.
It was educational to be able to see the functions of a calculator at the assembly level - it makes one realize that the computer has to accomplish a lot more work than a simple "+" makes it seem like. Also, this lab helped me make bounds in my understanding of assembly. Whereas at first I was relying on notes and in-class examples, by the end I was consulting almost exclusively the Family Users Guide.

###Documentation
Most of this lab was done on my own. C2C Ian Goodbody and I had a brief conversation deciding if the rotation method was indeed O(log(n)) or not. We concluded it was.
Also, C2C Sabin Park ansered my question that I did not need to worry that registers hold words, but I was only rotating bytes. Just as he said, it all worked out.
