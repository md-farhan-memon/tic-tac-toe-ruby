# Tic Tac Toe - Ruby

A classic Tic Tac Toe game built in ruby and can be played on any Terminal.

To play the game, run the following command

````
ruby play.rb
````

It supports a Grid size upto 10x10.

Technically, you can edit and increase the grid size to any number, the logic written is generic and applicable to any grid size.

It has 3 modes of game play:

* Human vs Human
* Human vs Computer
* Computer vs Computer

A sample game output played between computer and computer:

````
What is the grid size you want to play? (Enter number between 1 - 10): 4
How would you like to play?
1. Human versus Human
2. Human versus Computer
3. Computer versus Computer
4. Exit

Enter your option: 3
Player O's move:

O                   
                    
                    
                    
---------------------------------------------------------------
Player X's move:

O                   
X                   
                    
                    
---------------------------------------------------------------
Player O's move:

O                   
X                   
O                   
                    
---------------------------------------------------------------
Player X's move:

O                   
X                   
O                   
X                   
---------------------------------------------------------------
Player O's move:

O    O              
X                   
O                   
X                   
---------------------------------------------------------------
Player X's move:

O    O              
X    X              
O                   
X                   
---------------------------------------------------------------
Player O's move:

O    O    O         
X    X              
O                   
X                   
---------------------------------------------------------------
Player X's move:

O    O    O    X    
X    X              
O                   
X                   
---------------------------------------------------------------
Player O's move:

O    O    O    X    
X    X              
O    O              
X                   
---------------------------------------------------------------
Player X's move:

O    O    O    X    
X    X    X         
O    O              
X                   
---------------------------------------------------------------
Player O's move:

O    O    O    X    
X    X    X    O    
O    O              
X                   
---------------------------------------------------------------
Player X's move:

O    O    O    X    
X    X    X    O    
O    O              
X    X              
---------------------------------------------------------------
Player O's move:

O    O    O    X    
X    X    X    O    
O    O    O         
X    X              
---------------------------------------------------------------
Player X's move:

O    O    O    X    
X    X    X    O    
O    O    O    X    
X    X              
---------------------------------------------------------------
Player O's move:

O    O    O    X    
X    X    X    O    
O    O    O    X    
X    X         O    
---------------------------------------------------------------
Player X's move:

O    O    O    X    
X    X    X    O    
O    O    O    X    
X    X    X    O    
---------------------------------------------------------------

Well, it's a TIE...
````