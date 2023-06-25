package test;
import java.util.Scanner;

public class HomeWork1 {
	public static void main(String[] args) {
		// initializing the board
		int[][] board = {{0,1,0,1,0,1,0,1},
						 {1,0,1,0,1,0,1,0},
						 {0,1,0,1,0,1,0,1},
						 {0,0,0,0,0,0,0,0},
						 {0,0,0,0,0,0,0,0},
						 {2,0,2,0,2,0,2,0},
						 {0,2,0,2,0,2,0,2},
						 {2,0,2,0,2,0,2,0}};
		print42(board);
		//Setting the number of moves in the total game
		Scanner s = new Scanner(System.in);
		System.out.println("How many rounds do you want to play?");
		String roundsString = s.nextLine();
		int rounds = (int) roundsString.charAt(0)-48;
		for (int d=0; d<rounds; d++) {
			// Player 1 moves
			Move(1, board);
			// The board is printed
			print42(board);
			// Player 2 moves
			Move(2,board);
			// The board is printed
			print42(board);
		}
		System.out.println();
		System.out.println(decider(Counter(board,1), Counter(board,2)));
	}
	
	// Method for printing the board
	private static void print42(int [][] b) {
		System.out.println("    0 1 2 3 4 5 6 7 <- X axis");
		System.out.println("  +----------------+");
		for (int i = 0; i<=7;i++) {
			System.out.print(i+" | ");
			for (int j = 0; j<=7;j++) {
				System.out.print(in(b[i][j]));
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

	// Method for movement on the board
	private static int[][] Move (int player, int[][] board) {
		// Variables are initialized
		int breakvar = 0;
		String pl = "";
		int plno = 0;
		int opponent = 0;
      	int moveStandartY = 0;
        int moveKillY = 0;
        
        // Variables are customized so they match the player
        if (player==1){
        	pl = "Player 1";
    		plno = 1;
    		opponent = 2;
    		moveStandartY = 1;
    		moveKillY = 2;
        }
    	if (player==2) {
    		pl = "Player 2";
    		plno = 2;
    		opponent = 1;
    		moveStandartY = -1;
    		moveKillY = -2;
    	}
    	
       	// The player is asked which position they want to move from
		while(breakvar == 0) {
			Scanner s = new Scanner(System.in);
			System.out.println(pl + ", which piece do you want to move " + "(write it as (y,x):");
			String posfromstring = s.nextLine();
			int[] frompos = {(int) posfromstring.charAt(1)-48,(int) posfromstring.charAt(3)-48};
		
			// Checks if the position is legal
			if ((frompos[1]<=7 && frompos[1]>=0) && (frompos[0]<=7 && frompos[0]>=0) && board[frompos[0]][frompos[1]]==plno) {
				// The player is asked where to move
				innerloop: while(true) {
					Scanner t = new Scanner(System.in);
					System.out.println(pl + ", where do you want to move "+ "(write it as (y,x):");
					String postostring = t.nextLine();
					int[] topos = {(int) postostring.charAt(1)-48,(int) postostring.charAt(3)-48};
					// Checks if the move is a simple legal move
					if ((topos[1]<=7 && topos[1]>=0)&& (topos[0]<=7 && topos[0]>=0)&&(board[topos[0]][topos[1]]==0) && (topos[0]==(frompos[0]+moveStandartY)) && ((topos[1]==(frompos[1]+moveStandartY))||(topos[1]==(frompos[1]-moveStandartY)))) {
						board[frompos[0]][frompos[1]] = 0;
						board[topos[0]][topos[1]] = plno;
						breakvar = 1;
						break innerloop;
					}
					// Checks if the move is a jump that kills an opponent
					if ((topos[1]<=7 && topos[1]>=0) && (topos[0]<=7 && topos[0]>=0) && (board[topos[0]][topos[1]]==0) && (topos[0]==(frompos[0]+moveKillY)) && ((topos[1]==(frompos[1]+moveKillY)) && (board[topos[0]+moveStandartY][topos[1]+moveStandartY] == opponent))) {
						board[frompos[0]][frompos[1]] =0;
						board[topos[0]][topos[1]] =plno;
						board[topos[0]+1][topos[1]+1] =0;
						breakvar = 1;
						break innerloop;
					}
					// Same as before but other direction
					if ((topos[1]<=7 && topos[1]>=0) && (topos[0]<=7 && topos[0]>=0) && (board[topos[0]][topos[1]]==0) && (topos[0]==(frompos[0]+moveKillY)) && ((topos[1]==(frompos[1]-moveKillY)) && (board[topos[0]+moveStandartY][topos[1]-moveStandartY] == opponent))) {
						board[frompos[0]][frompos[1]] =0;
						board[topos[0]][topos[1]] =plno;
						board[topos[0]+1][topos[1]-1] =0;
						breakvar = 1;
						break innerloop;
					}
					else {
						// Wrong move
						System.out.println("Ilegal move. Try again");
					}
				}
			}
			else  {
			// Wrong initial position
			System.out.println("Wrong initial position. Try again");
			}
		}
		// The updated board is returned
		return(board);
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
	private static String decider (int pl1, int pl2) {
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
