package Assign3;

import java.util.Scanner;




class player {
	private int playerNo;
	player(int pn){
		this.playerNo = pn;
	}
	public int getPlNo() {
		return this.playerNo;
	}
}


abstract class moves {
	
	@SuppressWarnings("unused")
	static void Move (player p1, board bb) {
		// Variables are initialized
		int breakvar = 0;
		int[][] b = bb.getBoard();
		String pl;
		int plno;
		if (p1.getPlNo()==1) {
			pl = "Player 1";
			plno=1;
		}
		else {
			pl = "Player 2";
			plno=2;
		}
		int opponent = (3+p1.getPlNo())/2;
      	int moveStandartY = 1*p1.getPlNo();
        int moveKillY = 2*p1.getPlNo();
    	
       	// The player is asked which position they want to move from
		while(breakvar == 0) {
			try {
				@SuppressWarnings("resource")
				Scanner s = new Scanner(System.in);
				System.out.println(pl + ", which piece do you want to move " + "(write it as (y,x)):");
				String posfromstring = s.nextLine();
				for (;;) {
					if (posfromstring.charAt(0)=='(' && posfromstring.charAt(2)==',' && posfromstring.charAt(4)==')') {
						break;
					}
					else {
						System.err.println("Invalid input, make sure it is correct.");
						System.out.println("");
						System.out.println(pl + ", which piece do you want to move " + "(write it as (y,x)):");
						posfromstring = s.nextLine();
					}
				}
				int[] frompos = {(int) posfromstring.charAt(1)-48,(int) posfromstring.charAt(3)-48};
				
				// Checks if the position is legal
				if ((frompos[1]<=7 && frompos[1]>=0) && (frompos[0]<=7 && frompos[0]>=0) && b[frompos[0]][frompos[1]]==plno) {
					// The player is asked where to move
					innerloop: while(true) {
						@SuppressWarnings("resource")
						Scanner t = new Scanner(System.in);
						System.out.println(pl + ", where do you want to move "+ "(write it as (y,x)):");
						String postostring = t.nextLine();
						for (;;) {
							if (postostring.charAt(0)=='(' && postostring.charAt(2)==',' && postostring.charAt(4)==')') {
								break;
							}
							else {
								System.err.println("Invalid input, make sure it is correct.");
								System.out.println("");
								System.out.println(pl + ", where do you want to move "+ "(write it as (y,x)):");
								postostring = s.nextLine();
							}
						}
						int[] topos = {(int) postostring.charAt(1)-48,(int) postostring.charAt(3)-48};
						// Checks if the move is a simple legal move
						if ((topos[1]<=7 && topos[1]>=0)&& (topos[0]<=7 && topos[0]>=0)&&(b[topos[0]][topos[1]]==0) && (topos[0]==(frompos[0]+moveStandartY)) && ((topos[1]==(frompos[1]+moveStandartY))||(topos[1]==(frompos[1]-moveStandartY)))) {
							b[frompos[0]][frompos[1]] = 0;
							b[topos[0]][topos[1]] = plno;
							breakvar = 1;
							break innerloop;
						}
						// Checks if the move is a jump that kills an opponent
						if ((topos[1]<=7 && topos[1]>=0) && (topos[0]<=7 && topos[0]>=0) && (b[topos[0]][topos[1]]==0) && (topos[0]==(frompos[0]+moveKillY)) && ((topos[1]==(frompos[1]+moveKillY)) && (b[topos[0]+moveStandartY][topos[1]+moveStandartY] == opponent))) {
							b[frompos[0]][frompos[1]] =0;
							b[topos[0]][topos[1]] =plno;
							b[topos[0]+1][topos[1]+1] =0;
							breakvar = 1;
							break innerloop;
						}
						// Same as before but other direction
						if ((topos[1]<=7 && topos[1]>=0) && (topos[0]<=7 && topos[0]>=0) && (b[topos[0]][topos[1]]==0) && (topos[0]==(frompos[0]+moveKillY)) && ((topos[1]==(frompos[1]-moveKillY)) && (b[topos[0]+moveStandartY][topos[1]-moveStandartY] == opponent))) {
							b[frompos[0]][frompos[1]] =0;
							b[topos[0]][topos[1]] =plno;
							b[topos[0]+1][topos[1]-1] =0;
							breakvar = 1;
							break innerloop;
						}
						else {
							// Wrong move
							System.err.println("Ilegal move. Try again");
						}
					}
				}
				else  {
				// Wrong initial position
				System.err.println("Wrong initial position. Try again");
				}
			}
			catch (StringIndexOutOfBoundsException e) {
				System.err.println("Input must be a tuple of integer values.");
			}
		}
		// The updated board is returned
		bb.update(b);
	}
}

