package Assign3;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.Assert;
import org.junit.jupiter.api.Test;
import org.junit.platform.commons.annotation.Testable;


public class Assign3_test {
	@Test
	public static void main(String[] args) {
		//test of board method
		board b = new board(new int[][] {{0,1,0,1,0,1,0,1},
		 	{1,0,1,0,1,0,1,0},
		 	{0,1,0,1,0,1,0,1},
		 	{0,0,0,0,0,0,0,0},
		 	{0,0,0,0,0,0,0,0},
		 	{2,0,2,0,2,0,2,0},
		 	{0,2,0,2,0,2,0,2},
		 	{2,0,2,0,2,0,2,0}});
		int[][] update = new int[][] {{0,1,0,1,0,1,0,1},
		 	{1,0,1,0,1,0,1,0},
		 	{0,0,0,1,0,1,0,1},
		 	{0,0,1,0,0,0,0,0},
		 	{0,0,0,0,0,0,0,0},
		 	{2,0,2,0,2,0,2,0},
		 	{0,2,0,2,0,2,0,2},
		 	{2,0,2,0,2,0,2,0}};
		b.update(update);
		assertEquals(update,b.getBoard());
		
		//test of player method
		player p = new player(1);
		assertEquals(1,p.getPlNo());
		
		
		//test of decider method
		assertEquals(Assign3.decider(3,2),("Congratulazions Player 1. You won with " + 3 + " pieces against Player 2's "+ 2 + " pieces."));
		
	}
}
