.include "macros.asm"

.globl play

play:
    save_context

    li		$v0, 1              # continue game ----------------------------------------
    
    sll		$t0, $s2, 5			# start play - calc_i = i * 2^5
    sll		$t1, $s3, 2			# calc_j = j * 2^2
    add		$t0, $t0, $t1		# end[i][j] = calc_i + calc_j
    add		$t0, $t0, $s0		# board[i][j] = end[i][j] + board

    lw		$t1, 0($t0)	        # $t1 = board[i][j]

    beq		$t1, HIT, if_game_over	    # if board[i][j] == -1 ir para func. 'if_game_over'
    beq		$t1, NO_BOMB, elseif_reveal	    # if $t1 == NO_BOMB ir para func. 'if_reveal'
    if_game_over:
        li		$v0, 0		# stop game - lose
        j end_if_check
    elseif_reveal:
        jal		countAdjacentBombs		# ir para countAdjacentBombs e save $ra
        move 	$t1, $t6		        # $t1 <- x = countAdjacentBombs
        move 	$t0, $t5		        # $t0 = $t5
        sw		$t1, 0($t0)		        # board[i][j] = $t1

    bne		$t1, $zero, reveal_adjacent	# if $t1 !=zerot1 then goto target
        jal revealNeighboringCells
    reveal_adjacent:

        j end_if_check
    end_if_check:
    
    restore_context
    jr		$ra				    # retorna ao end. q chamou a função
    
    
