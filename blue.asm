########################################################
#       Concillo, Brian James C.        #
#        Moncano, Mark Louie C.         #
#           Paring, Irish A.            #
#               CPE 4B                  #
#          CPE413 PIT - Final           #
########################################################


.data
# notes for the song "blue" by yung kai (piano)
notes_blue:
.word 64, 63, 59, 64, 63, 59, 64, 63, 59,   # E, Eb, B (repeated)
      64, 66, 68,                           # E, F#, Ab
      71, 73, 76, 81, 80, 78, 78,           # B, Db, E, A, Ab, F#, F#
      75, 76, 78, 76, 71, 68, 69, 71, 75, 76,   # Eb, E, F#, E, B, Ab, A, B, Eb, E
      71, 73, 76, 81, 80, 75, 75,           # B, Db, E, A, Ab, Eb, Eb
      83, 81, 80, 76, 76, 76,               # B, A, Ab, E, E, E
      78, 78, 78, 80, 80, 80,               # F#, F#, F#, Ab, Ab, Ab
      75, 75, 75,                           # Eb, Eb, Eb
      # second loop
      71, 73, 76, 81, 80, 78, 78,           # B, Db, E, A, Ab, F#, F#
      75, 76, 78, 76, 71, 68, 69, 71, 75, 76,   # Eb, E, F#, E, B, Ab, A, B, Eb, E
      71, 73, 76, 81, 80, 75, 75,           # B, Db, E, A, Ab, Eb, Eb
      83, 81, 80, 76, 76, 76,               # B, A, Ab, E, E, E
      78, 78, 78, 80, 80, 80,               # F#, F#, F#, Ab, Ab, Ab
      75, 75, 75,                           # Eb, Eb, Eb


# durations for the rhythm of "blue" by yung kai (whole note, half note, etc.)
durations_blue:
.word 8, 8, 8, 8, 8, 8, 8, 8, 16,           # E, Eb, B (repeated), longer last B
      8, 8, 8,                              # E, F#, Ab
      4, 4, 8, 16, 8, 4, 4,                 # B, Db, E, A, Ab, F#, F#
      4, 8, 8, 8, 16, 8, 8, 8, 16, 16,      # Eb, E, F#, E, B, Ab, A, B, Eb, E
      16, 4, 8, 16, 8, 8, 8,                # B, Db, E, A, Ab, Eb, Eb
      8, 8, 8, 16, 8, 8,                    # B, A, Ab, E, E, E
      8, 8, 8, 8, 8, 16,                    # F#, F#, F#, Ab, Ab, Ab
      16, 16, 16,                           # Eb, Eb, Eb
      # second loop
      4, 4, 8, 16, 8, 4, 4,                 # B, Db, E, A, Ab, F#, F#
      4, 8, 8, 8, 16, 8, 8, 8, 16, 16,      # Eb, E, F#, E, B, Ab, A, B, Eb, E
      16, 4, 8, 16, 8, 8, 8,                # B, Db, E, A, Ab, Eb, Eb
      8, 8, 8, 16, 8, 8,                    # B, A, Ab, E, E, E
      8, 8, 8, 8, 8, 16,                    # F#, F#, F#, Ab, Ab, Ab
      16, 16, 16                            # Eb, Eb, Eb


# delay flags controlling the amount of delay (300ms, 600ms, or 900ms)
delays_blue:
.byte  0, 0, 0, 0, 0, 0, 0, 0, 0,           # 0 for 300ms delay, 1 for 600ms delay, 2 for 900ms
       0, 0, 0,                          
       0, 0, 0, 0, 0, 0, 1,              
       0, 0, 0, 0, 1, 0, 0, 0, 2, 2,    
       0, 0, 0, 0, 0, 0, 1,              
       0, 0, 0, 0, 0, 0,                
       0, 0, 0, 0, 0, 0,                
       0, 0, 0,                          
       # second loop
       0, 0, 0, 0, 0, 0, 1,              
       0, 0, 0, 0, 1, 0, 0, 0, 2, 2,    
       0, 0, 0, 0, 0, 0, 1,              
       0, 0, 0, 0, 0, 0,                
       0, 0, 0, 0, 0, 0,                
       0, 0, 0                          


# Number of notes in the song
length_blue: .word 92


.text
main:
    # Play the translated guitar melody
    la $s0, notes_blue
    la $s1, durations_blue
    la $s2, delays_blue
    lw $t0, length_blue
    li $s4, 200             # Base duration (eighth note) in ms


    # Call the subroutine to play notes
    jal play_song
   
    li $v0, 10 # Exit
    syscall


play_song:
    # Play notes in a loop
    li $t1, 0                       # Initialize index
   
play_loop:
    beq $t1, $t0, play_done         # Exit loop when all notes are played


    # Load note, duration, and async flag
    lw $a0, 0($s0)                  # Load current note
    lw $t2, 0($s1)                  # Load duration multiplier
    lb $t3, 0($s2)                  # Load delay flag
    mul $a1, $s4, $t2               # Calculate duration
    li $a2, 0                       # MIDI patch (piano)
    li $a3, 64                      # Volume
   
    j sync_play             # Play note
    j adjust_delay              # Adjust delay
   
sync_play:
    li $v0, 31                      # Synchronous play
    syscall


adjust_delay:
    beqz $t3, delay_350ms           # If delay flag is 0, delay is 300ms
    beq $t3, 1, delay_700ms         # If delay flag is 1, delay is 600ms
    j delay_1050ms              # else delay is 900ms


delay_350ms:
    li $v0, 32                      # Sleep syscall
    li $a0, 300                     # Delay for 300ms
    syscall
    j next_note


delay_700ms:
    li $v0, 32                      # Sleep syscall
    li $a0, 600                     # Delay for 600ms
    syscall
    j next_note
   
delay_1050ms:
    li $v0, 32                      # Sleep syscall
    li $a0, 900                     # Delay for 900ms
    syscall
    j next_note


next_note:
    addi $s0, $s0, 4                # Move to next note
    addi $s1, $s1, 4                # Move to next duration
    addi $s2, $s2, 1                # Move to next delay flag
    addi $t1, $t1, 1                # Increment index
    j play_loop


play_done:
    jr $ra                          # Return to caller


