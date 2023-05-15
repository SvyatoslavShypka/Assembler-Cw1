.data
    msg_in1:    .asciiz  "Podaj liczbe1:"
    msg_in2:    .asciiz  "Podaj liczbe2:"
    msg_out1:   .asciiz "Wynik: "
    msg_out2:   .asciiz "    Status: "
    licz1:    .word 0     # Pierwsza liczba
    licz2:    .word 0      # Druga liczba
    wyn:      .word 0      # Wynik mno?enia
    status:   .word 0      # Pole statusu
    
.text
main:
     # Wypisz komunikat
     li $v0, 4           # instrukcja 4 -- print
     la $a0, msg_in1     # powiadomienie do wydruku
     syscall		 # wykonać instrukcje z $v0
     # wprowadz liczbe1
     li $v0, 5		 # instrukcja 5 -- wczytać z klawiatury
     syscall		 # wykonać instrukcje z $v0
     move $a1, $v0	 # wczytany z klawiatury numer kopiujemy do $a1
     sw $a1, licz1 	 # kopiujemy z $a1 do zmiennej licz1
     
     # Wypisz komunikat  
     li $v0, 4		 # instrukcja 4 -- print
     la $a0, msg_in2	 # powiadomienie do wydruku
     syscall		 # wykonać instrukcje z $v0
     # wprowadz liczbe2
     li $v0, 5		 # instrukcja 5 -- wczytać z klawiatury
     syscall		 # wykonać instrukcje z $v0
     move $a2, $v0	 # wczytany z klawiatury numer kopiujemy do $a1
     sw $a2, licz2 	 # kopiujemy z $a1 do zmiennej licz2 
          
    # Inicjalizacja zmiennych
    lw $t0, licz1          # Wczytaj pierwszś liczbś do $t0
    lw $t1, licz2          # Wczytaj drugą liczbę do $t1
    
    
    # Iteracja po cyfrach mnożnika
    li $t2, 0              # Inicjalizacja licznika cyfr
    
    loop:
        andi $t3, $t1, 1    # Pobierz najmniej znaczącą cyfrę mnożnika
        or $t7, $t3, $t1    # Jeżeli ostatnia cyfra z $t1 (liczba2) = 0 i w $t3 już nie ma jedynek $t7 uzyska zero dla wyjścia z cyklu
        beqz $t7, endloop   # Przy $t7 równe zero wychodzimy z cyklu
        
        # Mnożenie i dodawanie do wyniku        
        beqz $t3, skip	    # Jeżeli $t3 równe zero - jump do "skip" (omijamy dodawanie)
        addu $t4, $t0, $t4  # Dodaj mnożną do wyniku
        
   skip:      
        sltu $t5, $t4, $t0  # Sprawdź, czy wystąpił nadmiar (jeżeli $t4<$t0 - to znaczy po dodaniu wynik zmniejszył się)
        and $t5, $t5, $t3   # Jeżeli dodanie do mnożnej było ominięte, to nie trzeba zmieniać status - $t5 będzie zero
        or $t6, $t6, $t5    # Aktualizujemy pole statusu (jeżli wystąpił nadmiar - uzyska 1)
        sll $t0, $t0, 1     # Przesuwamy mnożną o jedną pozycję w lewo (mnożenie na dwa)        
        srl $t1, $t1, 1     # Przesuwamy mnożnik o jedną pozycję w prawo (pozbywamy się jedności dla wyszukiwania następnej jedynki)
        addiu $t2, $t2, 1   # Inkrementuj licznik cyfr
        j loop              # Powrót do początku pętli
    
    endloop:
        sw $t4, wyn         # Zapisz wynik w pamięci
        sw $t6, status      # Zapisz status w pamięci
        
        # wypisz komunikat wynik      
        li $v0, 4	    # instrukcja 4 -- print
        la $a0, msg_out1    # powiadomienie do wydruku
        syscall		    # wykonać instrukcje z $v0
          
        # Wyświetl wynik
        li $v0, 1           # Kod syscall dla wy?wietlania liczb
        lw $a0, wyn         # Przekazanie wyniku do $a0
        syscall		    # wykonać instrukcje z $v0
        
        # wypisz komunikat status      
        li $v0, 4           # instrukcja 4 -- print
        la $a0, msg_out2    # powiadomienie do wydruku
        syscall		    # wykonać instrukcje z $v0
        # wypisz status
        li $v0, 1           # Kod syscall dla wy?wietlania liczb
        lw $a0, status      # Przekazanie statusu do $a0
        syscall		    # wykonać instrukcje z $v0
        
        # Zakończ program
        li $v0, 10          # Kod syscall 10 dla zakończenia programu
        syscall		    # wykonać instrukcje z $v0
