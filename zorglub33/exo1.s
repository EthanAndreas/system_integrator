main_calcul:
    push 1 
    push 3
    call calcul
    reset

main_prodscal:
    push 3
    push v2
    push v1
    call prodscal
    reset

v1:
    .word 1
    .word 2
    .word 3
v2:
    .word 1
    .word 2
    .word 3

main_racine:
    push 200
    call racine
    reset

// Function calcul

calcul: 
    // f(x,y) = x² - 2*x*y - y²
    push %b

    // calc x²
    ld [%sp+2],%a  
    mul %a,%a  

    // calc 2*x*y
    ld [%sp+3],%b 
    mul [%sp+2],%b 
    mul 2,%b       

    // calc x² - 2*x*y
    sub %b,%a  

    // calc y²
    ld [%sp+3],%b 
    mul %b,%b      

    // calc f(x)
    sub %b,%a    

    pop %b         
    rtn

// Function prodscal

prodscal:
    push %b
    push 0
    push 0

for:
    // get n 
    ld [%sp+6],%a
    cmp [%sp],%a
    jge end_for

    // get v1[i]
    ld [%sp+4],%a
    add [%sp],%a
    ld [%a],%a

    // get v2[i]
    ld [%sp+5],%b
    add [%sp],%b
    ld [%b],%b

    // calc v1[i] * v2[i]
    mul %a,%b
    add [%sp+1],%b

    // p get the result
    st %b,[%sp+1]

    // i = i + 1
    ld [%sp],%a
    add 1,%a
    st %a,[%sp]

    jmp for

end_for:
    // reload p into a  
    ld [%sp+1],%a
    pop %b
    pop %b
    pop %b
    rtn

// Function of root

racine:
    push %b
    ld [%sp+2],%a

    // calc r = inf + (sup - inf)/2
    ld %a,%b // sup = n
    sub 1,%b
    div 2,%b
    add 1,%b

    // put r on the stack
    push %b

    // save sup on the stack
    push %a

    // save inf on the stack
    ld 1,%b
    push %b

condition_1:
    // calc r²
    ld [%sp+2],%b
    mul %b,%b

    // while conditions n°1
    cmp %b,%a // r² > n      
    jle condition_2

    jmp while
    
condition_2:
    // calc (r+1)²
    ld [%sp+2],%b
    add 1,%b
    mul %b,%b

    // while condition n°2
    cmp %b,%a // (r+1)² <= n
    jgt end_of_while

    jmp while

while: 
    // calc r²
    ld [%sp+2],%b
    mul %b,%b

    // if condition
    cmp %b,%a // r² > n
    jle else

    // sup = r
    ld [%sp+2],%b
    st %b,[%sp+1]

    jmp end_of_if_else
    
else: 
    // inf = r
    ld [%sp+2],%b
    st %b,[%sp]

    jmp end_of_if_else

end_of_if_else:  
    // calc r
    ld [%sp+1],%b
    sub [%sp],%b
    div 2,%b
    add [%sp],%b

    // save r on the stack
    st %b,[%sp+2]

    jmp condition_1

end_of_while:
    pop %b
    pop %b
    ld [%sp+2],%a
    pop %a
    ld [%sp],%b
    pop %b
    rtn