class board {
	private int[][] b;
	public board(int[][] b){
		this.b = b;
	}
	
	public int[][] getBoard(){
		return this.b;
	}
	
	public void update(int[][] bb) {
		this.b = bb;
	}
	// Method for printing the board
	public void print() {
		System.out.println("    0 1 2 3 4 5 6 7 <- X axis");
		System.out.println("  +----------------+");
		for (int i = 0; i<=7;i++) {
			System.out.print(i+" | ");
			for (int j = 0; j<=7;j++) {
				System.out.print(in(this.b[i][j]));
			}
			System.out.print("\n");
		}
	}
	
	// Method for turning 1, 2 and 0's into strings 
	private static String in(int arg) {
		if (arg==1) {
			return "1 ";
		}
		else if (arg==2) {
			return "2 ";
		}
		else {
			return "  ";
		}
	}
}

public class Assign3 {
	@SuppressWarnings("resource")
	public static void main(String[] args) {
		player p1 = new player(1);
		player p2 = new player(-1);
		// initializing the board
		board b = new board(new int[][] {{0,1,0,1,0,1,0,1},
						 	{1,0,1,0,1,0,1,0},
						 	{0,1,0,1,0,1,0,1},
						 	{0,0,0,0,0,0,0,0},
						 	{0,0,0,0,0,0,0,0},
						 	{2,0,2,0,2,0,2,0},
						 	{0,2,0,2,0,2,0,2},
						 	{2,0,2,0,2,0,2,0}});
		b.print();
		//Setting the number of moves in the total game
		Scanner s = new Scanner(System.in);
		int breakvar = 0;
		while(breakvar == 0) {
			// Player 1 moves
			moves.Move(p1, b);
			// The board is printed
			b.print();
			// Player 2 moves
			moves.Move(p2,b);
			// The board is printed
			b.print();
			System.out.println("Do you wish to continue, y/n? ");
			char con = s.nextLine().charAt(0);
			if (con=='y') {
				breakvar = 0;
			}
			if (con=='n') {
				breakvar = 1;
			}
			if (con != 'n' && con != 'y'){
				System.out.println(con);
				System.err.println("Wrong input, play another turn.");
			}
		}
		System.out.println(" ");
		System.out.println(decider(Counter(b.getBoard(),1), Counter(b.getBoard(),2)));
	}
	
	// Game counter method (counts number of pieces left)
	private static int Counter (int[][] board, int player){
		int res = 0;
		for (int i = 0; i<=7;i++) {
			for (int j = 0; j<=7;j++) {
				if (player == board[i][j]) {
					res += 1;
				}
			}
		}
	    return res; 
	}
	
	// Final score presentation
	static String decider (int pl1, int pl2) {
		if (pl1>pl2) {
			return "Congratulazions Player 1. You won with " + pl1 + " pieces against Player 2's "+ pl2 + " pieces.";
		}
		if (pl2>pl1) {
			return "Congratulazions Player 2. You won with " + pl2 + " pieces against Player 1's "+ pl1 +" pieces.";
		}
		else {
			return "Neither of you won. It ended with a tie where both of you had " + pl1+ " pieces left.";
		}
	}
}
