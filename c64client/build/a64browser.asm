; Compiled with 1.32.266
--------------------------------------------------------------------
startup: ; startup
0801 : 0b __ __ INV
0802 : 08 __ __ PHP
0803 : 0a __ __ ASL
0804 : 00 __ __ BRK
0805 : 9e __ __ INV
0806 : 32 __ __ INV
0807 : 30 36 __ BMI $083f ; (startup + 62)
0809 : 31 00 __ AND ($00),y 
080b : 00 __ __ BRK
080c : 00 __ __ BRK
080d : ba __ __ TSX
080e : 8e fe 21 STX $21fe ; (spentry + 0)
0811 : a2 2f __ LDX #$2f
0813 : a0 9e __ LDY #$9e
0815 : a9 00 __ LDA #$00
0817 : 85 19 __ STA IP + 0 
0819 : 86 1a __ STX IP + 1 
081b : e0 3b __ CPX #$3b
081d : f0 0b __ BEQ $082a ; (startup + 41)
081f : 91 19 __ STA (IP + 0),y 
0821 : c8 __ __ INY
0822 : d0 fb __ BNE $081f ; (startup + 30)
0824 : e8 __ __ INX
0825 : d0 f2 __ BNE $0819 ; (startup + 24)
0827 : 91 19 __ STA (IP + 0),y 
0829 : c8 __ __ INY
082a : c0 20 __ CPY #$20
082c : d0 f9 __ BNE $0827 ; (startup + 38)
082e : a9 00 __ LDA #$00
0830 : a2 f7 __ LDX #$f7
0832 : d0 03 __ BNE $0837 ; (startup + 54)
0834 : 95 00 __ STA $00,x 
0836 : e8 __ __ INX
0837 : e0 f7 __ CPX #$f7
0839 : d0 f9 __ BNE $0834 ; (startup + 51)
083b : a9 7b __ LDA #$7b
083d : 85 23 __ STA SP + 0 
083f : a9 9f __ LDA #$9f
0841 : 85 24 __ STA SP + 1 
0843 : 20 80 08 JSR $0880 ; (main.s1 + 0)
0846 : a9 4c __ LDA #$4c
0848 : 85 54 __ STA $54 
084a : a9 00 __ LDA #$00
084c : 85 13 __ STA P6 
084e : a9 19 __ LDA #$19
0850 : 85 16 __ STA P9 
0852 : 60 __ __ RTS
--------------------------------------------------------------------
main: ; main()->i16
; 484, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s1:
0880 : a2 04 __ LDX #$04
0882 : b5 53 __ LDA T0 + 0,x 
0884 : 9d 7d 9f STA $9f7d,x ; (main@stack + 0)
0887 : ca __ __ DEX
0888 : 10 f8 __ BPL $0882 ; (main.s1 + 2)
.s4:
088a : a9 00 __ LDA #$00
088c : 85 0d __ STA P0 
088e : 85 0e __ STA P1 
0890 : 8d 20 d0 STA $d020 
0893 : 8d 21 d0 STA $d021 
0896 : 20 61 0c JSR $0c61 ; (clear_screen.s4 + 0)
0899 : a9 4b __ LDA #$4b
089b : 85 0f __ STA P2 
089d : a9 0d __ LDA #$0d
089f : 85 10 __ STA P3 
08a1 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
08a4 : a9 02 __ LDA #$02
08a6 : 85 0e __ STA P1 
08a8 : a9 0d __ LDA #$0d
08aa : 85 10 __ STA P3 
08ac : a9 5e __ LDA #$5e
08ae : 85 0f __ STA P2 
08b0 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
08b3 : a9 01 __ LDA #$01
08b5 : 8d ff 21 STA $21ff ; (uci_target + 0)
08b8 : 8d 85 9f STA $9f85 ; (cmd[0] + 1)
08bb : a9 02 __ LDA #$02
08bd : 85 0f __ STA P2 
08bf : a9 00 __ LDA #$00
08c1 : 85 10 __ STA P3 
08c3 : 8d 84 9f STA $9f84 ; (cmd[0] + 0)
08c6 : a9 84 __ LDA #$84
08c8 : 85 0d __ STA P0 
08ca : a9 9f __ LDA #$9f
08cc : 85 0e __ STA P1 
08ce : 20 73 0d JSR $0d73 ; (uci_sendcommand.s4 + 0)
08d1 : 20 d8 0d JSR $0dd8 ; (uci_readdata.s4 + 0)
08d4 : 20 01 0e JSR $0e01 ; (uci_readstatus.s4 + 0)
08d7 : 20 2a 0e JSR $0e2a ; (uci_accept.s4 + 0)
08da : ad 00 37 LDA $3700 ; (uci_status[0] + 0)
08dd : c9 30 __ CMP #$30
08df : d0 07 __ BNE $08e8 ; (main.s5 + 0)
.s6:
08e1 : ad 01 37 LDA $3701 ; (uci_status[0] + 1)
08e4 : c9 30 __ CMP #$30
08e6 : f0 0f __ BEQ $08f7 ; (main.s7 + 0)
.s5:
08e8 : a9 0e __ LDA #$0e
08ea : 85 10 __ STA P3 
08ec : a9 3a __ LDA #$3a
08ee : 85 0f __ STA P2 
08f0 : 20 de 2e JSR $2ede ; (print_at@proxy + 0)
08f3 : a9 06 __ LDA #$06
08f5 : d0 66 __ BNE $095d ; (main.s92 + 0)
.s7:
08f7 : a9 0f __ LDA #$0f
08f9 : 85 10 __ STA P3 
08fb : a9 2a __ LDA #$2a
08fd : 85 0f __ STA P2 
08ff : 20 de 2e JSR $2ede ; (print_at@proxy + 0)
0902 : a9 06 __ LDA #$06
0904 : 85 0e __ STA P1 
0906 : a9 0f __ LDA #$0f
0908 : 85 10 __ STA P3 
090a : a9 40 __ LDA #$40
090c : 85 0f __ STA P2 
090e : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
0911 : 20 56 0f JSR $0f56 ; (uci_getipaddress.s4 + 0)
0914 : ad 00 37 LDA $3700 ; (uci_status[0] + 0)
0917 : c9 30 __ CMP #$30
0919 : d0 25 __ BNE $0940 ; (main.s8 + 0)
.s87:
091b : ad 01 37 LDA $3701 ; (uci_status[0] + 1)
091e : c9 30 __ CMP #$30
0920 : d0 1e __ BNE $0940 ; (main.s8 + 0)
.s88:
0922 : a9 0f __ LDA #$0f
0924 : 85 10 __ STA P3 
0926 : a9 08 __ LDA #$08
0928 : 85 0e __ STA P1 
092a : a9 8b __ LDA #$8b
092c : 85 0f __ STA P2 
092e : 20 e9 2e JSR $2ee9 ; (print_at@proxy + 0)
0931 : a9 04 __ LDA #$04
0933 : 85 0d __ STA P0 
0935 : a9 2f __ LDA #$2f
0937 : 85 10 __ STA P3 
0939 : a9 9e __ LDA #$9e
093b : 85 0f __ STA P2 
093d : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
.s8:
0940 : a9 0f __ LDA #$0f
0942 : 85 10 __ STA P3 
0944 : a9 0a __ LDA #$0a
0946 : 85 0e __ STA P1 
0948 : a9 90 __ LDA #$90
094a : 85 0f __ STA P2 
094c : 20 e9 2e JSR $2ee9 ; (print_at@proxy + 0)
094f : 20 68 0e JSR $0e68 ; (wait_key.l5 + 0)
0952 : 20 a9 0f JSR $0fa9 ; (connect_to_server.s4 + 0)
0955 : a5 1b __ LDA ACCU + 0 
0957 : d0 27 __ BNE $0980 ; (main.s10 + 0)
.s9:
0959 : 85 0d __ STA P0 
095b : a9 0c __ LDA #$0c
.s92:
095d : 85 0e __ STA P1 
095f : a9 52 __ LDA #$52
0961 : 85 0f __ STA P2 
0963 : a9 0e __ LDA #$0e
0965 : 85 10 __ STA P3 
0967 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
096a : 20 68 0e JSR $0e68 ; (wait_key.l5 + 0)
096d : a9 01 __ LDA #$01
096f : 85 1b __ STA ACCU + 0 
0971 : a9 00 __ LDA #$00
.s3:
0973 : 85 1c __ STA ACCU + 1 
0975 : a2 04 __ LDX #$04
0977 : bd 7d 9f LDA $9f7d,x ; (main@stack + 0)
097a : 95 53 __ STA T0 + 0,x 
097c : ca __ __ DEX
097d : 10 f8 __ BPL $0977 ; (main.s3 + 4)
097f : 60 __ __ RTS
.s10:
0980 : 20 f4 11 JSR $11f4 ; (load_categories.s4 + 0)
0983 : a9 22 __ LDA #$22
0985 : 8d fe 9f STA $9ffe ; (sstack + 8)
0988 : a9 22 __ LDA #$22
098a : 8d ff 9f STA $9fff ; (sstack + 9)
098d : 20 f9 14 JSR $14f9 ; (draw_list.s1 + 0)
0990 : a9 00 __ LDA #$00
0992 : f0 02 __ BEQ $0996 ; (main.l11 + 0)
.s12:
0994 : a5 57 __ LDA T5 + 0 
.l11:
0996 : 85 53 __ STA T0 + 0 
0998 : 20 3a 22 JSR $223a ; (get_key.s1 + 0)
099b : a5 1b __ LDA ACCU + 0 
099d : 85 57 __ STA T5 + 0 
099f : f0 f3 __ BEQ $0994 ; (main.s12 + 0)
.s13:
09a1 : c5 53 __ CMP T0 + 0 
09a3 : f0 ef __ BEQ $0994 ; (main.s12 + 0)
.s14:
09a5 : ad ff 2e LDA $2eff ; (current_page + 1)
09a8 : 85 1c __ STA ACCU + 1 
09aa : d0 0a __ BNE $09b6 ; (main.s15 + 0)
.s17:
09ac : ac fe 2e LDY $2efe ; (current_page + 0)
09af : c0 01 __ CPY #$01
09b1 : d0 03 __ BNE $09b6 ; (main.s15 + 0)
09b3 : 4c 18 0c JMP $0c18 ; (main.s16 + 0)
.s15:
09b6 : a0 00 __ LDY #$00
09b8 : aa __ __ TAX
09b9 : f0 03 __ BEQ $09be ; (main.s80 + 0)
09bb : 4c 08 0c JMP $0c08 ; (main.s18 + 0)
.s80:
09be : ad fe 2e LDA $2efe ; (current_page + 0)
09c1 : c9 02 __ CMP #$02
09c3 : d0 f6 __ BNE $09bb ; (main.s15 + 5)
.s78:
09c5 : a5 1b __ LDA ACCU + 0 
09c7 : c9 6e __ CMP #$6e
09c9 : f0 c9 __ BEQ $0994 ; (main.s12 + 0)
.s79:
09cb : a9 23 __ LDA #$23
09cd : a2 39 __ LDX #$39
.s89:
09cf : 86 55 __ STX T3 + 0 
09d1 : 85 56 __ STA T3 + 1 
09d3 : a5 1b __ LDA ACCU + 0 
.s20:
09d5 : c9 6e __ CMP #$6e
09d7 : b0 03 __ BCS $09dc ; (main.s21 + 0)
09d9 : 4c c4 0a JMP $0ac4 ; (main.s51 + 0)
.s21:
09dc : c9 71 __ CMP #$71
09de : d0 25 __ BNE $0a05 ; (main.s22 + 0)
.s49:
09e0 : ad fe 2e LDA $2efe ; (current_page + 0)
09e3 : 05 1c __ ORA ACCU + 1 
09e5 : d0 ad __ BNE $0994 ; (main.s12 + 0)
.s50:
09e7 : 20 8d 27 JSR $278d ; (disconnect_from_server.s4 + 0)
09ea : a9 00 __ LDA #$00
09ec : 85 0d __ STA P0 
09ee : 85 0e __ STA P1 
09f0 : 20 61 0c JSR $0c61 ; (clear_screen.s4 + 0)
09f3 : a9 df __ LDA #$df
09f5 : 85 0f __ STA P2 
09f7 : a9 27 __ LDA #$27
09f9 : 85 10 __ STA P3 
09fb : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
09fe : a9 00 __ LDA #$00
0a00 : 85 1b __ STA ACCU + 0 
0a02 : 4c 73 09 JMP $0973 ; (main.s3 + 0)
.s22:
0a05 : b0 03 __ BCS $0a0a ; (main.s23 + 0)
0a07 : 4c 97 0a JMP $0a97 ; (main.s42 + 0)
.s23:
0a0a : c9 75 __ CMP #$75
0a0c : d0 2e __ BNE $0a3c ; (main.s24 + 0)
.s37:
0a0e : ad fb 2e LDA $2efb ; (cursor + 1)
0a11 : 30 81 __ BMI $0994 ; (main.s12 + 0)
.s41:
0a13 : 0d fa 2e ORA $2efa ; (cursor + 0)
0a16 : d0 03 __ BNE $0a1b ; (main.s38 + 0)
0a18 : 4c 94 09 JMP $0994 ; (main.s12 + 0)
.s38:
0a1b : ad fa 2e LDA $2efa ; (cursor + 0)
0a1e : 69 fe __ ADC #$fe
0a20 : aa __ __ TAX
0a21 : ad fb 2e LDA $2efb ; (cursor + 1)
0a24 : 69 ff __ ADC #$ff
.s39:
0a26 : 8e fa 2e STX $2efa ; (cursor + 0)
0a29 : 8d fb 2e STA $2efb ; (cursor + 1)
.s40:
0a2c : a5 55 __ LDA T3 + 0 
0a2e : 8d fe 9f STA $9ffe ; (sstack + 8)
0a31 : a5 56 __ LDA T3 + 1 
.s31:
0a33 : 8d ff 9f STA $9fff ; (sstack + 9)
0a36 : 20 f9 14 JSR $14f9 ; (draw_list.s1 + 0)
0a39 : 4c 94 09 JMP $0994 ; (main.s12 + 0)
.s24:
0a3c : a5 1c __ LDA ACCU + 1 
0a3e : d0 f9 __ BNE $0a39 ; (main.s31 + 6)
.s36:
0a40 : ad fe 2e LDA $2efe ; (current_page + 0)
0a43 : c9 02 __ CMP #$02
0a45 : d0 f2 __ BNE $0a39 ; (main.s31 + 6)
.s25:
0a47 : a5 1b __ LDA ACCU + 0 
0a49 : c9 41 __ CMP #$41
0a4b : 90 04 __ BCC $0a51 ; (main.s26 + 0)
.s35:
0a4d : c9 5b __ CMP #$5b
0a4f : 90 08 __ BCC $0a59 ; (main.s28 + 0)
.s26:
0a51 : c9 30 __ CMP #$30
0a53 : 90 e4 __ BCC $0a39 ; (main.s31 + 6)
.s27:
0a55 : c9 3a __ CMP #$3a
0a57 : b0 e0 __ BCS $0a39 ; (main.s31 + 6)
.s28:
0a59 : ae 00 2f LDX $2f00 ; (search_query_len + 0)
0a5c : ad 01 2f LDA $2f01 ; (search_query_len + 1)
0a5f : 30 06 __ BMI $0a67 ; (main.s29 + 0)
.s34:
0a61 : d0 d6 __ BNE $0a39 ; (main.s31 + 6)
.s33:
0a63 : e0 1e __ CPX #$1e
0a65 : b0 d2 __ BCS $0a39 ; (main.s31 + 6)
.s29:
0a67 : 8a __ __ TXA
0a68 : 18 __ __ CLC
0a69 : 69 01 __ ADC #$01
0a6b : 8d 00 2f STA $2f00 ; (search_query_len + 0)
0a6e : a5 1b __ LDA ACCU + 0 
0a70 : 9d d2 36 STA $36d2,x ; (search_query[0] + 0)
0a73 : a9 00 __ LDA #$00
0a75 : 8d 01 2f STA $2f01 ; (search_query_len + 1)
0a78 : 9d d3 36 STA $36d3,x ; (search_query[0] + 1)
0a7b : ad 00 2f LDA $2f00 ; (search_query_len + 0)
0a7e : c9 02 __ CMP #$02
0a80 : a9 39 __ LDA #$39
0a82 : 85 53 __ STA T0 + 0 
0a84 : a9 23 __ LDA #$23
0a86 : 85 54 __ STA T0 + 1 
0a88 : 90 03 __ BCC $0a8d ; (main.s30 + 0)
.s32:
0a8a : 20 e3 25 JSR $25e3 ; (do_search.s1 + 0)
.s30:
0a8d : a5 53 __ LDA T0 + 0 
0a8f : 8d fe 9f STA $9ffe ; (sstack + 8)
0a92 : a5 54 __ LDA T0 + 1 
0a94 : 4c 33 0a JMP $0a33 ; (main.s31 + 0)
.s42:
0a97 : c9 70 __ CMP #$70
0a99 : d0 a1 __ BNE $0a3c ; (main.s24 + 0)
.s43:
0a9b : 98 __ __ TYA
0a9c : f0 9b __ BEQ $0a39 ; (main.s31 + 6)
.s44:
0a9e : ad fd 2e LDA $2efd ; (offset + 1)
0aa1 : 30 96 __ BMI $0a39 ; (main.s31 + 6)
.s48:
0aa3 : 0d fc 2e ORA $2efc ; (offset + 0)
0aa6 : f0 91 __ BEQ $0a39 ; (main.s31 + 6)
.s45:
0aa8 : ad fc 2e LDA $2efc ; (offset + 0)
0aab : e9 14 __ SBC #$14
0aad : aa __ __ TAX
0aae : ad fd 2e LDA $2efd ; (offset + 1)
0ab1 : e9 00 __ SBC #$00
0ab3 : 10 03 __ BPL $0ab8 ; (main.s46 + 0)
.s47:
0ab5 : a9 00 __ LDA #$00
0ab7 : aa __ __ TAX
.s46:
0ab8 : 8e fe 9f STX $9ffe ; (sstack + 8)
0abb : 8d ff 9f STA $9fff ; (sstack + 9)
0abe : 20 4d 23 JSR $234d ; (load_entries.s1 + 0)
0ac1 : 4c 2c 0a JMP $0a2c ; (main.s40 + 0)
.s51:
0ac4 : c9 2f __ CMP #$2f
0ac6 : d0 3e __ BNE $0b06 ; (main.s52 + 0)
.s76:
0ac8 : ad fe 2e LDA $2efe ; (current_page + 0)
0acb : 05 1c __ ORA ACCU + 1 
0acd : f0 03 __ BEQ $0ad2 ; (main.s77 + 0)
0acf : 4c 94 09 JMP $0994 ; (main.s12 + 0)
.s77:
0ad2 : 8d fc 2e STA $2efc ; (offset + 0)
0ad5 : 8d fd 2e STA $2efd ; (offset + 1)
0ad8 : 8d fa 2e STA $2efa ; (cursor + 0)
0adb : 8d fb 2e STA $2efb ; (cursor + 1)
0ade : 8d f8 2e STA $2ef8 ; (total_count + 0)
0ae1 : 8d f9 2e STA $2ef9 ; (total_count + 1)
0ae4 : 8d f6 2e STA $2ef6 ; (item_count + 0)
0ae7 : 8d f7 2e STA $2ef7 ; (item_count + 1)
0aea : 8d 00 2f STA $2f00 ; (search_query_len + 0)
0aed : 8d 01 2f STA $2f01 ; (search_query_len + 1)
0af0 : 8d d2 36 STA $36d2 ; (search_query[0] + 0)
0af3 : 8d ff 2e STA $2eff ; (current_page + 1)
0af6 : a9 02 __ LDA #$02
0af8 : 8d fe 2e STA $2efe ; (current_page + 0)
0afb : a9 23 __ LDA #$23
0afd : a2 39 __ LDX #$39
.s90:
0aff : 86 53 __ STX T0 + 0 
0b01 : 85 54 __ STA T0 + 1 
0b03 : 4c 8d 0a JMP $0a8d ; (main.s30 + 0)
.s52:
0b06 : 90 3e __ BCC $0b46 ; (main.s60 + 0)
.s53:
0b08 : c9 64 __ CMP #$64
0b0a : f0 03 __ BEQ $0b0f ; (main.s54 + 0)
0b0c : 4c 3c 0a JMP $0a3c ; (main.s24 + 0)
.s54:
0b0f : ad f6 2e LDA $2ef6 ; (item_count + 0)
0b12 : e9 01 __ SBC #$01
0b14 : 85 53 __ STA T0 + 0 
0b16 : ad f7 2e LDA $2ef7 ; (item_count + 1)
0b19 : e9 00 __ SBC #$00
0b1b : 85 54 __ STA T0 + 1 
0b1d : ad fb 2e LDA $2efb ; (cursor + 1)
0b20 : c5 54 __ CMP T0 + 1 
0b22 : d0 08 __ BNE $0b2c ; (main.s59 + 0)
.s56:
0b24 : ad fa 2e LDA $2efa ; (cursor + 0)
0b27 : c5 53 __ CMP T0 + 0 
0b29 : 4c 30 0b JMP $0b30 ; (main.s57 + 0)
.s59:
0b2c : 45 54 __ EOR T0 + 1 
0b2e : 30 11 __ BMI $0b41 ; (main.s58 + 0)
.s57:
0b30 : b0 9d __ BCS $0acf ; (main.s76 + 7)
.s55:
0b32 : ad fa 2e LDA $2efa ; (cursor + 0)
0b35 : 18 __ __ CLC
0b36 : 69 01 __ ADC #$01
0b38 : aa __ __ TAX
0b39 : ad fb 2e LDA $2efb ; (cursor + 1)
0b3c : 69 00 __ ADC #$00
0b3e : 4c 26 0a JMP $0a26 ; (main.s39 + 0)
.s58:
0b41 : b0 ef __ BCS $0b32 ; (main.s55 + 0)
0b43 : 4c 94 09 JMP $0994 ; (main.s12 + 0)
.s60:
0b46 : c9 08 __ CMP #$08
0b48 : f0 67 __ BEQ $0bb1 ; (main.s69 + 0)
.s61:
0b4a : c9 0d __ CMP #$0d
0b4c : d0 be __ BNE $0b0c ; (main.s53 + 4)
.s62:
0b4e : ad fe 2e LDA $2efe ; (current_page + 0)
0b51 : 05 1c __ ORA ACCU + 1 
0b53 : f0 21 __ BEQ $0b76 ; (main.s66 + 0)
.s63:
0b55 : ad f7 2e LDA $2ef7 ; (item_count + 1)
0b58 : 30 e9 __ BMI $0b43 ; (main.s58 + 2)
.s65:
0b5a : 0d f6 2e ORA $2ef6 ; (item_count + 0)
0b5d : f0 e4 __ BEQ $0b43 ; (main.s58 + 2)
.s64:
0b5f : ad fa 2e LDA $2efa ; (cursor + 0)
0b62 : 0a __ __ ASL
0b63 : aa __ __ TAX
0b64 : bd aa 36 LDA $36aa,x ; (item_ids[0] + 0)
0b67 : 8d fe 9f STA $9ffe ; (sstack + 8)
0b6a : bd ab 36 LDA $36ab,x ; (item_ids[0] + 1)
0b6d : 8d ff 9f STA $9fff ; (sstack + 9)
0b70 : 20 68 25 JSR $2568 ; (run_entry.s4 + 0)
0b73 : 4c 94 09 JMP $0994 ; (main.s12 + 0)
.s66:
0b76 : 8d fe 9f STA $9ffe ; (sstack + 8)
0b79 : 8d ff 9f STA $9fff ; (sstack + 9)
0b7c : ad fa 2e LDA $2efa ; (cursor + 0)
0b7f : 85 1c __ STA ACCU + 1 
0b81 : ad fb 2e LDA $2efb ; (cursor + 1)
0b84 : 4a __ __ LSR
0b85 : 66 1c __ ROR ACCU + 1 
0b87 : 6a __ __ ROR
0b88 : 66 1c __ ROR ACCU + 1 
0b8a : 6a __ __ ROR
0b8b : 66 1c __ ROR ACCU + 1 
0b8d : 29 c0 __ AND #$c0
0b8f : 6a __ __ ROR
0b90 : 69 80 __ ADC #$80
0b92 : 85 53 __ STA T0 + 0 
0b94 : a9 38 __ LDA #$38
0b96 : 65 1c __ ADC ACCU + 1 
0b98 : 85 54 __ STA T0 + 1 
0b9a : a0 ff __ LDY #$ff
.l67:
0b9c : c8 __ __ INY
0b9d : b1 53 __ LDA (T0 + 0),y 
0b9f : 99 00 3b STA $3b00,y ; (current_category[0] + 0)
0ba2 : d0 f8 __ BNE $0b9c ; (main.l67 + 0)
.s68:
0ba4 : 20 4d 23 JSR $234d ; (load_entries.s1 + 0)
0ba7 : a9 00 __ LDA #$00
0ba9 : 8d fe 9f STA $9ffe ; (sstack + 8)
0bac : a9 3b __ LDA #$3b
0bae : 4c 33 0a JMP $0a33 ; (main.s31 + 0)
.s69:
0bb1 : a5 1c __ LDA ACCU + 1 
0bb3 : d0 07 __ BNE $0bbc ; (main.s70 + 0)
.s75:
0bb5 : ad fe 2e LDA $2efe ; (current_page + 0)
0bb8 : c9 02 __ CMP #$02
0bba : f0 0d __ BEQ $0bc9 ; (main.s71 + 0)
.s70:
0bbc : 98 __ __ TYA
0bbd : f0 b4 __ BEQ $0b73 ; (main.s64 + 20)
.s91:
0bbf : 20 f4 11 JSR $11f4 ; (load_categories.s4 + 0)
0bc2 : a9 22 __ LDA #$22
0bc4 : a2 22 __ LDX #$22
0bc6 : 4c ff 0a JMP $0aff ; (main.s90 + 0)
.s71:
0bc9 : ad 00 2f LDA $2f00 ; (search_query_len + 0)
0bcc : 85 53 __ STA T0 + 0 
0bce : ad 01 2f LDA $2f01 ; (search_query_len + 1)
0bd1 : 30 ec __ BMI $0bbf ; (main.s91 + 0)
.s74:
0bd3 : 05 53 __ ORA T0 + 0 
0bd5 : f0 e8 __ BEQ $0bbf ; (main.s91 + 0)
.s72:
0bd7 : a6 53 __ LDX T0 + 0 
0bd9 : ca __ __ DEX
0bda : 8e 00 2f STX $2f00 ; (search_query_len + 0)
0bdd : a9 00 __ LDA #$00
0bdf : 8d 01 2f STA $2f01 ; (search_query_len + 1)
0be2 : 9d d2 36 STA $36d2,x ; (search_query[0] + 0)
0be5 : ad 00 2f LDA $2f00 ; (search_query_len + 0)
0be8 : c9 02 __ CMP #$02
0bea : a9 39 __ LDA #$39
0bec : 85 53 __ STA T0 + 0 
0bee : a9 23 __ LDA #$23
0bf0 : 85 54 __ STA T0 + 1 
0bf2 : 90 03 __ BCC $0bf7 ; (main.s73 + 0)
0bf4 : 4c 8a 0a JMP $0a8a ; (main.s32 + 0)
.s73:
0bf7 : a9 00 __ LDA #$00
0bf9 : 8d f8 2e STA $2ef8 ; (total_count + 0)
0bfc : 8d f9 2e STA $2ef9 ; (total_count + 1)
0bff : 8d f6 2e STA $2ef6 ; (item_count + 0)
0c02 : 8d f7 2e STA $2ef7 ; (item_count + 1)
0c05 : 4c 8d 0a JMP $0a8d ; (main.s30 + 0)
.s18:
0c08 : a5 1b __ LDA ACCU + 0 
0c0a : c9 6e __ CMP #$6e
0c0c : d0 03 __ BNE $0c11 ; (main.s19 + 0)
0c0e : 4c 94 09 JMP $0994 ; (main.s12 + 0)
.s19:
0c11 : a9 22 __ LDA #$22
0c13 : a2 22 __ LDX #$22
0c15 : 4c cf 09 JMP $09cf ; (main.s89 + 0)
.s16:
0c18 : a9 00 __ LDA #$00
0c1a : 85 1c __ STA ACCU + 1 
0c1c : a9 00 __ LDA #$00
0c1e : 85 55 __ STA T3 + 0 
0c20 : a9 3b __ LDA #$3b
0c22 : 85 56 __ STA T3 + 1 
0c24 : a5 1b __ LDA ACCU + 0 
0c26 : c9 6e __ CMP #$6e
0c28 : f0 03 __ BEQ $0c2d ; (main.s81 + 0)
0c2a : 4c d5 09 JMP $09d5 ; (main.s20 + 0)
.s81:
0c2d : ad f6 2e LDA $2ef6 ; (item_count + 0)
0c30 : 18 __ __ CLC
0c31 : 6d fc 2e ADC $2efc ; (offset + 0)
0c34 : aa __ __ TAX
0c35 : ad f7 2e LDA $2ef7 ; (item_count + 1)
0c38 : 6d fd 2e ADC $2efd ; (offset + 1)
0c3b : cd f9 2e CMP $2ef9 ; (total_count + 1)
0c3e : d0 06 __ BNE $0c46 ; (main.s86 + 0)
.s83:
0c40 : ec f8 2e CPX $2ef8 ; (total_count + 0)
0c43 : 4c 4b 0c JMP $0c4b ; (main.s84 + 0)
.s86:
0c46 : 4d f9 2e EOR $2ef9 ; (total_count + 1)
0c49 : 30 11 __ BMI $0c5c ; (main.s85 + 0)
.s84:
0c4b : b0 c1 __ BCS $0c0e ; (main.s18 + 6)
.s82:
0c4d : ad fc 2e LDA $2efc ; (offset + 0)
0c50 : 18 __ __ CLC
0c51 : 69 14 __ ADC #$14
0c53 : aa __ __ TAX
0c54 : ad fd 2e LDA $2efd ; (offset + 1)
0c57 : 69 00 __ ADC #$00
0c59 : 4c b8 0a JMP $0ab8 ; (main.s46 + 0)
.s85:
0c5c : b0 ef __ BCS $0c4d ; (main.s82 + 0)
0c5e : 4c 94 09 JMP $0994 ; (main.s12 + 0)
--------------------------------------------------------------------
clear_screen: ; clear_screen()->void
;  57, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
0c61 : a9 20 __ LDA #$20
0c63 : a2 fa __ LDX #$fa
.l6:
0c65 : ca __ __ DEX
0c66 : 9d 00 04 STA $0400,x 
0c69 : 9d fa 04 STA $04fa,x 
0c6c : 9d f4 05 STA $05f4,x 
0c6f : 9d ee 06 STA $06ee,x 
0c72 : d0 f1 __ BNE $0c65 ; (clear_screen.l6 + 0)
.s5:
0c74 : a9 0e __ LDA #$0e
0c76 : a2 fa __ LDX #$fa
.l7:
0c78 : ca __ __ DEX
0c79 : 9d 00 d8 STA $d800,x 
0c7c : 9d fa d8 STA $d8fa,x 
0c7f : 9d f4 d9 STA $d9f4,x 
0c82 : 9d ee da STA $daee,x 
0c85 : d0 f1 __ BNE $0c78 ; (clear_screen.l7 + 0)
.s3:
0c87 : 60 __ __ RTS
--------------------------------------------------------------------
debug_key: ; debug_key(u8,bool)->void
; 346, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
0c88 : a5 18 __ LDA P11 ; (k + 0)
0c8a : 8d f8 9f STA $9ff8 ; (sstack + 2)
0c8d : c9 40 __ CMP #$40
0c8f : a9 00 __ LDA #$00
0c91 : 8d f9 9f STA $9ff9 ; (sstack + 3)
0c94 : a9 2b __ LDA #$2b
0c96 : 8d f6 9f STA $9ff6 ; (sstack + 0)
0c99 : a9 23 __ LDA #$23
0c9b : 8d f7 9f STA $9ff7 ; (sstack + 1)
0c9e : 90 04 __ BCC $0ca4 ; (debug_key.s7 + 0)
.s5:
0ca0 : a9 3f __ LDA #$3f
0ca2 : b0 10 __ BCS $0cb4 ; (debug_key.s6 + 0)
.s7:
0ca4 : ad fe 9f LDA $9ffe ; (sstack + 8)
0ca7 : f0 06 __ BEQ $0caf ; (debug_key.s8 + 0)
.s9:
0ca9 : a5 18 __ LDA P11 ; (k + 0)
0cab : 69 40 __ ADC #$40
0cad : 85 18 __ STA P11 ; (k + 0)
.s8:
0caf : a6 18 __ LDX P11 ; (k + 0)
0cb1 : bd 1e 2f LDA $2f1e,x ; (keyb_codes[0] + 0)
.s6:
0cb4 : 8d fa 9f STA $9ffa ; (sstack + 4)
0cb7 : a9 b8 __ LDA #$b8
0cb9 : 85 16 __ STA P9 
0cbb : a9 00 __ LDA #$00
0cbd : 8d fb 9f STA $9ffb ; (sstack + 5)
0cc0 : a9 9f __ LDA #$9f
0cc2 : 85 17 __ STA P10 
0cc4 : 20 0d 17 JSR $170d ; (sprintf.s1 + 0)
0cc7 : a9 1c __ LDA #$1c
0cc9 : 85 0d __ STA P0 
0ccb : a9 9f __ LDA #$9f
0ccd : 85 10 __ STA P3 
0ccf : a9 18 __ LDA #$18
0cd1 : 85 0e __ STA P1 
0cd3 : a9 b8 __ LDA #$b8
0cd5 : 85 0f __ STA P2 
--------------------------------------------------------------------
print_at: ; print_at(u8,u8,const u8*)->void
;  63, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
0cd7 : a5 0e __ LDA P1 ; (y + 0)
0cd9 : 0a __ __ ASL
0cda : 85 1b __ STA ACCU + 0 
0cdc : a9 00 __ LDA #$00
0cde : 2a __ __ ROL
0cdf : 06 1b __ ASL ACCU + 0 
0ce1 : 2a __ __ ROL
0ce2 : aa __ __ TAX
0ce3 : a5 1b __ LDA ACCU + 0 
0ce5 : 65 0e __ ADC P1 ; (y + 0)
0ce7 : 85 43 __ STA T1 + 0 
0ce9 : 8a __ __ TXA
0cea : 69 00 __ ADC #$00
0cec : 06 43 __ ASL T1 + 0 
0cee : 2a __ __ ROL
0cef : 06 43 __ ASL T1 + 0 
0cf1 : 2a __ __ ROL
0cf2 : 06 43 __ ASL T1 + 0 
0cf4 : 2a __ __ ROL
0cf5 : aa __ __ TAX
0cf6 : a0 00 __ LDY #$00
0cf8 : b1 0f __ LDA (P2),y ; (text + 0)
0cfa : f0 4e __ BEQ $0d4a ; (print_at.s3 + 0)
.s14:
0cfc : a5 43 __ LDA T1 + 0 
0cfe : 65 0d __ ADC P0 ; (x + 0)
0d00 : 85 43 __ STA T1 + 0 
0d02 : 8a __ __ TXA
0d03 : 69 04 __ ADC #$04
0d05 : 85 44 __ STA T1 + 1 
0d07 : a6 0f __ LDX P2 ; (text + 0)
.l5:
0d09 : 86 1b __ STX ACCU + 0 
0d0b : 8a __ __ TXA
0d0c : 18 __ __ CLC
0d0d : 69 01 __ ADC #$01
0d0f : aa __ __ TAX
0d10 : a5 10 __ LDA P3 ; (text + 1)
0d12 : 85 1c __ STA ACCU + 1 
0d14 : 69 00 __ ADC #$00
0d16 : 85 10 __ STA P3 ; (text + 1)
0d18 : a0 00 __ LDY #$00
0d1a : b1 1b __ LDA (ACCU + 0),y 
0d1c : c9 61 __ CMP #$61
0d1e : 90 09 __ BCC $0d29 ; (print_at.s6 + 0)
.s12:
0d20 : c9 7b __ CMP #$7b
0d22 : b0 05 __ BCS $0d29 ; (print_at.s6 + 0)
.s13:
0d24 : 69 a0 __ ADC #$a0
0d26 : 4c 3c 0d JMP $0d3c ; (print_at.s7 + 0)
.s6:
0d29 : c9 41 __ CMP #$41
0d2b : 90 0f __ BCC $0d3c ; (print_at.s7 + 0)
.s8:
0d2d : c9 5b __ CMP #$5b
0d2f : b0 05 __ BCS $0d36 ; (print_at.s9 + 0)
.s11:
0d31 : 69 c0 __ ADC #$c0
0d33 : 4c 3c 0d JMP $0d3c ; (print_at.s7 + 0)
.s9:
0d36 : c9 7c __ CMP #$7c
0d38 : d0 02 __ BNE $0d3c ; (print_at.s7 + 0)
.s10:
0d3a : a9 20 __ LDA #$20
.s7:
0d3c : 91 43 __ STA (T1 + 0),y 
0d3e : e6 43 __ INC T1 + 0 
0d40 : d0 02 __ BNE $0d44 ; (print_at.s16 + 0)
.s15:
0d42 : e6 44 __ INC T1 + 1 
.s16:
0d44 : a0 01 __ LDY #$01
0d46 : b1 1b __ LDA (ACCU + 0),y 
0d48 : d0 bf __ BNE $0d09 ; (print_at.l5 + 0)
.s3:
0d4a : 60 __ __ RTS
--------------------------------------------------------------------
0d4b : __ __ __ BYT 61 73 73 65 6d 62 6c 79 36 34 20 62 72 6f 77 73 : assembly64 brows
0d5b : __ __ __ BYT 65 72 00                                        : er.
--------------------------------------------------------------------
0d5e : __ __ __ BYT 63 68 65 63 6b 69 6e 67 20 75 6c 74 69 6d 61 74 : checking ultimat
0d6e : __ __ __ BYT 65 2e 2e 2e 00                                  : e....
--------------------------------------------------------------------
uci_sendcommand: ; uci_sendcommand(u8*,i16)->void
; 119, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/ultimate.h"
.s4:
0d73 : ad ff 21 LDA $21ff ; (uci_target + 0)
0d76 : a0 00 __ LDY #$00
0d78 : 91 0d __ STA (P0),y ; (bytes + 0)
.l5:
0d7a : ad 1c df LDA $df1c 
0d7d : 29 20 __ AND #$20
0d7f : d0 f9 __ BNE $0d7a ; (uci_sendcommand.l5 + 0)
.s6:
0d81 : ad 1c df LDA $df1c 
0d84 : 29 10 __ AND #$10
0d86 : d0 f2 __ BNE $0d7a ; (uci_sendcommand.l5 + 0)
.s7:
0d88 : a5 10 __ LDA P3 ; (count + 1)
0d8a : 30 2a __ BMI $0db6 ; (uci_sendcommand.s8 + 0)
.s13:
0d8c : 05 0f __ ORA P2 ; (count + 0)
0d8e : f0 26 __ BEQ $0db6 ; (uci_sendcommand.s8 + 0)
.s12:
0d90 : a5 0f __ LDA P2 ; (count + 0)
0d92 : 85 1b __ STA ACCU + 0 
0d94 : a5 0d __ LDA P0 ; (bytes + 0)
0d96 : 85 43 __ STA T2 + 0 
0d98 : a5 0e __ LDA P1 ; (bytes + 1)
0d9a : 85 44 __ STA T2 + 1 
0d9c : a0 00 __ LDY #$00
0d9e : a6 10 __ LDX P3 ; (count + 1)
.l14:
0da0 : b1 43 __ LDA (T2 + 0),y 
0da2 : 8d 1d df STA $df1d 
0da5 : c8 __ __ INY
0da6 : d0 02 __ BNE $0daa ; (uci_sendcommand.s19 + 0)
.s18:
0da8 : e6 44 __ INC T2 + 1 
.s19:
0daa : a5 1b __ LDA ACCU + 0 
0dac : d0 01 __ BNE $0daf ; (uci_sendcommand.s16 + 0)
.s15:
0dae : ca __ __ DEX
.s16:
0daf : c6 1b __ DEC ACCU + 0 
0db1 : d0 ed __ BNE $0da0 ; (uci_sendcommand.l14 + 0)
.s17:
0db3 : 8a __ __ TXA
0db4 : d0 ea __ BNE $0da0 ; (uci_sendcommand.l14 + 0)
.s8:
0db6 : a9 01 __ LDA #$01
0db8 : 8d 1c df STA $df1c 
0dbb : ad 1c df LDA $df1c 
0dbe : 29 08 __ AND #$08
0dc0 : f0 07 __ BEQ $0dc9 ; (uci_sendcommand.l9 + 0)
.s11:
0dc2 : a9 08 __ LDA #$08
0dc4 : 8d 1c df STA $df1c 
0dc7 : d0 b1 __ BNE $0d7a ; (uci_sendcommand.l5 + 0)
.l9:
0dc9 : ad 1c df LDA $df1c 
0dcc : 29 20 __ AND #$20
0dce : d0 07 __ BNE $0dd7 ; (uci_sendcommand.s3 + 0)
.s10:
0dd0 : ad 1c df LDA $df1c 
0dd3 : 29 10 __ AND #$10
0dd5 : d0 f2 __ BNE $0dc9 ; (uci_sendcommand.l9 + 0)
.s3:
0dd7 : 60 __ __ RTS
--------------------------------------------------------------------
uci_readdata: ; uci_readdata()->void
; 120, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/ultimate.h"
.s4:
0dd8 : a9 00 __ LDA #$00
0dda : 8d 9e 2f STA $2f9e ; (uci_data[0] + 0)
0ddd : a2 9e __ LDX #$9e
0ddf : 86 1b __ STX ACCU + 0 
0de1 : a8 __ __ TAY
0de2 : f0 0d __ BEQ $0df1 ; (uci_readdata.l5 + 0)
.s7:
0de4 : ad 1e df LDA $df1e 
0de7 : 91 1b __ STA (ACCU + 0),y 
0de9 : 98 __ __ TYA
0dea : 18 __ __ CLC
0deb : 69 01 __ ADC #$01
0ded : a8 __ __ TAY
0dee : 8a __ __ TXA
0def : 69 00 __ ADC #$00
.l5:
0df1 : aa __ __ TAX
0df2 : 18 __ __ CLC
0df3 : 69 2f __ ADC #$2f
0df5 : 85 1c __ STA ACCU + 1 
0df7 : 2c 1c df BIT $df1c 
0dfa : 30 e8 __ BMI $0de4 ; (uci_readdata.s7 + 0)
.s6:
0dfc : a9 00 __ LDA #$00
0dfe : 91 1b __ STA (ACCU + 0),y 
.s3:
0e00 : 60 __ __ RTS
--------------------------------------------------------------------
uci_readstatus: ; uci_readstatus()->void
; 121, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/ultimate.h"
.s4:
0e01 : a9 00 __ LDA #$00
0e03 : 8d 00 37 STA $3700 ; (uci_status[0] + 0)
0e06 : a2 00 __ LDX #$00
0e08 : 86 1b __ STX ACCU + 0 
0e0a : a8 __ __ TAY
0e0b : f0 0d __ BEQ $0e1a ; (uci_readstatus.l5 + 0)
.s7:
0e0d : ad 1f df LDA $df1f 
0e10 : 91 1b __ STA (ACCU + 0),y 
0e12 : 98 __ __ TYA
0e13 : 18 __ __ CLC
0e14 : 69 01 __ ADC #$01
0e16 : a8 __ __ TAY
0e17 : 8a __ __ TXA
0e18 : 69 00 __ ADC #$00
.l5:
0e1a : aa __ __ TAX
0e1b : 18 __ __ CLC
0e1c : 69 37 __ ADC #$37
0e1e : 85 1c __ STA ACCU + 1 
0e20 : ad 1c df LDA $df1c 
0e23 : 29 40 __ AND #$40
0e25 : d0 e6 __ BNE $0e0d ; (uci_readstatus.s7 + 0)
.s6:
0e27 : 91 1b __ STA (ACCU + 0),y 
.s3:
0e29 : 60 __ __ RTS
--------------------------------------------------------------------
uci_accept: ; uci_accept()->void
; 122, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/ultimate.h"
.s4:
0e2a : ad 1c df LDA $df1c 
0e2d : 09 02 __ ORA #$02
0e2f : 8d 1c df STA $df1c 
.l5:
0e32 : ad 1c df LDA $df1c 
0e35 : 29 02 __ AND #$02
0e37 : d0 f9 __ BNE $0e32 ; (uci_accept.l5 + 0)
.s3:
0e39 : 60 __ __ RTS
--------------------------------------------------------------------
0e3a : __ __ __ BYT 75 6c 74 69 6d 61 74 65 20 69 69 2b 20 6e 6f 74 : ultimate ii+ not
0e4a : __ __ __ BYT 20 66 6f 75 6e 64 21 00                         :  found!.
--------------------------------------------------------------------
0e52 : __ __ __ BYT 70 72 65 73 73 20 61 6e 79 20 6b 65 79 20 74 6f : press any key to
0e62 : __ __ __ BYT 20 65 78 69 74 00                               :  exit.
--------------------------------------------------------------------
wait_key: ; wait_key()->void
; 419, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.l5:
0e68 : 20 79 0e JSR $0e79 ; (keyb_poll.s4 + 0)
0e6b : 2c 9e 36 BIT $369e ; (keyb_key + 0)
0e6e : 30 f8 __ BMI $0e68 ; (wait_key.l5 + 0)
.l4:
0e70 : 20 79 0e JSR $0e79 ; (keyb_poll.s4 + 0)
0e73 : 2c 9e 36 BIT $369e ; (keyb_key + 0)
0e76 : 10 f8 __ BPL $0e70 ; (wait_key.l4 + 0)
.s3:
0e78 : 60 __ __ RTS
--------------------------------------------------------------------
keyb_poll: ; keyb_poll()->void
; 126, "/usr/local/include/oscar64/c64/keyboard.h"
.s4:
0e79 : a9 00 __ LDA #$00
0e7b : 8d 9e 36 STA $369e ; (keyb_key + 0)
0e7e : a9 ff __ LDA #$ff
0e80 : 8d 02 dc STA $dc02 
0e83 : 8d 00 dc STA $dc00 
0e86 : ae 01 dc LDX $dc01 
0e89 : e8 __ __ INX
0e8a : d0 25 __ BNE $0eb1 ; (keyb_poll.s3 + 0)
.s5:
0e8c : 8e 03 dc STX $dc03 
0e8f : 8e 00 dc STX $dc00 
0e92 : ad 01 dc LDA $dc01 
0e95 : c9 ff __ CMP #$ff
0e97 : d0 1f __ BNE $0eb8 ; (keyb_poll.s7 + 0)
.s6:
0e99 : 8d 9f 36 STA $369f ; (keyb_matrix[0] + 0)
0e9c : 8d a0 36 STA $36a0 ; (keyb_matrix[0] + 1)
0e9f : 8d a1 36 STA $36a1 ; (keyb_matrix[0] + 2)
0ea2 : 8d a2 36 STA $36a2 ; (keyb_matrix[0] + 3)
0ea5 : 8d a3 36 STA $36a3 ; (keyb_matrix[0] + 4)
0ea8 : 8d a4 36 STA $36a4 ; (keyb_matrix[0] + 5)
0eab : 8d a5 36 STA $36a5 ; (keyb_matrix[0] + 6)
0eae : 8d a6 36 STA $36a6 ; (keyb_matrix[0] + 7)
.s3:
0eb1 : ad a7 36 LDA $36a7 ; (ciaa_pra_def + 0)
0eb4 : 8d 00 dc STA $dc00 
0eb7 : 60 __ __ RTS
.s7:
0eb8 : ad a5 36 LDA $36a5 ; (keyb_matrix[0] + 6)
0ebb : 29 ef __ AND #$ef
0ebd : 8d a5 36 STA $36a5 ; (keyb_matrix[0] + 6)
0ec0 : ad a0 36 LDA $36a0 ; (keyb_matrix[0] + 1)
0ec3 : 29 7f __ AND #$7f
0ec5 : 8d a0 36 STA $36a0 ; (keyb_matrix[0] + 1)
0ec8 : a9 fe __ LDA #$fe
0eca : 85 1b __ STA ACCU + 0 
.l20:
0ecc : a5 1b __ LDA ACCU + 0 
0ece : 8d 00 dc STA $dc00 
0ed1 : bd 9f 36 LDA $369f,x ; (keyb_matrix[0] + 0)
0ed4 : 85 1c __ STA ACCU + 1 
0ed6 : ad 01 dc LDA $dc01 
0ed9 : 9d 9f 36 STA $369f,x ; (keyb_matrix[0] + 0)
0edc : 38 __ __ SEC
0edd : 26 1b __ ROL ACCU + 0 
0edf : 49 ff __ EOR #$ff
0ee1 : 25 1c __ AND ACCU + 1 
0ee3 : f0 25 __ BEQ $0f0a ; (keyb_poll.s8 + 0)
.s13:
0ee5 : 85 1c __ STA ACCU + 1 
0ee7 : 8a __ __ TXA
0ee8 : 0a __ __ ASL
0ee9 : 0a __ __ ASL
0eea : 0a __ __ ASL
0eeb : 09 80 __ ORA #$80
0eed : a8 __ __ TAY
0eee : a5 1c __ LDA ACCU + 1 
0ef0 : 29 f0 __ AND #$f0
0ef2 : f0 04 __ BEQ $0ef8 ; (keyb_poll.s14 + 0)
.s19:
0ef4 : 98 __ __ TYA
0ef5 : 09 04 __ ORA #$04
0ef7 : a8 __ __ TAY
.s14:
0ef8 : a5 1c __ LDA ACCU + 1 
0efa : 29 cc __ AND #$cc
0efc : f0 02 __ BEQ $0f00 ; (keyb_poll.s15 + 0)
.s18:
0efe : c8 __ __ INY
0eff : c8 __ __ INY
.s15:
0f00 : a5 1c __ LDA ACCU + 1 
0f02 : 29 aa __ AND #$aa
0f04 : f0 01 __ BEQ $0f07 ; (keyb_poll.s16 + 0)
.s17:
0f06 : c8 __ __ INY
.s16:
0f07 : 8c 9e 36 STY $369e ; (keyb_key + 0)
.s8:
0f0a : e8 __ __ INX
0f0b : e0 08 __ CPX #$08
0f0d : 90 bd __ BCC $0ecc ; (keyb_poll.l20 + 0)
.s9:
0f0f : ad 9e 36 LDA $369e ; (keyb_key + 0)
0f12 : f0 9d __ BEQ $0eb1 ; (keyb_poll.s3 + 0)
.s10:
0f14 : 2c a0 36 BIT $36a0 ; (keyb_matrix[0] + 1)
0f17 : 10 07 __ BPL $0f20 ; (keyb_poll.s11 + 0)
.s12:
0f19 : ad a5 36 LDA $36a5 ; (keyb_matrix[0] + 6)
0f1c : 29 10 __ AND #$10
0f1e : d0 91 __ BNE $0eb1 ; (keyb_poll.s3 + 0)
.s11:
0f20 : ad 9e 36 LDA $369e ; (keyb_key + 0)
0f23 : 09 40 __ ORA #$40
0f25 : 8d 9e 36 STA $369e ; (keyb_key + 0)
0f28 : b0 87 __ BCS $0eb1 ; (keyb_poll.s3 + 0)
--------------------------------------------------------------------
0f2a : __ __ __ BYT 75 6c 74 69 6d 61 74 65 20 69 69 2b 20 64 65 74 : ultimate ii+ det
0f3a : __ __ __ BYT 65 63 74 65 64 00                               : ected.
--------------------------------------------------------------------
0f40 : __ __ __ BYT 67 65 74 74 69 6e 67 20 69 70 20 61 64 64 72 65 : getting ip addre
0f50 : __ __ __ BYT 73 73 2e 2e 2e 00                               : ss....
--------------------------------------------------------------------
uci_getipaddress: ; uci_getipaddress()->void
; 154, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/ultimate.h"
.s4:
0f56 : a9 00 __ LDA #$00
0f58 : 8d f5 9f STA $9ff5 ; (cmd[0] + 2)
0f5b : 85 10 __ STA P3 
0f5d : 8d f3 9f STA $9ff3 ; (cmd[0] + 0)
0f60 : a9 05 __ LDA #$05
0f62 : 8d f4 9f STA $9ff4 ; (cmd[0] + 1)
0f65 : ad ff 21 LDA $21ff ; (uci_target + 0)
0f68 : 85 45 __ STA T1 + 0 
0f6a : a9 03 __ LDA #$03
0f6c : 85 0f __ STA P2 
0f6e : 8d ff 21 STA $21ff ; (uci_target + 0)
0f71 : a9 f3 __ LDA #$f3
0f73 : 85 0d __ STA P0 
0f75 : a9 9f __ LDA #$9f
0f77 : 85 0e __ STA P1 
0f79 : 20 73 0d JSR $0d73 ; (uci_sendcommand.s4 + 0)
0f7c : 20 d8 0d JSR $0dd8 ; (uci_readdata.s4 + 0)
0f7f : 20 01 0e JSR $0e01 ; (uci_readstatus.s4 + 0)
0f82 : 20 2a 0e JSR $0e2a ; (uci_accept.s4 + 0)
0f85 : a5 45 __ LDA T1 + 0 
0f87 : 8d ff 21 STA $21ff ; (uci_target + 0)
.s3:
0f8a : 60 __ __ RTS
--------------------------------------------------------------------
0f8b : __ __ __ BYT 69 70 3a 20 00                                  : ip: .
--------------------------------------------------------------------
0f90 : __ __ __ BYT 70 72 65 73 73 20 61 6e 79 20 6b 65 79 20 74 6f : press any key to
0fa0 : __ __ __ BYT 20 63 6f 6e 6e 65 63 74 00                      :  connect.
--------------------------------------------------------------------
connect_to_server: ; connect_to_server()->bool
; 113, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
0fa9 : a9 00 __ LDA #$00
0fab : 85 0d __ STA P0 
0fad : a9 18 __ LDA #$18
0faf : 85 0e __ STA P1 
0fb1 : a9 20 __ LDA #$20
0fb3 : a2 28 __ LDX #$28
.l5:
0fb5 : ca __ __ DEX
0fb6 : 9d c0 07 STA $07c0,x 
0fb9 : d0 fa __ BNE $0fb5 ; (connect_to_server.l5 + 0)
.s6:
0fbb : a9 2a __ LDA #$2a
0fbd : 85 0f __ STA P2 
0fbf : a9 10 __ LDA #$10
0fc1 : 85 10 __ STA P3 
0fc3 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
0fc6 : 20 38 10 JSR $1038 ; (uci_tcp_connect.s4 + 0)
0fc9 : 8d f4 2e STA $2ef4 ; (socket_id + 0)
0fcc : ad 00 37 LDA $3700 ; (uci_status[0] + 0)
0fcf : c9 30 __ CMP #$30
0fd1 : d0 07 __ BNE $0fda ; (connect_to_server.s7 + 0)
.s10:
0fd3 : ad 01 37 LDA $3701 ; (uci_status[0] + 1)
0fd6 : c9 30 __ CMP #$30
0fd8 : f0 22 __ BEQ $0ffc ; (connect_to_server.s11 + 0)
.s7:
0fda : a9 00 __ LDA #$00
0fdc : 85 0d __ STA P0 
0fde : a9 18 __ LDA #$18
0fe0 : 85 0e __ STA P1 
0fe2 : a9 20 __ LDA #$20
0fe4 : a2 28 __ LDX #$28
.l8:
0fe6 : ca __ __ DEX
0fe7 : 9d c0 07 STA $07c0,x 
0fea : d0 fa __ BNE $0fe6 ; (connect_to_server.l8 + 0)
.s9:
0fec : a9 00 __ LDA #$00
0fee : 85 0f __ STA P2 
0ff0 : a9 11 __ LDA #$11
0ff2 : 85 10 __ STA P3 
0ff4 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
0ff7 : a9 00 __ LDA #$00
.s3:
0ff9 : 85 1b __ STA ACCU + 0 
0ffb : 60 __ __ RTS
.s11:
0ffc : ad f4 2e LDA $2ef4 ; (socket_id + 0)
0fff : 85 11 __ STA P4 
1001 : a9 01 __ LDA #$01
1003 : 8d f5 2e STA $2ef5 ; (connected + 0)
1006 : 20 15 11 JSR $1115 ; (uci_tcp_nextline.s4 + 0)
1009 : a9 00 __ LDA #$00
100b : 85 0d __ STA P0 
100d : a9 18 __ LDA #$18
100f : 85 0e __ STA P1 
1011 : a9 20 __ LDA #$20
1013 : a2 28 __ LDX #$28
.l12:
1015 : ca __ __ DEX
1016 : 9d c0 07 STA $07c0,x 
1019 : d0 fa __ BNE $1015 ; (connect_to_server.l12 + 0)
.s13:
101b : a9 e9 __ LDA #$e9
101d : 85 0f __ STA P2 
101f : a9 11 __ LDA #$11
1021 : 85 10 __ STA P3 
1023 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
1026 : a9 01 __ LDA #$01
1028 : d0 cf __ BNE $0ff9 ; (connect_to_server.s3 + 0)
--------------------------------------------------------------------
102a : __ __ __ BYT 63 6f 6e 6e 65 63 74 69 6e 67 2e 2e 2e 00       : connecting....
--------------------------------------------------------------------
uci_tcp_connect: ; uci_tcp_connect(const u8*,u16)->u8
; 157, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/ultimate.h"
.s4:
1038 : a9 f3 __ LDA #$f3
103a : 85 0d __ STA P0 
103c : a9 10 __ LDA #$10
103e : 85 0e __ STA P1 
1040 : 20 d7 10 JSR $10d7 ; (strlen.s4 + 0)
1043 : a5 1b __ LDA ACCU + 0 
1045 : 85 43 __ STA T0 + 0 
1047 : 18 __ __ CLC
1048 : 69 05 __ ADC #$05
104a : 85 0f __ STA P2 
104c : 85 1b __ STA ACCU + 0 
104e : a5 1c __ LDA ACCU + 1 
1050 : 85 44 __ STA T0 + 1 
1052 : 69 00 __ ADC #$00
1054 : 85 10 __ STA P3 
1056 : 85 1c __ STA ACCU + 1 
1058 : 20 2b 2d JSR $2d2b ; (crt_malloc + 0)
105b : a9 00 __ LDA #$00
105d : a8 __ __ TAY
105e : 91 1b __ STA (ACCU + 0),y 
1060 : a9 07 __ LDA #$07
1062 : c8 __ __ INY
1063 : 91 1b __ STA (ACCU + 0),y 
1065 : a9 41 __ LDA #$41
1067 : c8 __ __ INY
1068 : 91 1b __ STA (ACCU + 0),y 
106a : a9 19 __ LDA #$19
106c : c8 __ __ INY
106d : 91 1b __ STA (ACCU + 0),y 
106f : ad ff 21 LDA $21ff ; (uci_target + 0)
1072 : 85 45 __ STA T6 + 0 
1074 : a5 44 __ LDA T0 + 1 
1076 : 30 1d __ BMI $1095 ; (uci_tcp_connect.s5 + 0)
.s8:
1078 : 05 43 __ ORA T0 + 0 
107a : f0 19 __ BEQ $1095 ; (uci_tcp_connect.s5 + 0)
.s6:
107c : a2 00 __ LDX #$00
107e : 18 __ __ CLC
.l10:
107f : 8a __ __ TXA
1080 : 69 04 __ ADC #$04
1082 : a8 __ __ TAY
1083 : bd f3 10 LDA $10f3,x 
1086 : 91 1b __ STA (ACCU + 0),y 
1088 : a9 00 __ LDA #$00
108a : e8 __ __ INX
108b : c5 44 __ CMP T0 + 1 
108d : 90 f0 __ BCC $107f ; (uci_tcp_connect.l10 + 0)
.s9:
108f : d0 04 __ BNE $1095 ; (uci_tcp_connect.s5 + 0)
.s7:
1091 : e4 43 __ CPX T0 + 0 
1093 : 90 ea __ BCC $107f ; (uci_tcp_connect.l10 + 0)
.s5:
1095 : a5 1b __ LDA ACCU + 0 
1097 : 85 0d __ STA P0 
1099 : 18 __ __ CLC
109a : 65 43 __ ADC T0 + 0 
109c : 85 43 __ STA T0 + 0 
109e : a5 1c __ LDA ACCU + 1 
10a0 : 85 0e __ STA P1 
10a2 : 65 44 __ ADC T0 + 1 
10a4 : 85 44 __ STA T0 + 1 
10a6 : a9 00 __ LDA #$00
10a8 : a0 04 __ LDY #$04
10aa : 91 43 __ STA (T0 + 0),y 
10ac : a9 03 __ LDA #$03
10ae : 8d ff 21 STA $21ff ; (uci_target + 0)
10b1 : 20 73 0d JSR $0d73 ; (uci_sendcommand.s4 + 0)
10b4 : 20 f9 2d JSR $2df9 ; (crt_free@proxy + 0)
10b7 : 20 d8 0d JSR $0dd8 ; (uci_readdata.s4 + 0)
10ba : 20 01 0e JSR $0e01 ; (uci_readstatus.s4 + 0)
10bd : 20 2a 0e JSR $0e2a ; (uci_accept.s4 + 0)
10c0 : a9 00 __ LDA #$00
10c2 : 8d f2 2e STA $2ef2 ; (uci_data_len + 0)
10c5 : 8d f3 2e STA $2ef3 ; (uci_data_len + 1)
10c8 : 8d f0 2e STA $2ef0 ; (uci_data_index + 0)
10cb : 8d f1 2e STA $2ef1 ; (uci_data_index + 1)
10ce : a5 45 __ LDA T6 + 0 
10d0 : 8d ff 21 STA $21ff ; (uci_target + 0)
10d3 : ad 9e 2f LDA $2f9e ; (uci_data[0] + 0)
.s3:
10d6 : 60 __ __ RTS
--------------------------------------------------------------------
strlen: ; strlen(const u8*)->i16
;  12, "/usr/local/include/oscar64/string.h"
.s4:
10d7 : a9 00 __ LDA #$00
10d9 : 85 1b __ STA ACCU + 0 
10db : 85 1c __ STA ACCU + 1 
10dd : a8 __ __ TAY
10de : b1 0d __ LDA (P0),y ; (str + 0)
10e0 : f0 10 __ BEQ $10f2 ; (strlen.s3 + 0)
.s6:
10e2 : a2 00 __ LDX #$00
.l7:
10e4 : c8 __ __ INY
10e5 : d0 03 __ BNE $10ea ; (strlen.s9 + 0)
.s8:
10e7 : e6 0e __ INC P1 ; (str + 1)
10e9 : e8 __ __ INX
.s9:
10ea : b1 0d __ LDA (P0),y ; (str + 0)
10ec : d0 f6 __ BNE $10e4 ; (strlen.l7 + 0)
.s5:
10ee : 86 1c __ STX ACCU + 1 
10f0 : 84 1b __ STY ACCU + 0 
.s3:
10f2 : 60 __ __ RTS
--------------------------------------------------------------------
10f3 : __ __ __ BYT 31 39 32 2e 31 36 38 2e 32 2e 36 36 00          : 192.168.2.66.
--------------------------------------------------------------------
1100 : __ __ __ BYT 63 6f 6e 6e 65 63 74 20 66 61 69 6c 65 64 21 00 : connect failed!.
--------------------------------------------------------------------
read_line: ; read_line()->void
; 157, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
1110 : ad f4 2e LDA $2ef4 ; (socket_id + 0)
1113 : 85 11 __ STA P4 
--------------------------------------------------------------------
uci_tcp_nextline: ; uci_tcp_nextline(u8,u8*)->void
; 173, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/ultimate.h"
.s4:
1115 : a9 00 __ LDA #$00
1117 : 8d 00 38 STA $3800 ; (line_buffer[0] + 0)
111a : 85 46 __ STA T2 + 0 
.l5:
111c : ad f0 2e LDA $2ef0 ; (uci_data_index + 0)
111f : 85 43 __ STA T0 + 0 
1121 : ad f1 2e LDA $2ef1 ; (uci_data_index + 1)
1124 : 85 44 __ STA T0 + 1 
1126 : cd f3 2e CMP $2ef3 ; (uci_data_len + 1)
1129 : d0 0a __ BNE $1135 ; (uci_tcp_nextline.s18 + 0)
.s15:
112b : a5 43 __ LDA T0 + 0 
112d : cd f2 2e CMP $2ef2 ; (uci_data_len + 0)
.s16:
1130 : b0 0a __ BCS $113c ; (uci_tcp_nextline.l6 + 0)
1132 : 4c c5 11 JMP $11c5 ; (uci_tcp_nextline.s14 + 0)
.s18:
1135 : 4d f3 2e EOR $2ef3 ; (uci_data_len + 1)
1138 : 10 f6 __ BPL $1130 ; (uci_tcp_nextline.s16 + 0)
.s17:
113a : b0 f6 __ BCS $1132 ; (uci_tcp_nextline.s16 + 2)
.l6:
113c : a9 00 __ LDA #$00
113e : 85 10 __ STA P3 
1140 : 8d f1 9f STA $9ff1 ; (cmd[0] + 0)
1143 : a9 05 __ LDA #$05
1145 : 85 0f __ STA P2 
1147 : a9 10 __ LDA #$10
1149 : 8d f2 9f STA $9ff2 ; (cmd[0] + 1)
114c : a5 11 __ LDA P4 ; (socketid + 0)
114e : 8d f3 9f STA $9ff3 ; (cmd[0] + 2)
1151 : a9 7c __ LDA #$7c
1153 : 8d f4 9f STA $9ff4 ; (cmd[0] + 3)
1156 : ad ff 21 LDA $21ff ; (uci_target + 0)
1159 : 85 45 __ STA T1 + 0 
115b : a9 03 __ LDA #$03
115d : 8d f5 9f STA $9ff5 ; (cmd[0] + 4)
1160 : 8d ff 21 STA $21ff ; (uci_target + 0)
1163 : a9 f1 __ LDA #$f1
1165 : 85 0d __ STA P0 
1167 : a9 9f __ LDA #$9f
1169 : 85 0e __ STA P1 
116b : 20 73 0d JSR $0d73 ; (uci_sendcommand.s4 + 0)
116e : 20 d8 0d JSR $0dd8 ; (uci_readdata.s4 + 0)
1171 : 20 01 0e JSR $0e01 ; (uci_readstatus.s4 + 0)
1174 : 20 2a 0e JSR $0e2a ; (uci_accept.s4 + 0)
1177 : a5 45 __ LDA T1 + 0 
1179 : 8d ff 21 STA $21ff ; (uci_target + 0)
117c : ad 9e 2f LDA $2f9e ; (uci_data[0] + 0)
117f : 8d f2 2e STA $2ef2 ; (uci_data_len + 0)
1182 : ad 9f 2f LDA $2f9f ; (uci_data[0] + 1)
1185 : 8d f3 2e STA $2ef3 ; (uci_data_len + 1)
1188 : 0d 9e 2f ORA $2f9e ; (uci_data[0] + 0)
118b : f0 30 __ BEQ $11bd ; (uci_tcp_nextline.s9 + 0)
.s7:
118d : ae 9f 2f LDX $2f9f ; (uci_data[0] + 1)
1190 : e8 __ __ INX
1191 : d0 06 __ BNE $1199 ; (uci_tcp_nextline.s8 + 0)
.s13:
1193 : ae f2 2e LDX $2ef2 ; (uci_data_len + 0)
1196 : e8 __ __ INX
1197 : f0 a3 __ BEQ $113c ; (uci_tcp_nextline.l6 + 0)
.s8:
1199 : a9 01 __ LDA #$01
119b : 8d f0 2e STA $2ef0 ; (uci_data_index + 0)
119e : a9 00 __ LDA #$00
11a0 : 8d f1 2e STA $2ef1 ; (uci_data_index + 1)
11a3 : ad a0 2f LDA $2fa0 ; (uci_data[0] + 2)
11a6 : f0 15 __ BEQ $11bd ; (uci_tcp_nextline.s9 + 0)
.s10:
11a8 : c9 0a __ CMP #$0a
11aa : f0 11 __ BEQ $11bd ; (uci_tcp_nextline.s9 + 0)
.s11:
11ac : c9 0d __ CMP #$0d
11ae : d0 03 __ BNE $11b3 ; (uci_tcp_nextline.s12 + 0)
11b0 : 4c 1c 11 JMP $111c ; (uci_tcp_nextline.l5 + 0)
.s12:
11b3 : a6 46 __ LDX T2 + 0 
11b5 : 9d 00 38 STA $3800,x ; (line_buffer[0] + 0)
11b8 : e6 46 __ INC T2 + 0 
11ba : 4c 1c 11 JMP $111c ; (uci_tcp_nextline.l5 + 0)
.s9:
11bd : a9 00 __ LDA #$00
11bf : a6 46 __ LDX T2 + 0 
11c1 : 9d 00 38 STA $3800,x ; (line_buffer[0] + 0)
.s3:
11c4 : 60 __ __ RTS
.s14:
11c5 : 18 __ __ CLC
11c6 : a5 43 __ LDA T0 + 0 
11c8 : 69 01 __ ADC #$01
11ca : 8d f0 2e STA $2ef0 ; (uci_data_index + 0)
11cd : a5 44 __ LDA T0 + 1 
11cf : 69 00 __ ADC #$00
11d1 : 8d f1 2e STA $2ef1 ; (uci_data_index + 1)
11d4 : 18 __ __ CLC
11d5 : a9 a0 __ LDA #$a0
11d7 : 65 43 __ ADC T0 + 0 
11d9 : 85 43 __ STA T0 + 0 
11db : a9 2f __ LDA #$2f
11dd : 65 44 __ ADC T0 + 1 
11df : 85 44 __ STA T0 + 1 
11e1 : a0 00 __ LDY #$00
11e3 : b1 43 __ LDA (T0 + 0),y 
11e5 : f0 d6 __ BEQ $11bd ; (uci_tcp_nextline.s9 + 0)
11e7 : d0 bf __ BNE $11a8 ; (uci_tcp_nextline.s10 + 0)
--------------------------------------------------------------------
11e9 : __ __ __ BYT 63 6f 6e 6e 65 63 74 65 64 21 00                : connected!.
--------------------------------------------------------------------
load_categories: ; load_categories()->void
; 171, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
11f4 : a9 00 __ LDA #$00
11f6 : 85 0d __ STA P0 
11f8 : a9 18 __ LDA #$18
11fa : 85 0e __ STA P1 
11fc : a9 20 __ LDA #$20
11fe : a2 28 __ LDX #$28
.l5:
1200 : ca __ __ DEX
1201 : 9d c0 07 STA $07c0,x 
1204 : d0 fa __ BNE $1200 ; (load_categories.l5 + 0)
.s6:
1206 : a9 e9 __ LDA #$e9
1208 : 85 0f __ STA P2 
120a : a9 12 __ LDA #$12
120c : 85 10 __ STA P3 
120e : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
1211 : a9 bf __ LDA #$bf
1213 : 85 14 __ STA P7 
1215 : a9 13 __ LDA #$13
1217 : 85 15 __ STA P8 
1219 : 20 ff 12 JSR $12ff ; (send_command.s4 + 0)
121c : 20 10 11 JSR $1110 ; (read_line.s4 + 0)
121f : a9 00 __ LDA #$00
1221 : 8d f6 2e STA $2ef6 ; (item_count + 0)
1224 : 8d f7 2e STA $2ef7 ; (item_count + 1)
1227 : 20 c4 13 JSR $13c4 ; (atoi@proxy + 0)
122a : a5 1b __ LDA ACCU + 0 
122c : 8d f8 2e STA $2ef8 ; (total_count + 0)
122f : a5 1c __ LDA ACCU + 1 
1231 : 8d f9 2e STA $2ef9 ; (total_count + 1)
.l7:
1234 : 20 10 11 JSR $1110 ; (read_line.s4 + 0)
1237 : ad 00 38 LDA $3800 ; (line_buffer[0] + 0)
123a : c9 2e __ CMP #$2e
123c : f0 7c __ BEQ $12ba ; (load_categories.s10 + 0)
.s8:
123e : 20 76 14 JSR $1476 ; (strchr@proxy + 0)
1241 : a5 1c __ LDA ACCU + 1 
1243 : 05 1b __ ORA ACCU + 0 
1245 : f0 62 __ BEQ $12a9 ; (load_categories.s9 + 0)
.s15:
1247 : a5 1c __ LDA ACCU + 1 
1249 : 85 4d __ STA T1 + 1 
124b : a5 1b __ LDA ACCU + 0 
124d : 85 4c __ STA T1 + 0 
124f : a9 00 __ LDA #$00
1251 : a8 __ __ TAY
1252 : 91 1b __ STA (ACCU + 0),y 
1254 : a9 00 __ LDA #$00
1256 : 85 0f __ STA P2 
1258 : a9 38 __ LDA #$38
125a : 85 10 __ STA P3 
125c : ad f6 2e LDA $2ef6 ; (item_count + 0)
125f : 85 4e __ STA T2 + 0 
1261 : 4a __ __ LSR
1262 : 6a __ __ ROR
1263 : 6a __ __ ROR
1264 : aa __ __ TAX
1265 : 29 c0 __ AND #$c0
1267 : 6a __ __ ROR
1268 : 69 80 __ ADC #$80
126a : 85 4a __ STA T0 + 0 
126c : 85 0d __ STA P0 
126e : 8a __ __ TXA
126f : 29 1f __ AND #$1f
1271 : 69 38 __ ADC #$38
1273 : 85 4b __ STA T0 + 1 
1275 : 85 0e __ STA P1 
1277 : 20 a8 14 JSR $14a8 ; (strncpy.s4 + 0)
127a : a9 00 __ LDA #$00
127c : a0 1f __ LDY #$1f
127e : 91 4a __ STA (T0 + 0),y 
1280 : 18 __ __ CLC
1281 : a5 4c __ LDA T1 + 0 
1283 : 69 01 __ ADC #$01
1285 : 85 0d __ STA P0 
1287 : a5 4d __ LDA T1 + 1 
1289 : 69 00 __ ADC #$00
128b : 85 0e __ STA P1 
128d : 20 cc 13 JSR $13cc ; (atoi.l4 + 0)
1290 : a5 4e __ LDA T2 + 0 
1292 : 0a __ __ ASL
1293 : aa __ __ TAX
1294 : a5 1b __ LDA ACCU + 0 
1296 : 9d aa 36 STA $36aa,x ; (item_ids[0] + 0)
1299 : a5 1c __ LDA ACCU + 1 
129b : 9d ab 36 STA $36ab,x ; (item_ids[0] + 1)
129e : a6 4e __ LDX T2 + 0 
12a0 : e8 __ __ INX
12a1 : 8e f6 2e STX $2ef6 ; (item_count + 0)
12a4 : a9 00 __ LDA #$00
12a6 : 8d f7 2e STA $2ef7 ; (item_count + 1)
.s9:
12a9 : ad f7 2e LDA $2ef7 ; (item_count + 1)
12ac : 30 86 __ BMI $1234 ; (load_categories.l7 + 0)
.s14:
12ae : d0 0a __ BNE $12ba ; (load_categories.s10 + 0)
.s13:
12b0 : ad f6 2e LDA $2ef6 ; (item_count + 0)
12b3 : c9 14 __ CMP #$14
12b5 : b0 03 __ BCS $12ba ; (load_categories.s10 + 0)
12b7 : 4c 34 12 JMP $1234 ; (load_categories.l7 + 0)
.s10:
12ba : a9 00 __ LDA #$00
12bc : 85 0d __ STA P0 
12be : 8d fe 2e STA $2efe ; (current_page + 0)
12c1 : 8d ff 2e STA $2eff ; (current_page + 1)
12c4 : 8d fc 2e STA $2efc ; (offset + 0)
12c7 : 8d fd 2e STA $2efd ; (offset + 1)
12ca : 8d fa 2e STA $2efa ; (cursor + 0)
12cd : 8d fb 2e STA $2efb ; (cursor + 1)
12d0 : a9 18 __ LDA #$18
12d2 : 85 0e __ STA P1 
12d4 : a9 20 __ LDA #$20
12d6 : a2 28 __ LDX #$28
.l11:
12d8 : ca __ __ DEX
12d9 : 9d c0 07 STA $07c0,x 
12dc : d0 fa __ BNE $12d8 ; (load_categories.l11 + 0)
--------------------------------------------------------------------
print_at@proxy: ; print_at@proxy
12de : a9 f3 __ LDA #$f3
12e0 : 85 0f __ STA P2 
12e2 : a9 14 __ LDA #$14
12e4 : 85 10 __ STA P3 
12e6 : 4c d7 0c JMP $0cd7 ; (print_at.s4 + 0)
--------------------------------------------------------------------
12e9 : __ __ __ BYT 6c 6f 61 64 69 6e 67 20 63 61 74 65 67 6f 72 69 : loading categori
12f9 : __ __ __ BYT 65 73 2e 2e 2e 00                               : es....
--------------------------------------------------------------------
send_command: ; send_command(const u8*)->void
; 148, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
12ff : ad f5 2e LDA $2ef5 ; (connected + 0)
1302 : d0 01 __ BNE $1305 ; (send_command.s5 + 0)
.s3:
1304 : 60 __ __ RTS
.s5:
1305 : a5 14 __ LDA P7 ; (cmd + 0)
1307 : 85 12 __ STA P5 
1309 : a5 15 __ LDA P8 ; (cmd + 1)
130b : 85 13 __ STA P6 
130d : 20 d6 2e JSR $2ed6 ; (uci_socket_write@proxy + 0)
1310 : a9 0a __ LDA #$0a
1312 : 8d a8 36 STA $36a8 ; (temp_char[0] + 0)
1315 : a9 00 __ LDA #$00
1317 : 8d a9 36 STA $36a9 ; (temp_char[0] + 1)
131a : a9 a8 __ LDA #$a8
131c : 85 12 __ STA P5 
131e : a9 36 __ LDA #$36
1320 : 85 13 __ STA P6 
--------------------------------------------------------------------
uci_socket_write: ; uci_socket_write(u8,const u8*)->void
; 161, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/ultimate.h"
.s4:
1322 : a5 12 __ LDA P5 ; (data + 0)
1324 : 85 0d __ STA P0 
1326 : 85 47 __ STA T3 + 0 
1328 : a5 13 __ LDA P6 ; (data + 1)
132a : 85 0e __ STA P1 
132c : 85 48 __ STA T3 + 1 
132e : 20 d7 10 JSR $10d7 ; (strlen.s4 + 0)
1331 : a5 1b __ LDA ACCU + 0 
1333 : 85 43 __ STA T0 + 0 
1335 : 18 __ __ CLC
1336 : 69 03 __ ADC #$03
1338 : 85 0f __ STA P2 
133a : 85 1b __ STA ACCU + 0 
133c : a5 1c __ LDA ACCU + 1 
133e : 85 44 __ STA T0 + 1 
1340 : 69 00 __ ADC #$00
1342 : 85 10 __ STA P3 
1344 : 85 1c __ STA ACCU + 1 
1346 : 20 2b 2d JSR $2d2b ; (crt_malloc + 0)
1349 : a9 00 __ LDA #$00
134b : a8 __ __ TAY
134c : 91 1b __ STA (ACCU + 0),y 
134e : a9 11 __ LDA #$11
1350 : c8 __ __ INY
1351 : 91 1b __ STA (ACCU + 0),y 
1353 : a5 11 __ LDA P4 ; (socketid + 0)
1355 : c8 __ __ INY
1356 : 91 1b __ STA (ACCU + 0),y 
1358 : ad ff 21 LDA $21ff ; (uci_target + 0)
135b : 85 49 __ STA T6 + 0 
135d : a5 44 __ LDA T0 + 1 
135f : 30 2e __ BMI $138f ; (uci_socket_write.s5 + 0)
.s8:
1361 : 05 43 __ ORA T0 + 0 
1363 : f0 2a __ BEQ $138f ; (uci_socket_write.s5 + 0)
.s6:
1365 : a5 1b __ LDA ACCU + 0 
1367 : 85 45 __ STA T2 + 0 
1369 : a5 1c __ LDA ACCU + 1 
136b : 85 46 __ STA T2 + 1 
136d : a6 44 __ LDX T0 + 1 
.l7:
136f : a0 00 __ LDY #$00
1371 : b1 47 __ LDA (T3 + 0),y 
1373 : a0 03 __ LDY #$03
1375 : 91 45 __ STA (T2 + 0),y 
1377 : e6 45 __ INC T2 + 0 
1379 : d0 02 __ BNE $137d ; (uci_socket_write.s13 + 0)
.s12:
137b : e6 46 __ INC T2 + 1 
.s13:
137d : e6 47 __ INC T3 + 0 
137f : d0 02 __ BNE $1383 ; (uci_socket_write.s15 + 0)
.s14:
1381 : e6 48 __ INC T3 + 1 
.s15:
1383 : a5 43 __ LDA T0 + 0 
1385 : d0 01 __ BNE $1388 ; (uci_socket_write.s10 + 0)
.s9:
1387 : ca __ __ DEX
.s10:
1388 : c6 43 __ DEC T0 + 0 
138a : d0 e3 __ BNE $136f ; (uci_socket_write.l7 + 0)
.s11:
138c : 8a __ __ TXA
138d : d0 e0 __ BNE $136f ; (uci_socket_write.l7 + 0)
.s5:
138f : a5 1b __ LDA ACCU + 0 
1391 : 85 0d __ STA P0 
1393 : a5 1c __ LDA ACCU + 1 
1395 : 85 0e __ STA P1 
1397 : a9 03 __ LDA #$03
1399 : 8d ff 21 STA $21ff ; (uci_target + 0)
139c : 20 73 0d JSR $0d73 ; (uci_sendcommand.s4 + 0)
139f : 20 f9 2d JSR $2df9 ; (crt_free@proxy + 0)
13a2 : 20 d8 0d JSR $0dd8 ; (uci_readdata.s4 + 0)
13a5 : 20 01 0e JSR $0e01 ; (uci_readstatus.s4 + 0)
13a8 : 20 2a 0e JSR $0e2a ; (uci_accept.s4 + 0)
13ab : a9 00 __ LDA #$00
13ad : 8d f2 2e STA $2ef2 ; (uci_data_len + 0)
13b0 : 8d f3 2e STA $2ef3 ; (uci_data_len + 1)
13b3 : 8d f0 2e STA $2ef0 ; (uci_data_index + 0)
13b6 : 8d f1 2e STA $2ef1 ; (uci_data_index + 1)
13b9 : a5 49 __ LDA T6 + 0 
13bb : 8d ff 21 STA $21ff ; (uci_target + 0)
.s3:
13be : 60 __ __ RTS
--------------------------------------------------------------------
13bf : __ __ __ BYT 43 41 54 53 00                                  : CATS.
--------------------------------------------------------------------
atoi@proxy: ; atoi@proxy
13c4 : a9 03 __ LDA #$03
13c6 : 85 0d __ STA P0 
13c8 : a9 38 __ LDA #$38
13ca : 85 0e __ STA P1 
--------------------------------------------------------------------
atoi: ; atoi(const u8*)->i16
;  30, "/usr/local/include/oscar64/stdlib.h"
.l4:
13cc : a0 00 __ LDY #$00
13ce : b1 0d __ LDA (P0),y ; (s + 0)
13d0 : aa __ __ TAX
13d1 : a5 0d __ LDA P0 ; (s + 0)
13d3 : 85 43 __ STA T0 + 0 
13d5 : 18 __ __ CLC
13d6 : 69 01 __ ADC #$01
13d8 : 85 0d __ STA P0 ; (s + 0)
13da : a5 0e __ LDA P1 ; (s + 1)
13dc : 85 44 __ STA T0 + 1 
13de : 69 00 __ ADC #$00
13e0 : 85 0e __ STA P1 ; (s + 1)
13e2 : 8a __ __ TXA
13e3 : e0 21 __ CPX #$21
13e5 : b0 08 __ BCS $13ef ; (atoi.s5 + 0)
.s16:
13e7 : aa __ __ TAX
13e8 : d0 e2 __ BNE $13cc ; (atoi.l4 + 0)
.s17:
13ea : 85 1b __ STA ACCU + 0 
.s3:
13ec : 85 1c __ STA ACCU + 1 
13ee : 60 __ __ RTS
.s5:
13ef : c9 2d __ CMP #$2d
13f1 : d0 1d __ BNE $1410 ; (atoi.s6 + 0)
.s15:
13f3 : a9 01 __ LDA #$01
13f5 : 85 1d __ STA ACCU + 2 
.s14:
13f7 : 18 __ __ CLC
13f8 : a5 43 __ LDA T0 + 0 
13fa : 69 02 __ ADC #$02
13fc : 85 0d __ STA P0 ; (s + 0)
13fe : a5 44 __ LDA T0 + 1 
1400 : 69 00 __ ADC #$00
1402 : 85 0e __ STA P1 ; (s + 1)
1404 : a0 01 __ LDY #$01
1406 : b1 43 __ LDA (T0 + 0),y 
.s7:
1408 : 85 1c __ STA ACCU + 1 
140a : a9 00 __ LDA #$00
140c : 85 43 __ STA T0 + 0 
140e : f0 08 __ BEQ $1418 ; (atoi.l8 + 0)
.s6:
1410 : 84 1d __ STY ACCU + 2 
1412 : c9 2b __ CMP #$2b
1414 : d0 f2 __ BNE $1408 ; (atoi.s7 + 0)
1416 : f0 df __ BEQ $13f7 ; (atoi.s14 + 0)
.l8:
1418 : 85 44 __ STA T0 + 1 
141a : a5 1c __ LDA ACCU + 1 
141c : c9 30 __ CMP #$30
141e : 90 3b __ BCC $145b ; (atoi.s9 + 0)
.s12:
1420 : c9 3a __ CMP #$3a
1422 : b0 37 __ BCS $145b ; (atoi.s9 + 0)
.s13:
1424 : a0 00 __ LDY #$00
1426 : b1 0d __ LDA (P0),y ; (s + 0)
1428 : a8 __ __ TAY
1429 : e6 0d __ INC P0 ; (s + 0)
142b : d0 02 __ BNE $142f ; (atoi.s19 + 0)
.s18:
142d : e6 0e __ INC P1 ; (s + 1)
.s19:
142f : a5 43 __ LDA T0 + 0 
1431 : 0a __ __ ASL
1432 : 85 1b __ STA ACCU + 0 
1434 : a5 44 __ LDA T0 + 1 
1436 : 2a __ __ ROL
1437 : 06 1b __ ASL ACCU + 0 
1439 : 2a __ __ ROL
143a : aa __ __ TAX
143b : 18 __ __ CLC
143c : a5 1b __ LDA ACCU + 0 
143e : 65 43 __ ADC T0 + 0 
1440 : 85 43 __ STA T0 + 0 
1442 : 8a __ __ TXA
1443 : 65 44 __ ADC T0 + 1 
1445 : 06 43 __ ASL T0 + 0 
1447 : 2a __ __ ROL
1448 : aa __ __ TAX
1449 : a5 1c __ LDA ACCU + 1 
144b : 84 1c __ STY ACCU + 1 
144d : 38 __ __ SEC
144e : e9 30 __ SBC #$30
1450 : 18 __ __ CLC
1451 : 65 43 __ ADC T0 + 0 
1453 : 85 43 __ STA T0 + 0 
1455 : 8a __ __ TXA
1456 : 69 00 __ ADC #$00
1458 : 4c 18 14 JMP $1418 ; (atoi.l8 + 0)
.s9:
145b : a5 1d __ LDA ACCU + 2 
145d : d0 09 __ BNE $1468 ; (atoi.s11 + 0)
.s10:
145f : a5 43 __ LDA T0 + 0 
1461 : 85 1b __ STA ACCU + 0 
1463 : a5 44 __ LDA T0 + 1 
1465 : 4c ec 13 JMP $13ec ; (atoi.s3 + 0)
.s11:
1468 : 38 __ __ SEC
1469 : a9 00 __ LDA #$00
146b : e5 43 __ SBC T0 + 0 
146d : 85 1b __ STA ACCU + 0 
146f : a9 00 __ LDA #$00
1471 : e5 44 __ SBC T0 + 1 
1473 : 4c ec 13 JMP $13ec ; (atoi.s3 + 0)
--------------------------------------------------------------------
strchr@proxy: ; strchr@proxy
1476 : a9 00 __ LDA #$00
1478 : 85 0d __ STA P0 
147a : a9 38 __ LDA #$38
147c : 85 0e __ STA P1 
147e : a9 7c __ LDA #$7c
1480 : 85 0f __ STA P2 
1482 : a9 00 __ LDA #$00
1484 : 85 10 __ STA P3 
--------------------------------------------------------------------
strchr: ; strchr(const u8*,i16)->u8*
;  18, "/usr/local/include/oscar64/string.h"
.l4:
1486 : a0 00 __ LDY #$00
1488 : b1 0d __ LDA (P0),y ; (str + 0)
148a : c5 0f __ CMP P2 ; (ch + 0)
148c : d0 09 __ BNE $1497 ; (strchr.s6 + 0)
.s5:
148e : a5 0d __ LDA P0 ; (str + 0)
1490 : 85 1b __ STA ACCU + 0 
1492 : a5 0e __ LDA P1 ; (str + 1)
.s3:
1494 : 85 1c __ STA ACCU + 1 
1496 : 60 __ __ RTS
.s6:
1497 : aa __ __ TAX
1498 : f0 09 __ BEQ $14a3 ; (strchr.s7 + 0)
.s8:
149a : e6 0d __ INC P0 ; (str + 0)
149c : d0 e8 __ BNE $1486 ; (strchr.l4 + 0)
.s9:
149e : e6 0e __ INC P1 ; (str + 1)
14a0 : 4c 86 14 JMP $1486 ; (strchr.l4 + 0)
.s7:
14a3 : 85 1b __ STA ACCU + 0 
14a5 : 4c 94 14 JMP $1494 ; (strchr.s3 + 0)
--------------------------------------------------------------------
strncpy: ; strncpy(u8*,const u8*,i16)->void
;   6, "/usr/local/include/oscar64/string.h"
.s4:
14a8 : a9 1e __ LDA #$1e
14aa : 85 1b __ STA ACCU + 0 
14ac : a2 00 __ LDX #$00
.l5:
14ae : a0 00 __ LDY #$00
14b0 : b1 0f __ LDA (P2),y ; (src + 0)
14b2 : 91 0d __ STA (P0),y ; (dst + 0)
14b4 : e6 0d __ INC P0 ; (dst + 0)
14b6 : d0 02 __ BNE $14ba ; (strncpy.s12 + 0)
.s11:
14b8 : e6 0e __ INC P1 ; (dst + 1)
.s12:
14ba : 09 00 __ ORA #$00
14bc : f0 1a __ BEQ $14d8 ; (strncpy.s6 + 0)
.s9:
14be : e6 0f __ INC P2 ; (src + 0)
14c0 : d0 02 __ BNE $14c4 ; (strncpy.s14 + 0)
.s13:
14c2 : e6 10 __ INC P3 ; (src + 1)
.s14:
14c4 : 8a __ __ TXA
14c5 : 05 1b __ ORA ACCU + 0 
14c7 : 85 1c __ STA ACCU + 1 
14c9 : 18 __ __ CLC
14ca : a5 1b __ LDA ACCU + 0 
14cc : 69 ff __ ADC #$ff
14ce : 85 1b __ STA ACCU + 0 
14d0 : 8a __ __ TXA
14d1 : 69 ff __ ADC #$ff
14d3 : aa __ __ TAX
14d4 : a5 1c __ LDA ACCU + 1 
14d6 : d0 d6 __ BNE $14ae ; (strncpy.l5 + 0)
.s6:
14d8 : 8a __ __ TXA
14d9 : 30 17 __ BMI $14f2 ; (strncpy.s3 + 0)
.s8:
14db : 05 1b __ ORA ACCU + 0 
14dd : f0 13 __ BEQ $14f2 ; (strncpy.s3 + 0)
.s7:
14df : a5 0d __ LDA P0 ; (dst + 0)
14e1 : 84 0d __ STY P0 ; (dst + 0)
14e3 : a8 __ __ TAY
14e4 : a6 1b __ LDX ACCU + 0 
.l10:
14e6 : a9 00 __ LDA #$00
14e8 : 91 0d __ STA (P0),y ; (dst + 0)
14ea : c8 __ __ INY
14eb : d0 02 __ BNE $14ef ; (strncpy.s16 + 0)
.s15:
14ed : e6 0e __ INC P1 ; (dst + 1)
.s16:
14ef : ca __ __ DEX
14f0 : d0 f4 __ BNE $14e6 ; (strncpy.l10 + 0)
.s3:
14f2 : 60 __ __ RTS
--------------------------------------------------------------------
14f3 : __ __ __ BYT 72 65 61 64 79 00                               : ready.
--------------------------------------------------------------------
draw_list: ; draw_list(const u8*)->void
; 432, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s1:
14f9 : a2 05 __ LDX #$05
14fb : b5 53 __ LDA T2 + 0,x 
14fd : 9d a8 9f STA $9fa8,x ; (draw_list@stack + 0)
1500 : ca __ __ DEX
1501 : 10 f8 __ BPL $14fb ; (draw_list.s1 + 2)
.s4:
1503 : a9 00 __ LDA #$00
1505 : 85 0d __ STA P0 
1507 : 85 0e __ STA P1 
1509 : a9 07 __ LDA #$07
150b : 85 11 __ STA P4 
150d : 20 61 0c JSR $0c61 ; (clear_screen.s4 + 0)
1510 : ad fe 9f LDA $9ffe ; (sstack + 8)
1513 : 85 0f __ STA P2 
1515 : ad ff 9f LDA $9fff ; (sstack + 9)
1518 : 85 10 __ STA P3 
151a : 20 7e 16 JSR $167e ; (print_at_color.s4 + 0)
151d : ad fe 2e LDA $2efe ; (current_page + 0)
1520 : 85 53 __ STA T2 + 0 
1522 : ad ff 2e LDA $2eff ; (current_page + 1)
1525 : 85 54 __ STA T2 + 1 
1527 : d0 3d __ BNE $1566 ; (draw_list.s5 + 0)
.s26:
1529 : a5 53 __ LDA T2 + 0 
152b : c9 02 __ CMP #$02
152d : d0 37 __ BNE $1566 ; (draw_list.s5 + 0)
.s25:
152f : e6 0e __ INC P1 
1531 : a9 02 __ LDA #$02
1533 : 85 0f __ STA P2 
1535 : a9 17 __ LDA #$17
1537 : 85 10 __ STA P3 
1539 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
153c : a9 08 __ LDA #$08
153e : 85 0d __ STA P0 
1540 : a9 36 __ LDA #$36
1542 : 85 10 __ STA P3 
1544 : a9 d2 __ LDA #$d2
1546 : 85 0f __ STA P2 
1548 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
154b : ad 00 2f LDA $2f00 ; (search_query_len + 0)
154e : 18 __ __ CLC
154f : 69 08 __ ADC #$08
1551 : 85 0d __ STA P0 
1553 : a9 0b __ LDA #$0b
1555 : 85 0f __ STA P2 
1557 : a9 17 __ LDA #$17
1559 : 85 10 __ STA P3 
155b : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
155e : a9 02 __ LDA #$02
1560 : 85 53 __ STA T2 + 0 
1562 : a9 00 __ LDA #$00
1564 : 85 54 __ STA T2 + 1 
.s5:
1566 : ad f6 2e LDA $2ef6 ; (item_count + 0)
1569 : 85 55 __ STA T3 + 0 
156b : ad f7 2e LDA $2ef7 ; (item_count + 1)
156e : 85 56 __ STA T3 + 1 
1570 : 30 56 __ BMI $15c8 ; (draw_list.s6 + 0)
.s24:
1572 : 05 55 __ ORA T3 + 0 
1574 : f0 52 __ BEQ $15c8 ; (draw_list.s6 + 0)
.s23:
1576 : ad fc 2e LDA $2efc ; (offset + 0)
1579 : 18 __ __ CLC
157a : 69 01 __ ADC #$01
157c : 8d f8 9f STA $9ff8 ; (sstack + 2)
157f : a9 b0 __ LDA #$b0
1581 : 85 16 __ STA P9 
1583 : a9 9f __ LDA #$9f
1585 : 85 17 __ STA P10 
1587 : a9 a0 __ LDA #$a0
1589 : 8d f6 9f STA $9ff6 ; (sstack + 0)
158c : a9 21 __ LDA #$21
158e : 8d f7 9f STA $9ff7 ; (sstack + 1)
1591 : ad fd 2e LDA $2efd ; (offset + 1)
1594 : 69 00 __ ADC #$00
1596 : 8d f9 9f STA $9ff9 ; (sstack + 3)
1599 : 18 __ __ CLC
159a : a5 55 __ LDA T3 + 0 
159c : 6d fc 2e ADC $2efc ; (offset + 0)
159f : 8d fa 9f STA $9ffa ; (sstack + 4)
15a2 : a5 56 __ LDA T3 + 1 
15a4 : 6d fd 2e ADC $2efd ; (offset + 1)
15a7 : 8d fb 9f STA $9ffb ; (sstack + 5)
15aa : ad f8 2e LDA $2ef8 ; (total_count + 0)
15ad : 8d fc 9f STA $9ffc ; (sstack + 6)
15b0 : ad f9 2e LDA $2ef9 ; (total_count + 1)
15b3 : 8d fd 9f STA $9ffd ; (sstack + 7)
15b6 : 20 0d 17 JSR $170d ; (sprintf.s1 + 0)
15b9 : a9 9f __ LDA #$9f
15bb : 85 10 __ STA P3 
15bd : a9 02 __ LDA #$02
15bf : 85 0e __ STA P1 
15c1 : a9 b0 __ LDA #$b0
15c3 : 85 0f __ STA P2 
15c5 : 20 e9 2e JSR $2ee9 ; (print_at@proxy + 0)
.s6:
15c8 : a5 56 __ LDA T3 + 1 
15ca : 30 77 __ BMI $1643 ; (draw_list.s7 + 0)
.s22:
15cc : 05 55 __ ORA T3 + 0 
15ce : f0 73 __ BEQ $1643 ; (draw_list.s7 + 0)
.s14:
15d0 : a9 00 __ LDA #$00
15d2 : 85 43 __ STA T0 + 0 
15d4 : 18 __ __ CLC
.l15:
15d5 : 69 04 __ ADC #$04
15d7 : 85 0e __ STA P1 
15d9 : a5 43 __ LDA T0 + 0 
15db : 4a __ __ LSR
15dc : 6a __ __ ROR
15dd : 6a __ __ ROR
15de : aa __ __ TAX
15df : 29 c0 __ AND #$c0
15e1 : 6a __ __ ROR
15e2 : 69 80 __ ADC #$80
15e4 : 85 57 __ STA T5 + 0 
15e6 : 85 0f __ STA P2 
15e8 : 8a __ __ TXA
15e9 : 29 1f __ AND #$1f
15eb : 69 38 __ ADC #$38
15ed : 85 58 __ STA T5 + 1 
15ef : 85 10 __ STA P3 
15f1 : ad fb 2e LDA $2efb ; (cursor + 1)
15f4 : d0 07 __ BNE $15fd ; (draw_list.s16 + 0)
.s21:
15f6 : a5 43 __ LDA T0 + 0 
15f8 : cd fa 2e CMP $2efa ; (cursor + 0)
15fb : f0 0a __ BEQ $1607 ; (draw_list.s20 + 0)
.s16:
15fd : a9 02 __ LDA #$02
15ff : 85 0d __ STA P0 
1601 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
1604 : 4c 29 16 JMP $1629 ; (draw_list.s17 + 0)
.s20:
1607 : a9 00 __ LDA #$00
1609 : 85 0d __ STA P0 
160b : a9 21 __ LDA #$21
160d : 85 10 __ STA P3 
160f : a9 01 __ LDA #$01
1611 : 85 11 __ STA P4 
1613 : a9 ac __ LDA #$ac
1615 : 85 0f __ STA P2 
1617 : 20 7e 16 JSR $167e ; (print_at_color.s4 + 0)
161a : a5 57 __ LDA T5 + 0 
161c : 85 0f __ STA P2 
161e : a9 02 __ LDA #$02
1620 : 85 0d __ STA P0 
1622 : a5 58 __ LDA T5 + 1 
1624 : 85 10 __ STA P3 
1626 : 20 7e 16 JSR $167e ; (print_at_color.s4 + 0)
.s17:
1629 : 18 __ __ CLC
162a : a5 0e __ LDA P1 
162c : 69 fd __ ADC #$fd
162e : 85 43 __ STA T0 + 0 
1630 : a5 56 __ LDA T3 + 1 
1632 : f0 05 __ BEQ $1639 ; (draw_list.s19 + 0)
.s27:
1634 : a5 43 __ LDA T0 + 0 
1636 : 4c 3f 16 JMP $163f ; (draw_list.s18 + 0)
.s19:
1639 : a5 43 __ LDA T0 + 0 
163b : c5 55 __ CMP T3 + 0 
163d : b0 04 __ BCS $1643 ; (draw_list.s7 + 0)
.s18:
163f : c9 12 __ CMP #$12
1641 : 90 92 __ BCC $15d5 ; (draw_list.l15 + 0)
.s7:
1643 : a9 00 __ LDA #$00
1645 : 85 0d __ STA P0 
1647 : a9 17 __ LDA #$17
1649 : 85 0e __ STA P1 
164b : a5 53 __ LDA T2 + 0 
164d : 05 54 __ ORA T2 + 1 
164f : d0 16 __ BNE $1667 ; (draw_list.s8 + 0)
.s13:
1651 : a9 21 __ LDA #$21
1653 : a0 ae __ LDY #$ae
.s10:
1655 : 84 0f __ STY P2 
1657 : 85 10 __ STA P3 
1659 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
.s3:
165c : a2 05 __ LDX #$05
165e : bd a8 9f LDA $9fa8,x ; (draw_list@stack + 0)
1661 : 95 53 __ STA T2 + 0,x 
1663 : ca __ __ DEX
1664 : 10 f8 __ BPL $165e ; (draw_list.s3 + 2)
1666 : 60 __ __ RTS
.s8:
1667 : a5 54 __ LDA T2 + 1 
1669 : d0 05 __ BNE $1670 ; (draw_list.s9 + 0)
.s12:
166b : a6 53 __ LDX T2 + 0 
166d : ca __ __ DEX
166e : f0 07 __ BEQ $1677 ; (draw_list.s11 + 0)
.s9:
1670 : a9 22 __ LDA #$22
1672 : a0 00 __ LDY #$00
1674 : 4c 55 16 JMP $1655 ; (draw_list.s10 + 0)
.s11:
1677 : a9 21 __ LDA #$21
1679 : a0 d1 __ LDY #$d1
167b : 4c 55 16 JMP $1655 ; (draw_list.s10 + 0)
--------------------------------------------------------------------
print_at_color: ; print_at_color(u8,u8,const u8*,u8)->void
;  80, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
167e : a5 0e __ LDA P1 ; (y + 0)
1680 : 0a __ __ ASL
1681 : 85 1b __ STA ACCU + 0 
1683 : a9 00 __ LDA #$00
1685 : 2a __ __ ROL
1686 : 06 1b __ ASL ACCU + 0 
1688 : 2a __ __ ROL
1689 : aa __ __ TAX
168a : a5 1b __ LDA ACCU + 0 
168c : 65 0e __ ADC P1 ; (y + 0)
168e : 85 43 __ STA T1 + 0 
1690 : 8a __ __ TXA
1691 : 69 00 __ ADC #$00
1693 : 06 43 __ ASL T1 + 0 
1695 : 2a __ __ ROL
1696 : 06 43 __ ASL T1 + 0 
1698 : 2a __ __ ROL
1699 : 06 43 __ ASL T1 + 0 
169b : 2a __ __ ROL
169c : aa __ __ TAX
169d : a5 43 __ LDA T1 + 0 
169f : 65 0d __ ADC P0 ; (x + 0)
16a1 : 85 45 __ STA T2 + 0 
16a3 : 85 43 __ STA T1 + 0 
16a5 : 8a __ __ TXA
16a6 : 69 04 __ ADC #$04
16a8 : 85 46 __ STA T2 + 1 
16aa : 69 d4 __ ADC #$d4
16ac : 85 44 __ STA T1 + 1 
16ae : a0 00 __ LDY #$00
16b0 : b1 0f __ LDA (P2),y ; (text + 0)
16b2 : f0 4d __ BEQ $1701 ; (print_at_color.s3 + 0)
.s14:
16b4 : a6 0f __ LDX P2 ; (text + 0)
.l5:
16b6 : 86 1b __ STX ACCU + 0 
16b8 : 8a __ __ TXA
16b9 : 18 __ __ CLC
16ba : 69 01 __ ADC #$01
16bc : aa __ __ TAX
16bd : a5 10 __ LDA P3 ; (text + 1)
16bf : 85 1c __ STA ACCU + 1 
16c1 : 69 00 __ ADC #$00
16c3 : 85 10 __ STA P3 ; (text + 1)
16c5 : a0 00 __ LDY #$00
16c7 : b1 1b __ LDA (ACCU + 0),y 
16c9 : c9 61 __ CMP #$61
16cb : 90 09 __ BCC $16d6 ; (print_at_color.s6 + 0)
.s11:
16cd : c9 7b __ CMP #$7b
16cf : b0 05 __ BCS $16d6 ; (print_at_color.s6 + 0)
.s12:
16d1 : 69 a0 __ ADC #$a0
16d3 : 4c e9 16 JMP $16e9 ; (print_at_color.s13 + 0)
.s6:
16d6 : c9 41 __ CMP #$41
16d8 : 90 0f __ BCC $16e9 ; (print_at_color.s13 + 0)
.s7:
16da : c9 5b __ CMP #$5b
16dc : b0 05 __ BCS $16e3 ; (print_at_color.s8 + 0)
.s10:
16de : 69 c0 __ ADC #$c0
16e0 : 4c e9 16 JMP $16e9 ; (print_at_color.s13 + 0)
.s8:
16e3 : c9 7c __ CMP #$7c
16e5 : d0 02 __ BNE $16e9 ; (print_at_color.s13 + 0)
.s9:
16e7 : a9 20 __ LDA #$20
.s13:
16e9 : 91 45 __ STA (T2 + 0),y 
16eb : a5 11 __ LDA P4 ; (color + 0)
16ed : 91 43 __ STA (T1 + 0),y 
16ef : e6 45 __ INC T2 + 0 
16f1 : d0 02 __ BNE $16f5 ; (print_at_color.s16 + 0)
.s15:
16f3 : e6 46 __ INC T2 + 1 
.s16:
16f5 : e6 43 __ INC T1 + 0 
16f7 : d0 02 __ BNE $16fb ; (print_at_color.s18 + 0)
.s17:
16f9 : e6 44 __ INC T1 + 1 
.s18:
16fb : a0 01 __ LDY #$01
16fd : b1 1b __ LDA (ACCU + 0),y 
16ff : d0 b5 __ BNE $16b6 ; (print_at_color.l5 + 0)
.s3:
1701 : 60 __ __ RTS
--------------------------------------------------------------------
1702 : __ __ __ BYT 73 65 61 72 63 68 3a 20 00                      : search: .
--------------------------------------------------------------------
170b : __ __ __ BYT 5f 00                                           : _.
--------------------------------------------------------------------
sprintf: ; sprintf(u8*,const u8*)->void
;  20, "/usr/local/include/oscar64/stdio.h"
.s1:
170d : a2 03 __ LDX #$03
170f : b5 53 __ LDA T3 + 0,x 
1711 : 9d d8 9f STA $9fd8,x ; (sprintf@stack + 0)
1714 : ca __ __ DEX
1715 : 10 f8 __ BPL $170f ; (sprintf.s1 + 2)
.s4:
1717 : ad f6 9f LDA $9ff6 ; (sstack + 0)
171a : 85 55 __ STA T4 + 0 
171c : a9 f8 __ LDA #$f8
171e : 85 53 __ STA T3 + 0 
1720 : a9 9f __ LDA #$9f
1722 : 85 54 __ STA T3 + 1 
1724 : a9 00 __ LDA #$00
1726 : 85 49 __ STA T2 + 0 
1728 : ad f7 9f LDA $9ff7 ; (sstack + 1)
172b : 85 56 __ STA T4 + 1 
.l5:
172d : a0 00 __ LDY #$00
172f : b1 55 __ LDA (T4 + 0),y 
1731 : d0 0f __ BNE $1742 ; (sprintf.s7 + 0)
.s6:
1733 : a4 49 __ LDY T2 + 0 
1735 : 91 16 __ STA (P9),y ; (str + 0)
.s3:
1737 : a2 03 __ LDX #$03
1739 : bd d8 9f LDA $9fd8,x ; (sprintf@stack + 0)
173c : 95 53 __ STA T3 + 0,x 
173e : ca __ __ DEX
173f : 10 f8 __ BPL $1739 ; (sprintf.s3 + 2)
1741 : 60 __ __ RTS
.s7:
1742 : c9 25 __ CMP #$25
1744 : f0 22 __ BEQ $1768 ; (sprintf.s10 + 0)
.s8:
1746 : a4 49 __ LDY T2 + 0 
1748 : 91 16 __ STA (P9),y ; (str + 0)
174a : e6 55 __ INC T4 + 0 
174c : d0 02 __ BNE $1750 ; (sprintf.s114 + 0)
.s113:
174e : e6 56 __ INC T4 + 1 
.s114:
1750 : c8 __ __ INY
1751 : 84 49 __ STY T2 + 0 
1753 : 98 __ __ TYA
1754 : c0 28 __ CPY #$28
1756 : 90 d5 __ BCC $172d ; (sprintf.l5 + 0)
.s9:
1758 : 18 __ __ CLC
1759 : 65 16 __ ADC P9 ; (str + 0)
175b : 85 16 __ STA P9 ; (str + 0)
175d : 90 02 __ BCC $1761 ; (sprintf.s116 + 0)
.s115:
175f : e6 17 __ INC P10 ; (str + 1)
.s116:
1761 : a9 00 __ LDA #$00
.s87:
1763 : 85 49 __ STA T2 + 0 
1765 : 4c 2d 17 JMP $172d ; (sprintf.l5 + 0)
.s10:
1768 : 8c e5 9f STY $9fe5 ; (si.prefix + 0)
176b : a5 49 __ LDA T2 + 0 
176d : f0 0c __ BEQ $177b ; (sprintf.s11 + 0)
.s82:
176f : 84 49 __ STY T2 + 0 
1771 : 18 __ __ CLC
1772 : 65 16 __ ADC P9 ; (str + 0)
1774 : 85 16 __ STA P9 ; (str + 0)
1776 : 90 02 __ BCC $177a ; (sprintf.s95 + 0)
.s94:
1778 : e6 17 __ INC P10 ; (str + 1)
.s95:
177a : 98 __ __ TYA
.s11:
177b : 8d e3 9f STA $9fe3 ; (si.sign + 0)
177e : 8d e4 9f STA $9fe4 ; (si.left + 0)
1781 : a0 01 __ LDY #$01
1783 : b1 55 __ LDA (T4 + 0),y 
1785 : a2 20 __ LDX #$20
1787 : 8e de 9f STX $9fde ; (si.fill + 0)
178a : a2 00 __ LDX #$00
178c : 8e df 9f STX $9fdf ; (si.width + 0)
178f : ca __ __ DEX
1790 : 8e e0 9f STX $9fe0 ; (si.precision + 0)
1793 : a2 0a __ LDX #$0a
1795 : 8e e2 9f STX $9fe2 ; (si.base + 0)
1798 : aa __ __ TAX
1799 : a9 02 __ LDA #$02
179b : d0 07 __ BNE $17a4 ; (sprintf.l12 + 0)
.s78:
179d : a0 00 __ LDY #$00
179f : b1 55 __ LDA (T4 + 0),y 
17a1 : aa __ __ TAX
17a2 : a9 01 __ LDA #$01
.l12:
17a4 : 18 __ __ CLC
17a5 : 65 55 __ ADC T4 + 0 
17a7 : 85 55 __ STA T4 + 0 
17a9 : 90 02 __ BCC $17ad ; (sprintf.s97 + 0)
.s96:
17ab : e6 56 __ INC T4 + 1 
.s97:
17ad : 8a __ __ TXA
17ae : e0 2b __ CPX #$2b
17b0 : d0 07 __ BNE $17b9 ; (sprintf.s13 + 0)
.s81:
17b2 : a9 01 __ LDA #$01
17b4 : 8d e3 9f STA $9fe3 ; (si.sign + 0)
17b7 : d0 e4 __ BNE $179d ; (sprintf.s78 + 0)
.s13:
17b9 : c9 30 __ CMP #$30
17bb : d0 06 __ BNE $17c3 ; (sprintf.s14 + 0)
.s80:
17bd : 8d de 9f STA $9fde ; (si.fill + 0)
17c0 : 4c 9d 17 JMP $179d ; (sprintf.s78 + 0)
.s14:
17c3 : c9 23 __ CMP #$23
17c5 : d0 07 __ BNE $17ce ; (sprintf.s15 + 0)
.s79:
17c7 : a9 01 __ LDA #$01
17c9 : 8d e5 9f STA $9fe5 ; (si.prefix + 0)
17cc : d0 cf __ BNE $179d ; (sprintf.s78 + 0)
.s15:
17ce : c9 2d __ CMP #$2d
17d0 : d0 07 __ BNE $17d9 ; (sprintf.s16 + 0)
.s77:
17d2 : a9 01 __ LDA #$01
17d4 : 8d e4 9f STA $9fe4 ; (si.left + 0)
17d7 : d0 c4 __ BNE $179d ; (sprintf.s78 + 0)
.s16:
17d9 : 85 4b __ STA T6 + 0 
17db : c9 30 __ CMP #$30
17dd : 90 31 __ BCC $1810 ; (sprintf.s17 + 0)
.s72:
17df : c9 3a __ CMP #$3a
17e1 : b0 5e __ BCS $1841 ; (sprintf.s18 + 0)
.s73:
17e3 : a9 00 __ LDA #$00
17e5 : 85 47 __ STA T1 + 0 
.l74:
17e7 : a5 47 __ LDA T1 + 0 
17e9 : 0a __ __ ASL
17ea : 0a __ __ ASL
17eb : 18 __ __ CLC
17ec : 65 47 __ ADC T1 + 0 
17ee : 0a __ __ ASL
17ef : 18 __ __ CLC
17f0 : 65 4b __ ADC T6 + 0 
17f2 : 38 __ __ SEC
17f3 : e9 30 __ SBC #$30
17f5 : 85 47 __ STA T1 + 0 
17f7 : a0 00 __ LDY #$00
17f9 : b1 55 __ LDA (T4 + 0),y 
17fb : 85 4b __ STA T6 + 0 
17fd : e6 55 __ INC T4 + 0 
17ff : d0 02 __ BNE $1803 ; (sprintf.s112 + 0)
.s111:
1801 : e6 56 __ INC T4 + 1 
.s112:
1803 : c9 30 __ CMP #$30
1805 : 90 04 __ BCC $180b ; (sprintf.s75 + 0)
.s76:
1807 : c9 3a __ CMP #$3a
1809 : 90 dc __ BCC $17e7 ; (sprintf.l74 + 0)
.s75:
180b : a6 47 __ LDX T1 + 0 
180d : 8e df 9f STX $9fdf ; (si.width + 0)
.s17:
1810 : c9 2e __ CMP #$2e
1812 : d0 2d __ BNE $1841 ; (sprintf.s18 + 0)
.s67:
1814 : a9 00 __ LDA #$00
1816 : f0 0e __ BEQ $1826 ; (sprintf.l68 + 0)
.s71:
1818 : a5 43 __ LDA T0 + 0 
181a : 0a __ __ ASL
181b : 0a __ __ ASL
181c : 18 __ __ CLC
181d : 65 43 __ ADC T0 + 0 
181f : 0a __ __ ASL
1820 : 18 __ __ CLC
1821 : 65 4b __ ADC T6 + 0 
1823 : 38 __ __ SEC
1824 : e9 30 __ SBC #$30
.l68:
1826 : 85 43 __ STA T0 + 0 
1828 : a0 00 __ LDY #$00
182a : b1 55 __ LDA (T4 + 0),y 
182c : 85 4b __ STA T6 + 0 
182e : e6 55 __ INC T4 + 0 
1830 : d0 02 __ BNE $1834 ; (sprintf.s99 + 0)
.s98:
1832 : e6 56 __ INC T4 + 1 
.s99:
1834 : c9 30 __ CMP #$30
1836 : 90 04 __ BCC $183c ; (sprintf.s69 + 0)
.s70:
1838 : c9 3a __ CMP #$3a
183a : 90 dc __ BCC $1818 ; (sprintf.s71 + 0)
.s69:
183c : a6 43 __ LDX T0 + 0 
183e : 8e e0 9f STX $9fe0 ; (si.precision + 0)
.s18:
1841 : c9 64 __ CMP #$64
1843 : f0 0c __ BEQ $1851 ; (sprintf.s66 + 0)
.s19:
1845 : c9 44 __ CMP #$44
1847 : f0 08 __ BEQ $1851 ; (sprintf.s66 + 0)
.s20:
1849 : c9 69 __ CMP #$69
184b : f0 04 __ BEQ $1851 ; (sprintf.s66 + 0)
.s21:
184d : c9 49 __ CMP #$49
184f : d0 11 __ BNE $1862 ; (sprintf.s22 + 0)
.s66:
1851 : a0 00 __ LDY #$00
1853 : b1 53 __ LDA (T3 + 0),y 
1855 : 85 11 __ STA P4 
1857 : c8 __ __ INY
1858 : b1 53 __ LDA (T3 + 0),y 
185a : 85 12 __ STA P5 
185c : 98 __ __ TYA
.s85:
185d : 85 13 __ STA P6 
185f : 4c 48 1a JMP $1a48 ; (sprintf.s64 + 0)
.s22:
1862 : c9 75 __ CMP #$75
1864 : f0 04 __ BEQ $186a ; (sprintf.s65 + 0)
.s23:
1866 : c9 55 __ CMP #$55
1868 : d0 0f __ BNE $1879 ; (sprintf.s24 + 0)
.s65:
186a : a0 00 __ LDY #$00
186c : b1 53 __ LDA (T3 + 0),y 
186e : 85 11 __ STA P4 
1870 : c8 __ __ INY
1871 : b1 53 __ LDA (T3 + 0),y 
1873 : 85 12 __ STA P5 
1875 : a9 00 __ LDA #$00
1877 : f0 e4 __ BEQ $185d ; (sprintf.s85 + 0)
.s24:
1879 : c9 78 __ CMP #$78
187b : f0 04 __ BEQ $1881 ; (sprintf.s63 + 0)
.s25:
187d : c9 58 __ CMP #$58
187f : d0 1e __ BNE $189f ; (sprintf.s26 + 0)
.s63:
1881 : a0 00 __ LDY #$00
1883 : 84 13 __ STY P6 
1885 : a9 10 __ LDA #$10
1887 : 8d e2 9f STA $9fe2 ; (si.base + 0)
188a : b1 53 __ LDA (T3 + 0),y 
188c : 85 11 __ STA P4 
188e : c8 __ __ INY
188f : b1 53 __ LDA (T3 + 0),y 
1891 : 85 12 __ STA P5 
1893 : a5 4b __ LDA T6 + 0 
1895 : 29 e0 __ AND #$e0
1897 : 09 01 __ ORA #$01
1899 : 8d e1 9f STA $9fe1 ; (si.cha + 0)
189c : 4c 48 1a JMP $1a48 ; (sprintf.s64 + 0)
.s26:
189f : c9 6c __ CMP #$6c
18a1 : d0 03 __ BNE $18a6 ; (sprintf.s27 + 0)
18a3 : 4c cd 19 JMP $19cd ; (sprintf.s51 + 0)
.s27:
18a6 : c9 4c __ CMP #$4c
18a8 : f0 f9 __ BEQ $18a3 ; (sprintf.s26 + 4)
.s28:
18aa : c9 66 __ CMP #$66
18ac : f0 14 __ BEQ $18c2 ; (sprintf.s50 + 0)
.s29:
18ae : c9 67 __ CMP #$67
18b0 : f0 10 __ BEQ $18c2 ; (sprintf.s50 + 0)
.s30:
18b2 : c9 65 __ CMP #$65
18b4 : f0 0c __ BEQ $18c2 ; (sprintf.s50 + 0)
.s31:
18b6 : c9 46 __ CMP #$46
18b8 : f0 08 __ BEQ $18c2 ; (sprintf.s50 + 0)
.s32:
18ba : c9 47 __ CMP #$47
18bc : f0 04 __ BEQ $18c2 ; (sprintf.s50 + 0)
.s33:
18be : c9 45 __ CMP #$45
18c0 : d0 44 __ BNE $1906 ; (sprintf.s34 + 0)
.s50:
18c2 : a5 16 __ LDA P9 ; (str + 0)
18c4 : 85 0f __ STA P2 
18c6 : a5 17 __ LDA P10 ; (str + 1)
18c8 : 85 10 __ STA P3 
18ca : a0 00 __ LDY #$00
18cc : b1 53 __ LDA (T3 + 0),y 
18ce : 85 11 __ STA P4 
18d0 : c8 __ __ INY
18d1 : b1 53 __ LDA (T3 + 0),y 
18d3 : 85 12 __ STA P5 
18d5 : c8 __ __ INY
18d6 : b1 53 __ LDA (T3 + 0),y 
18d8 : 85 13 __ STA P6 
18da : c8 __ __ INY
18db : b1 53 __ LDA (T3 + 0),y 
18dd : 85 14 __ STA P7 
18df : a5 4b __ LDA T6 + 0 
18e1 : 29 e0 __ AND #$e0
18e3 : 09 01 __ ORA #$01
18e5 : 8d e1 9f STA $9fe1 ; (si.cha + 0)
18e8 : a9 de __ LDA #$de
18ea : 85 0d __ STA P0 
18ec : a9 9f __ LDA #$9f
18ee : 85 0e __ STA P1 
18f0 : a5 4b __ LDA T6 + 0 
18f2 : ed e1 9f SBC $9fe1 ; (si.cha + 0)
18f5 : 18 __ __ CLC
18f6 : 69 61 __ ADC #$61
18f8 : 85 15 __ STA P8 
18fa : 20 c7 1c JSR $1cc7 ; (nformf.s1 + 0)
18fd : a5 1b __ LDA ACCU + 0 ; (fmt + 2)
18ff : 85 49 __ STA T2 + 0 
1901 : a9 04 __ LDA #$04
1903 : 4c c1 19 JMP $19c1 ; (sprintf.s84 + 0)
.s34:
1906 : c9 73 __ CMP #$73
1908 : f0 2d __ BEQ $1937 ; (sprintf.s42 + 0)
.s35:
190a : c9 53 __ CMP #$53
190c : f0 29 __ BEQ $1937 ; (sprintf.s42 + 0)
.s36:
190e : c9 63 __ CMP #$63
1910 : f0 13 __ BEQ $1925 ; (sprintf.s41 + 0)
.s37:
1912 : c9 43 __ CMP #$43
1914 : f0 0f __ BEQ $1925 ; (sprintf.s41 + 0)
.s38:
1916 : aa __ __ TAX
1917 : d0 03 __ BNE $191c ; (sprintf.s39 + 0)
1919 : 4c 2d 17 JMP $172d ; (sprintf.l5 + 0)
.s39:
191c : a0 00 __ LDY #$00
191e : 91 16 __ STA (P9),y ; (str + 0)
.s40:
1920 : a9 01 __ LDA #$01
1922 : 4c 63 17 JMP $1763 ; (sprintf.s87 + 0)
.s41:
1925 : a0 00 __ LDY #$00
1927 : b1 53 __ LDA (T3 + 0),y 
1929 : 91 16 __ STA (P9),y ; (str + 0)
192b : a5 53 __ LDA T3 + 0 
192d : 69 01 __ ADC #$01
192f : 85 53 __ STA T3 + 0 
1931 : 90 ed __ BCC $1920 ; (sprintf.s40 + 0)
.s110:
1933 : e6 54 __ INC T3 + 1 
1935 : b0 e9 __ BCS $1920 ; (sprintf.s40 + 0)
.s42:
1937 : a0 00 __ LDY #$00
1939 : 84 4b __ STY T6 + 0 
193b : b1 53 __ LDA (T3 + 0),y 
193d : 85 43 __ STA T0 + 0 
193f : c8 __ __ INY
1940 : b1 53 __ LDA (T3 + 0),y 
1942 : 85 44 __ STA T0 + 1 
1944 : a5 53 __ LDA T3 + 0 
1946 : 69 01 __ ADC #$01
1948 : 85 53 __ STA T3 + 0 
194a : 90 02 __ BCC $194e ; (sprintf.s106 + 0)
.s105:
194c : e6 54 __ INC T3 + 1 
.s106:
194e : ad df 9f LDA $9fdf ; (si.width + 0)
1951 : f0 0d __ BEQ $1960 ; (sprintf.s43 + 0)
.s91:
1953 : a0 00 __ LDY #$00
1955 : b1 43 __ LDA (T0 + 0),y 
1957 : f0 05 __ BEQ $195e ; (sprintf.s92 + 0)
.l49:
1959 : c8 __ __ INY
195a : b1 43 __ LDA (T0 + 0),y 
195c : d0 fb __ BNE $1959 ; (sprintf.l49 + 0)
.s92:
195e : 84 4b __ STY T6 + 0 
.s43:
1960 : ad e4 9f LDA $9fe4 ; (si.left + 0)
1963 : 85 4d __ STA T8 + 0 
1965 : d0 19 __ BNE $1980 ; (sprintf.s44 + 0)
.s89:
1967 : a6 4b __ LDX T6 + 0 
1969 : ec df 9f CPX $9fdf ; (si.width + 0)
196c : a0 00 __ LDY #$00
196e : b0 0c __ BCS $197c ; (sprintf.s90 + 0)
.l48:
1970 : ad de 9f LDA $9fde ; (si.fill + 0)
1973 : 91 16 __ STA (P9),y ; (str + 0)
1975 : c8 __ __ INY
1976 : e8 __ __ INX
1977 : ec df 9f CPX $9fdf ; (si.width + 0)
197a : 90 f4 __ BCC $1970 ; (sprintf.l48 + 0)
.s90:
197c : 86 4b __ STX T6 + 0 
197e : 84 49 __ STY T2 + 0 
.s44:
1980 : a0 00 __ LDY #$00
1982 : b1 43 __ LDA (T0 + 0),y 
1984 : f0 1a __ BEQ $19a0 ; (sprintf.s45 + 0)
.s47:
1986 : e6 43 __ INC T0 + 0 
1988 : d0 02 __ BNE $198c ; (sprintf.l83 + 0)
.s107:
198a : e6 44 __ INC T0 + 1 
.l83:
198c : a4 49 __ LDY T2 + 0 
198e : 91 16 __ STA (P9),y ; (str + 0)
1990 : e6 49 __ INC T2 + 0 
1992 : a0 00 __ LDY #$00
1994 : b1 43 __ LDA (T0 + 0),y 
1996 : a8 __ __ TAY
1997 : e6 43 __ INC T0 + 0 
1999 : d0 02 __ BNE $199d ; (sprintf.s109 + 0)
.s108:
199b : e6 44 __ INC T0 + 1 
.s109:
199d : 98 __ __ TYA
199e : d0 ec __ BNE $198c ; (sprintf.l83 + 0)
.s45:
19a0 : a5 4d __ LDA T8 + 0 
19a2 : d0 03 __ BNE $19a7 ; (sprintf.s88 + 0)
19a4 : 4c 2d 17 JMP $172d ; (sprintf.l5 + 0)
.s88:
19a7 : a6 4b __ LDX T6 + 0 
19a9 : ec df 9f CPX $9fdf ; (si.width + 0)
19ac : a4 49 __ LDY T2 + 0 
19ae : b0 0c __ BCS $19bc ; (sprintf.s93 + 0)
.l46:
19b0 : ad de 9f LDA $9fde ; (si.fill + 0)
19b3 : 91 16 __ STA (P9),y ; (str + 0)
19b5 : c8 __ __ INY
19b6 : e8 __ __ INX
19b7 : ec df 9f CPX $9fdf ; (si.width + 0)
19ba : 90 f4 __ BCC $19b0 ; (sprintf.l46 + 0)
.s93:
19bc : 84 49 __ STY T2 + 0 
19be : 4c 2d 17 JMP $172d ; (sprintf.l5 + 0)
.s84:
19c1 : 18 __ __ CLC
19c2 : 65 53 __ ADC T3 + 0 
19c4 : 85 53 __ STA T3 + 0 
19c6 : 90 f6 __ BCC $19be ; (sprintf.s93 + 2)
.s100:
19c8 : e6 54 __ INC T3 + 1 
19ca : 4c 2d 17 JMP $172d ; (sprintf.l5 + 0)
.s51:
19cd : a0 00 __ LDY #$00
19cf : b1 53 __ LDA (T3 + 0),y 
19d1 : 85 11 __ STA P4 
19d3 : c8 __ __ INY
19d4 : b1 53 __ LDA (T3 + 0),y 
19d6 : 85 12 __ STA P5 
19d8 : c8 __ __ INY
19d9 : b1 53 __ LDA (T3 + 0),y 
19db : 85 13 __ STA P6 
19dd : c8 __ __ INY
19de : b1 53 __ LDA (T3 + 0),y 
19e0 : 85 14 __ STA P7 
19e2 : a5 53 __ LDA T3 + 0 
19e4 : 69 03 __ ADC #$03
19e6 : 85 53 __ STA T3 + 0 
19e8 : 90 02 __ BCC $19ec ; (sprintf.s102 + 0)
.s101:
19ea : e6 54 __ INC T3 + 1 
.s102:
19ec : a0 00 __ LDY #$00
19ee : b1 55 __ LDA (T4 + 0),y 
19f0 : aa __ __ TAX
19f1 : e6 55 __ INC T4 + 0 
19f3 : d0 02 __ BNE $19f7 ; (sprintf.s104 + 0)
.s103:
19f5 : e6 56 __ INC T4 + 1 
.s104:
19f7 : e0 64 __ CPX #$64
19f9 : f0 0c __ BEQ $1a07 ; (sprintf.s62 + 0)
.s52:
19fb : e0 44 __ CPX #$44
19fd : f0 08 __ BEQ $1a07 ; (sprintf.s62 + 0)
.s53:
19ff : e0 69 __ CPX #$69
1a01 : f0 04 __ BEQ $1a07 ; (sprintf.s62 + 0)
.s54:
1a03 : e0 49 __ CPX #$49
1a05 : d0 1c __ BNE $1a23 ; (sprintf.s55 + 0)
.s62:
1a07 : a9 01 __ LDA #$01
.s86:
1a09 : 85 15 __ STA P8 
.s60:
1a0b : a5 16 __ LDA P9 ; (str + 0)
1a0d : 85 0f __ STA P2 
1a0f : a5 17 __ LDA P10 ; (str + 1)
1a11 : 85 10 __ STA P3 
1a13 : a9 de __ LDA #$de
1a15 : 85 0d __ STA P0 
1a17 : a9 9f __ LDA #$9f
1a19 : 85 0e __ STA P1 
1a1b : 20 7d 1b JSR $1b7d ; (nforml.s4 + 0)
1a1e : a5 1b __ LDA ACCU + 0 ; (fmt + 2)
1a20 : 4c 63 17 JMP $1763 ; (sprintf.s87 + 0)
.s55:
1a23 : e0 75 __ CPX #$75
1a25 : f0 04 __ BEQ $1a2b ; (sprintf.s61 + 0)
.s56:
1a27 : e0 55 __ CPX #$55
1a29 : d0 03 __ BNE $1a2e ; (sprintf.s57 + 0)
.s61:
1a2b : 98 __ __ TYA
1a2c : f0 db __ BEQ $1a09 ; (sprintf.s86 + 0)
.s57:
1a2e : e0 78 __ CPX #$78
1a30 : f0 04 __ BEQ $1a36 ; (sprintf.s59 + 0)
.s58:
1a32 : e0 58 __ CPX #$58
1a34 : d0 94 __ BNE $19ca ; (sprintf.s100 + 2)
.s59:
1a36 : 84 15 __ STY P8 
1a38 : a9 10 __ LDA #$10
1a3a : 8d e2 9f STA $9fe2 ; (si.base + 0)
1a3d : 8a __ __ TXA
1a3e : 29 e0 __ AND #$e0
1a40 : 09 01 __ ORA #$01
1a42 : 8d e1 9f STA $9fe1 ; (si.cha + 0)
1a45 : 4c 0b 1a JMP $1a0b ; (sprintf.s60 + 0)
.s64:
1a48 : a5 16 __ LDA P9 ; (str + 0)
1a4a : 85 0f __ STA P2 
1a4c : a5 17 __ LDA P10 ; (str + 1)
1a4e : 85 10 __ STA P3 
1a50 : a9 de __ LDA #$de
1a52 : 85 0d __ STA P0 
1a54 : a9 9f __ LDA #$9f
1a56 : 85 0e __ STA P1 
1a58 : 20 62 1a JSR $1a62 ; (nformi.s4 + 0)
1a5b : 85 49 __ STA T2 + 0 
1a5d : a9 02 __ LDA #$02
1a5f : 4c c1 19 JMP $19c1 ; (sprintf.s84 + 0)
--------------------------------------------------------------------
nformi: ; nformi(const struct sinfo*,u8*,i16,bool)->u8
;  79, "/usr/local/include/oscar64/stdio.c"
.s4:
1a62 : a9 00 __ LDA #$00
1a64 : 85 43 __ STA T5 + 0 
1a66 : a0 04 __ LDY #$04
1a68 : b1 0d __ LDA (P0),y ; (si + 0)
1a6a : 85 44 __ STA T6 + 0 
1a6c : a5 13 __ LDA P6 ; (s + 0)
1a6e : f0 13 __ BEQ $1a83 ; (nformi.s5 + 0)
.s33:
1a70 : 24 12 __ BIT P5 ; (v + 1)
1a72 : 10 0f __ BPL $1a83 ; (nformi.s5 + 0)
.s34:
1a74 : 38 __ __ SEC
1a75 : a9 00 __ LDA #$00
1a77 : e5 11 __ SBC P4 ; (v + 0)
1a79 : 85 11 __ STA P4 ; (v + 0)
1a7b : a9 00 __ LDA #$00
1a7d : e5 12 __ SBC P5 ; (v + 1)
1a7f : 85 12 __ STA P5 ; (v + 1)
1a81 : e6 43 __ INC T5 + 0 
.s5:
1a83 : a9 10 __ LDA #$10
1a85 : 85 45 __ STA T7 + 0 
1a87 : a5 11 __ LDA P4 ; (v + 0)
1a89 : 05 12 __ ORA P5 ; (v + 1)
1a8b : f0 33 __ BEQ $1ac0 ; (nformi.s6 + 0)
.s28:
1a8d : a5 11 __ LDA P4 ; (v + 0)
1a8f : 85 1b __ STA ACCU + 0 
1a91 : a5 12 __ LDA P5 ; (v + 1)
1a93 : 85 1c __ STA ACCU + 1 
.l29:
1a95 : a5 44 __ LDA T6 + 0 
1a97 : 85 03 __ STA WORK + 0 
1a99 : a9 00 __ LDA #$00
1a9b : 85 04 __ STA WORK + 1 
1a9d : 20 c7 2a JSR $2ac7 ; (divmod + 0)
1aa0 : a5 05 __ LDA WORK + 2 
1aa2 : c9 0a __ CMP #$0a
1aa4 : b0 04 __ BCS $1aaa ; (nformi.s32 + 0)
.s30:
1aa6 : a9 30 __ LDA #$30
1aa8 : 90 06 __ BCC $1ab0 ; (nformi.s31 + 0)
.s32:
1aaa : a0 03 __ LDY #$03
1aac : b1 0d __ LDA (P0),y ; (si + 0)
1aae : e9 0a __ SBC #$0a
.s31:
1ab0 : 18 __ __ CLC
1ab1 : 65 05 __ ADC WORK + 2 
1ab3 : a6 45 __ LDX T7 + 0 
1ab5 : 9d e5 9f STA $9fe5,x ; (si.prefix + 0)
1ab8 : c6 45 __ DEC T7 + 0 
1aba : a5 1b __ LDA ACCU + 0 
1abc : 05 1c __ ORA ACCU + 1 
1abe : d0 d5 __ BNE $1a95 ; (nformi.l29 + 0)
.s6:
1ac0 : a0 02 __ LDY #$02
1ac2 : b1 0d __ LDA (P0),y ; (si + 0)
1ac4 : c9 ff __ CMP #$ff
1ac6 : d0 04 __ BNE $1acc ; (nformi.s27 + 0)
.s7:
1ac8 : a9 0f __ LDA #$0f
1aca : d0 05 __ BNE $1ad1 ; (nformi.s39 + 0)
.s27:
1acc : 38 __ __ SEC
1acd : a9 10 __ LDA #$10
1acf : f1 0d __ SBC (P0),y ; (si + 0)
.s39:
1ad1 : a8 __ __ TAY
1ad2 : c4 45 __ CPY T7 + 0 
1ad4 : b0 0d __ BCS $1ae3 ; (nformi.s8 + 0)
.s26:
1ad6 : a9 30 __ LDA #$30
.l40:
1ad8 : a6 45 __ LDX T7 + 0 
1ada : 9d e5 9f STA $9fe5,x ; (si.prefix + 0)
1add : c6 45 __ DEC T7 + 0 
1adf : c4 45 __ CPY T7 + 0 
1ae1 : 90 f5 __ BCC $1ad8 ; (nformi.l40 + 0)
.s8:
1ae3 : a0 07 __ LDY #$07
1ae5 : b1 0d __ LDA (P0),y ; (si + 0)
1ae7 : f0 1c __ BEQ $1b05 ; (nformi.s9 + 0)
.s24:
1ae9 : a5 44 __ LDA T6 + 0 
1aeb : c9 10 __ CMP #$10
1aed : d0 16 __ BNE $1b05 ; (nformi.s9 + 0)
.s25:
1aef : a0 03 __ LDY #$03
1af1 : b1 0d __ LDA (P0),y ; (si + 0)
1af3 : a8 __ __ TAY
1af4 : a9 30 __ LDA #$30
1af6 : a6 45 __ LDX T7 + 0 
1af8 : ca __ __ DEX
1af9 : ca __ __ DEX
1afa : 86 45 __ STX T7 + 0 
1afc : 9d e6 9f STA $9fe6,x ; (buffer[0] + 0)
1aff : 98 __ __ TYA
1b00 : 69 16 __ ADC #$16
1b02 : 9d e7 9f STA $9fe7,x ; (buffer[0] + 1)
.s9:
1b05 : a9 00 __ LDA #$00
1b07 : 85 1b __ STA ACCU + 0 
1b09 : a5 43 __ LDA T5 + 0 
1b0b : f0 0c __ BEQ $1b19 ; (nformi.s10 + 0)
.s23:
1b0d : a9 2d __ LDA #$2d
.s22:
1b0f : a6 45 __ LDX T7 + 0 
1b11 : 9d e5 9f STA $9fe5,x ; (si.prefix + 0)
1b14 : c6 45 __ DEC T7 + 0 
1b16 : 4c 23 1b JMP $1b23 ; (nformi.s11 + 0)
.s10:
1b19 : a0 05 __ LDY #$05
1b1b : b1 0d __ LDA (P0),y ; (si + 0)
1b1d : f0 04 __ BEQ $1b23 ; (nformi.s11 + 0)
.s21:
1b1f : a9 2b __ LDA #$2b
1b21 : d0 ec __ BNE $1b0f ; (nformi.s22 + 0)
.s11:
1b23 : a0 06 __ LDY #$06
1b25 : a6 45 __ LDX T7 + 0 
1b27 : b1 0d __ LDA (P0),y ; (si + 0)
1b29 : d0 2b __ BNE $1b56 ; (nformi.s17 + 0)
.l12:
1b2b : 8a __ __ TXA
1b2c : 18 __ __ CLC
1b2d : a0 01 __ LDY #$01
1b2f : 71 0d __ ADC (P0),y ; (si + 0)
1b31 : b0 04 __ BCS $1b37 ; (nformi.s15 + 0)
.s16:
1b33 : c9 11 __ CMP #$11
1b35 : 90 0a __ BCC $1b41 ; (nformi.s13 + 0)
.s15:
1b37 : a0 00 __ LDY #$00
1b39 : b1 0d __ LDA (P0),y ; (si + 0)
1b3b : 9d e5 9f STA $9fe5,x ; (si.prefix + 0)
1b3e : ca __ __ DEX
1b3f : b0 ea __ BCS $1b2b ; (nformi.l12 + 0)
.s13:
1b41 : e0 10 __ CPX #$10
1b43 : b0 0e __ BCS $1b53 ; (nformi.s41 + 0)
.s14:
1b45 : 88 __ __ DEY
.l37:
1b46 : bd e6 9f LDA $9fe6,x ; (buffer[0] + 0)
1b49 : 91 0f __ STA (P2),y ; (str + 0)
1b4b : c8 __ __ INY
1b4c : e8 __ __ INX
1b4d : e0 10 __ CPX #$10
1b4f : 90 f5 __ BCC $1b46 ; (nformi.l37 + 0)
.s38:
1b51 : 84 1b __ STY ACCU + 0 
.s41:
1b53 : a5 1b __ LDA ACCU + 0 
.s3:
1b55 : 60 __ __ RTS
.s17:
1b56 : e0 10 __ CPX #$10
1b58 : b0 1a __ BCS $1b74 ; (nformi.l18 + 0)
.s20:
1b5a : a0 00 __ LDY #$00
.l35:
1b5c : bd e6 9f LDA $9fe6,x ; (buffer[0] + 0)
1b5f : 91 0f __ STA (P2),y ; (str + 0)
1b61 : c8 __ __ INY
1b62 : e8 __ __ INX
1b63 : e0 10 __ CPX #$10
1b65 : 90 f5 __ BCC $1b5c ; (nformi.l35 + 0)
.s36:
1b67 : 84 1b __ STY ACCU + 0 
1b69 : b0 09 __ BCS $1b74 ; (nformi.l18 + 0)
.s19:
1b6b : 88 __ __ DEY
1b6c : b1 0d __ LDA (P0),y ; (si + 0)
1b6e : a4 1b __ LDY ACCU + 0 
1b70 : 91 0f __ STA (P2),y ; (str + 0)
1b72 : e6 1b __ INC ACCU + 0 
.l18:
1b74 : a5 1b __ LDA ACCU + 0 
1b76 : a0 01 __ LDY #$01
1b78 : d1 0d __ CMP (P0),y ; (si + 0)
1b7a : 90 ef __ BCC $1b6b ; (nformi.s19 + 0)
1b7c : 60 __ __ RTS
--------------------------------------------------------------------
nforml: ; nforml(const struct sinfo*,u8*,i32,bool)->u8
; 137, "/usr/local/include/oscar64/stdio.c"
.s4:
1b7d : a9 00 __ LDA #$00
1b7f : 85 43 __ STA T4 + 0 
1b81 : a5 15 __ LDA P8 ; (s + 0)
1b83 : f0 1f __ BEQ $1ba4 ; (nforml.s5 + 0)
.s35:
1b85 : 24 14 __ BIT P7 ; (v + 3)
1b87 : 10 1b __ BPL $1ba4 ; (nforml.s5 + 0)
.s36:
1b89 : 38 __ __ SEC
1b8a : a9 00 __ LDA #$00
1b8c : e5 11 __ SBC P4 ; (v + 0)
1b8e : 85 11 __ STA P4 ; (v + 0)
1b90 : a9 00 __ LDA #$00
1b92 : e5 12 __ SBC P5 ; (v + 1)
1b94 : 85 12 __ STA P5 ; (v + 1)
1b96 : a9 00 __ LDA #$00
1b98 : e5 13 __ SBC P6 ; (v + 2)
1b9a : 85 13 __ STA P6 ; (v + 2)
1b9c : a9 00 __ LDA #$00
1b9e : e5 14 __ SBC P7 ; (v + 3)
1ba0 : 85 14 __ STA P7 ; (v + 3)
1ba2 : e6 43 __ INC T4 + 0 
.s5:
1ba4 : a9 10 __ LDA #$10
1ba6 : 85 44 __ STA T5 + 0 
1ba8 : a5 14 __ LDA P7 ; (v + 3)
1baa : f0 03 __ BEQ $1baf ; (nforml.s31 + 0)
1bac : 4c 77 1c JMP $1c77 ; (nforml.l28 + 0)
.s31:
1baf : a5 13 __ LDA P6 ; (v + 2)
1bb1 : d0 f9 __ BNE $1bac ; (nforml.s5 + 8)
.s32:
1bb3 : a5 12 __ LDA P5 ; (v + 1)
1bb5 : d0 f5 __ BNE $1bac ; (nforml.s5 + 8)
.s33:
1bb7 : c5 11 __ CMP P4 ; (v + 0)
1bb9 : 90 f1 __ BCC $1bac ; (nforml.s5 + 8)
.s6:
1bbb : a0 02 __ LDY #$02
1bbd : b1 0d __ LDA (P0),y ; (si + 0)
1bbf : c9 ff __ CMP #$ff
1bc1 : d0 04 __ BNE $1bc7 ; (nforml.s27 + 0)
.s7:
1bc3 : a9 0f __ LDA #$0f
1bc5 : d0 05 __ BNE $1bcc ; (nforml.s41 + 0)
.s27:
1bc7 : 38 __ __ SEC
1bc8 : a9 10 __ LDA #$10
1bca : f1 0d __ SBC (P0),y ; (si + 0)
.s41:
1bcc : a8 __ __ TAY
1bcd : c4 44 __ CPY T5 + 0 
1bcf : b0 0d __ BCS $1bde ; (nforml.s8 + 0)
.s26:
1bd1 : a9 30 __ LDA #$30
.l42:
1bd3 : a6 44 __ LDX T5 + 0 
1bd5 : 9d e5 9f STA $9fe5,x ; (si.prefix + 0)
1bd8 : c6 44 __ DEC T5 + 0 
1bda : c4 44 __ CPY T5 + 0 
1bdc : 90 f5 __ BCC $1bd3 ; (nforml.l42 + 0)
.s8:
1bde : a0 07 __ LDY #$07
1be0 : b1 0d __ LDA (P0),y ; (si + 0)
1be2 : f0 1d __ BEQ $1c01 ; (nforml.s9 + 0)
.s24:
1be4 : a0 04 __ LDY #$04
1be6 : b1 0d __ LDA (P0),y ; (si + 0)
1be8 : c9 10 __ CMP #$10
1bea : d0 15 __ BNE $1c01 ; (nforml.s9 + 0)
.s25:
1bec : 88 __ __ DEY
1bed : b1 0d __ LDA (P0),y ; (si + 0)
1bef : a8 __ __ TAY
1bf0 : a9 30 __ LDA #$30
1bf2 : a6 44 __ LDX T5 + 0 
1bf4 : ca __ __ DEX
1bf5 : ca __ __ DEX
1bf6 : 86 44 __ STX T5 + 0 
1bf8 : 9d e6 9f STA $9fe6,x ; (buffer[0] + 0)
1bfb : 98 __ __ TYA
1bfc : 69 16 __ ADC #$16
1bfe : 9d e7 9f STA $9fe7,x ; (buffer[0] + 1)
.s9:
1c01 : a9 00 __ LDA #$00
1c03 : 85 1b __ STA ACCU + 0 
1c05 : a5 43 __ LDA T4 + 0 
1c07 : f0 0c __ BEQ $1c15 ; (nforml.s10 + 0)
.s23:
1c09 : a9 2d __ LDA #$2d
.s22:
1c0b : a6 44 __ LDX T5 + 0 
1c0d : 9d e5 9f STA $9fe5,x ; (si.prefix + 0)
1c10 : c6 44 __ DEC T5 + 0 
1c12 : 4c 1f 1c JMP $1c1f ; (nforml.s11 + 0)
.s10:
1c15 : a0 05 __ LDY #$05
1c17 : b1 0d __ LDA (P0),y ; (si + 0)
1c19 : f0 04 __ BEQ $1c1f ; (nforml.s11 + 0)
.s21:
1c1b : a9 2b __ LDA #$2b
1c1d : d0 ec __ BNE $1c0b ; (nforml.s22 + 0)
.s11:
1c1f : a6 44 __ LDX T5 + 0 
1c21 : a0 06 __ LDY #$06
1c23 : b1 0d __ LDA (P0),y ; (si + 0)
1c25 : d0 29 __ BNE $1c50 ; (nforml.s17 + 0)
.l12:
1c27 : 8a __ __ TXA
1c28 : 18 __ __ CLC
1c29 : a0 01 __ LDY #$01
1c2b : 71 0d __ ADC (P0),y ; (si + 0)
1c2d : b0 04 __ BCS $1c33 ; (nforml.s15 + 0)
.s16:
1c2f : c9 11 __ CMP #$11
1c31 : 90 0a __ BCC $1c3d ; (nforml.s13 + 0)
.s15:
1c33 : a0 00 __ LDY #$00
1c35 : b1 0d __ LDA (P0),y ; (si + 0)
1c37 : 9d e5 9f STA $9fe5,x ; (si.prefix + 0)
1c3a : ca __ __ DEX
1c3b : b0 ea __ BCS $1c27 ; (nforml.l12 + 0)
.s13:
1c3d : e0 10 __ CPX #$10
1c3f : b0 0e __ BCS $1c4f ; (nforml.s3 + 0)
.s14:
1c41 : 88 __ __ DEY
.l39:
1c42 : bd e6 9f LDA $9fe6,x ; (buffer[0] + 0)
1c45 : 91 0f __ STA (P2),y ; (str + 0)
1c47 : c8 __ __ INY
1c48 : e8 __ __ INX
1c49 : e0 10 __ CPX #$10
1c4b : 90 f5 __ BCC $1c42 ; (nforml.l39 + 0)
.s40:
1c4d : 84 1b __ STY ACCU + 0 
.s3:
1c4f : 60 __ __ RTS
.s17:
1c50 : e0 10 __ CPX #$10
1c52 : b0 1a __ BCS $1c6e ; (nforml.l18 + 0)
.s20:
1c54 : a0 00 __ LDY #$00
.l37:
1c56 : bd e6 9f LDA $9fe6,x ; (buffer[0] + 0)
1c59 : 91 0f __ STA (P2),y ; (str + 0)
1c5b : c8 __ __ INY
1c5c : e8 __ __ INX
1c5d : e0 10 __ CPX #$10
1c5f : 90 f5 __ BCC $1c56 ; (nforml.l37 + 0)
.s38:
1c61 : 84 1b __ STY ACCU + 0 
1c63 : b0 09 __ BCS $1c6e ; (nforml.l18 + 0)
.s19:
1c65 : 88 __ __ DEY
1c66 : b1 0d __ LDA (P0),y ; (si + 0)
1c68 : a4 1b __ LDY ACCU + 0 
1c6a : 91 0f __ STA (P2),y ; (str + 0)
1c6c : e6 1b __ INC ACCU + 0 
.l18:
1c6e : a5 1b __ LDA ACCU + 0 
1c70 : a0 01 __ LDY #$01
1c72 : d1 0d __ CMP (P0),y ; (si + 0)
1c74 : 90 ef __ BCC $1c65 ; (nforml.s19 + 0)
1c76 : 60 __ __ RTS
.l28:
1c77 : a0 04 __ LDY #$04
1c79 : b1 0d __ LDA (P0),y ; (si + 0)
1c7b : 85 03 __ STA WORK + 0 
1c7d : a5 11 __ LDA P4 ; (v + 0)
1c7f : 85 1b __ STA ACCU + 0 
1c81 : a5 12 __ LDA P5 ; (v + 1)
1c83 : 85 1c __ STA ACCU + 1 
1c85 : a5 13 __ LDA P6 ; (v + 2)
1c87 : 85 1d __ STA ACCU + 2 
1c89 : a5 14 __ LDA P7 ; (v + 3)
1c8b : 85 1e __ STA ACCU + 3 
1c8d : a9 00 __ LDA #$00
1c8f : 85 04 __ STA WORK + 1 
1c91 : 85 05 __ STA WORK + 2 
1c93 : 85 06 __ STA WORK + 3 
1c95 : 20 54 2c JSR $2c54 ; (divmod32 + 0)
1c98 : a5 07 __ LDA WORK + 4 
1c9a : c9 0a __ CMP #$0a
1c9c : b0 04 __ BCS $1ca2 ; (nforml.s34 + 0)
.s29:
1c9e : a9 30 __ LDA #$30
1ca0 : 90 06 __ BCC $1ca8 ; (nforml.s30 + 0)
.s34:
1ca2 : a0 03 __ LDY #$03
1ca4 : b1 0d __ LDA (P0),y ; (si + 0)
1ca6 : e9 0a __ SBC #$0a
.s30:
1ca8 : 18 __ __ CLC
1ca9 : 65 07 __ ADC WORK + 4 
1cab : a6 44 __ LDX T5 + 0 
1cad : 9d e5 9f STA $9fe5,x ; (si.prefix + 0)
1cb0 : c6 44 __ DEC T5 + 0 
1cb2 : a5 1b __ LDA ACCU + 0 
1cb4 : 85 11 __ STA P4 ; (v + 0)
1cb6 : a5 1c __ LDA ACCU + 1 
1cb8 : 85 12 __ STA P5 ; (v + 1)
1cba : a5 1d __ LDA ACCU + 2 
1cbc : 85 13 __ STA P6 ; (v + 2)
1cbe : a5 1e __ LDA ACCU + 3 
1cc0 : 85 14 __ STA P7 ; (v + 3)
1cc2 : d0 b3 __ BNE $1c77 ; (nforml.l28 + 0)
1cc4 : 4c af 1b JMP $1baf ; (nforml.s31 + 0)
--------------------------------------------------------------------
nformf: ; nformf(const struct sinfo*,u8*,float,u8)->u8
; 199, "/usr/local/include/oscar64/stdio.c"
.s1:
1cc7 : a5 53 __ LDA T10 + 0 
1cc9 : 8d ed 9f STA $9fed ; (nformf@stack + 0)
1ccc : a5 54 __ LDA T11 + 0 
1cce : 8d ee 9f STA $9fee ; (nformf@stack + 1)
.s4:
1cd1 : a5 11 __ LDA P4 ; (f + 0)
1cd3 : 85 43 __ STA T0 + 0 
1cd5 : a5 12 __ LDA P5 ; (f + 1)
1cd7 : 85 44 __ STA T0 + 1 
1cd9 : a5 14 __ LDA P7 ; (f + 3)
1cdb : 29 7f __ AND #$7f
1cdd : 05 13 __ ORA P6 ; (f + 2)
1cdf : 05 12 __ ORA P5 ; (f + 1)
1ce1 : a6 13 __ LDX P6 ; (f + 2)
1ce3 : 86 45 __ STX T0 + 2 
1ce5 : 05 11 __ ORA P4 ; (f + 0)
1ce7 : f0 14 __ BEQ $1cfd ; (nformf.s5 + 0)
.s105:
1ce9 : 24 14 __ BIT P7 ; (f + 3)
1ceb : 10 10 __ BPL $1cfd ; (nformf.s5 + 0)
.s104:
1ced : a9 2d __ LDA #$2d
1cef : a0 00 __ LDY #$00
1cf1 : 91 0f __ STA (P2),y ; (str + 0)
1cf3 : a5 14 __ LDA P7 ; (f + 3)
1cf5 : 49 80 __ EOR #$80
1cf7 : 85 14 __ STA P7 ; (f + 3)
.s103:
1cf9 : a9 01 __ LDA #$01
1cfb : d0 0e __ BNE $1d0b ; (nformf.s6 + 0)
.s5:
1cfd : a0 05 __ LDY #$05
1cff : b1 0d __ LDA (P0),y ; (si + 0)
1d01 : f0 08 __ BEQ $1d0b ; (nformf.s6 + 0)
.s102:
1d03 : a9 2b __ LDA #$2b
1d05 : a0 00 __ LDY #$00
1d07 : 91 0f __ STA (P2),y ; (str + 0)
1d09 : a9 01 __ LDA #$01
.s6:
1d0b : 85 52 __ STA T9 + 0 
1d0d : 8a __ __ TXA
1d0e : 0a __ __ ASL
1d0f : a5 14 __ LDA P7 ; (f + 3)
1d11 : 2a __ __ ROL
1d12 : c9 ff __ CMP #$ff
1d14 : d0 29 __ BNE $1d3f ; (nformf.s7 + 0)
.s101:
1d16 : a0 03 __ LDY #$03
1d18 : b1 0d __ LDA (P0),y ; (si + 0)
1d1a : 69 07 __ ADC #$07
1d1c : a4 52 __ LDY T9 + 0 
1d1e : 91 0f __ STA (P2),y ; (str + 0)
1d20 : 18 __ __ CLC
1d21 : a0 03 __ LDY #$03
1d23 : b1 0d __ LDA (P0),y ; (si + 0)
1d25 : 69 0d __ ADC #$0d
1d27 : a4 52 __ LDY T9 + 0 
1d29 : c8 __ __ INY
1d2a : 91 0f __ STA (P2),y ; (str + 0)
1d2c : 18 __ __ CLC
1d2d : a0 03 __ LDY #$03
1d2f : b1 0d __ LDA (P0),y ; (si + 0)
1d31 : 69 05 __ ADC #$05
1d33 : a4 52 __ LDY T9 + 0 
1d35 : c8 __ __ INY
1d36 : c8 __ __ INY
1d37 : 91 0f __ STA (P2),y ; (str + 0)
1d39 : c8 __ __ INY
1d3a : 84 52 __ STY T9 + 0 
1d3c : 4c 8d 20 JMP $208d ; (nformf.s27 + 0)
.s7:
1d3f : a0 02 __ LDY #$02
1d41 : b1 0d __ LDA (P0),y ; (si + 0)
1d43 : a6 14 __ LDX P7 ; (f + 3)
1d45 : 86 46 __ STX T0 + 3 
1d47 : c9 ff __ CMP #$ff
1d49 : d0 02 __ BNE $1d4d ; (nformf.s100 + 0)
.s8:
1d4b : a9 06 __ LDA #$06
.s100:
1d4d : 85 4b __ STA T4 + 0 
1d4f : 85 50 __ STA T7 + 0 
1d51 : a9 00 __ LDA #$00
1d53 : 85 4d __ STA T5 + 0 
1d55 : 85 4e __ STA T5 + 1 
1d57 : 8a __ __ TXA
1d58 : 29 7f __ AND #$7f
1d5a : 05 13 __ ORA P6 ; (f + 2)
1d5c : 05 12 __ ORA P5 ; (f + 1)
1d5e : 05 11 __ ORA P4 ; (f + 0)
1d60 : d0 03 __ BNE $1d65 ; (nformf.s67 + 0)
1d62 : 4c 91 1e JMP $1e91 ; (nformf.s9 + 0)
.s67:
1d65 : 8a __ __ TXA
1d66 : 10 03 __ BPL $1d6b ; (nformf.s95 + 0)
1d68 : 4c eb 1d JMP $1deb ; (nformf.l80 + 0)
.s95:
1d6b : c9 44 __ CMP #$44
1d6d : d0 0e __ BNE $1d7d ; (nformf.l99 + 0)
.s96:
1d6f : a5 13 __ LDA P6 ; (f + 2)
1d71 : c9 7a __ CMP #$7a
1d73 : d0 08 __ BNE $1d7d ; (nformf.l99 + 0)
.s97:
1d75 : a5 12 __ LDA P5 ; (f + 1)
1d77 : d0 04 __ BNE $1d7d ; (nformf.l99 + 0)
.s98:
1d79 : a5 11 __ LDA P4 ; (f + 0)
1d7b : f0 02 __ BEQ $1d7f ; (nformf.l90 + 0)
.l99:
1d7d : 90 54 __ BCC $1dd3 ; (nformf.s68 + 0)
.l90:
1d7f : 18 __ __ CLC
1d80 : a5 4d __ LDA T5 + 0 
1d82 : 69 03 __ ADC #$03
1d84 : 85 4d __ STA T5 + 0 
1d86 : 90 02 __ BCC $1d8a ; (nformf.s119 + 0)
.s118:
1d88 : e6 4e __ INC T5 + 1 
.s119:
1d8a : a5 43 __ LDA T0 + 0 
1d8c : 85 1b __ STA ACCU + 0 
1d8e : a5 44 __ LDA T0 + 1 
1d90 : 85 1c __ STA ACCU + 1 
1d92 : a5 45 __ LDA T0 + 2 
1d94 : 85 1d __ STA ACCU + 2 
1d96 : a5 46 __ LDA T0 + 3 
1d98 : 85 1e __ STA ACCU + 3 
1d9a : a9 00 __ LDA #$00
1d9c : 85 03 __ STA WORK + 0 
1d9e : 85 04 __ STA WORK + 1 
1da0 : a9 7a __ LDA #$7a
1da2 : 85 05 __ STA WORK + 2 
1da4 : a9 44 __ LDA #$44
1da6 : 85 06 __ STA WORK + 3 
1da8 : 20 fc 27 JSR $27fc ; (freg + 20)
1dab : 20 e2 29 JSR $29e2 ; (crt_fdiv + 0)
1dae : a5 1b __ LDA ACCU + 0 
1db0 : 85 43 __ STA T0 + 0 
1db2 : a5 1c __ LDA ACCU + 1 
1db4 : 85 44 __ STA T0 + 1 
1db6 : a6 1d __ LDX ACCU + 2 
1db8 : 86 45 __ STX T0 + 2 
1dba : a5 1e __ LDA ACCU + 3 
1dbc : 85 46 __ STA T0 + 3 
1dbe : 30 13 __ BMI $1dd3 ; (nformf.s68 + 0)
.s91:
1dc0 : c9 44 __ CMP #$44
1dc2 : d0 b9 __ BNE $1d7d ; (nformf.l99 + 0)
.s92:
1dc4 : e0 7a __ CPX #$7a
1dc6 : d0 b5 __ BNE $1d7d ; (nformf.l99 + 0)
.s93:
1dc8 : a5 1c __ LDA ACCU + 1 
1dca : 38 __ __ SEC
1dcb : d0 b0 __ BNE $1d7d ; (nformf.l99 + 0)
.s94:
1dcd : a5 1b __ LDA ACCU + 0 
1dcf : f0 ae __ BEQ $1d7f ; (nformf.l90 + 0)
1dd1 : d0 aa __ BNE $1d7d ; (nformf.l99 + 0)
.s68:
1dd3 : a5 46 __ LDA T0 + 3 
1dd5 : 30 14 __ BMI $1deb ; (nformf.l80 + 0)
.s86:
1dd7 : c9 3f __ CMP #$3f
1dd9 : d0 0e __ BNE $1de9 ; (nformf.s85 + 0)
.s87:
1ddb : a5 45 __ LDA T0 + 2 
1ddd : c9 80 __ CMP #$80
1ddf : d0 08 __ BNE $1de9 ; (nformf.s85 + 0)
.s88:
1de1 : a5 44 __ LDA T0 + 1 
1de3 : d0 04 __ BNE $1de9 ; (nformf.s85 + 0)
.s89:
1de5 : a5 43 __ LDA T0 + 0 
1de7 : f0 49 __ BEQ $1e32 ; (nformf.s69 + 0)
.s85:
1de9 : b0 47 __ BCS $1e32 ; (nformf.s69 + 0)
.l80:
1deb : 38 __ __ SEC
1dec : a5 4d __ LDA T5 + 0 
1dee : e9 03 __ SBC #$03
1df0 : 85 4d __ STA T5 + 0 
1df2 : b0 02 __ BCS $1df6 ; (nformf.s114 + 0)
.s113:
1df4 : c6 4e __ DEC T5 + 1 
.s114:
1df6 : a9 00 __ LDA #$00
1df8 : 85 1b __ STA ACCU + 0 
1dfa : 85 1c __ STA ACCU + 1 
1dfc : a9 7a __ LDA #$7a
1dfe : 85 1d __ STA ACCU + 2 
1e00 : a9 44 __ LDA #$44
1e02 : 85 1e __ STA ACCU + 3 
1e04 : a2 43 __ LDX #$43
1e06 : 20 ec 27 JSR $27ec ; (freg + 4)
1e09 : 20 1a 29 JSR $291a ; (crt_fmul + 0)
1e0c : a5 1b __ LDA ACCU + 0 
1e0e : 85 43 __ STA T0 + 0 
1e10 : a5 1c __ LDA ACCU + 1 
1e12 : 85 44 __ STA T0 + 1 
1e14 : a6 1d __ LDX ACCU + 2 
1e16 : 86 45 __ STX T0 + 2 
1e18 : a5 1e __ LDA ACCU + 3 
1e1a : 85 46 __ STA T0 + 3 
1e1c : 30 cd __ BMI $1deb ; (nformf.l80 + 0)
.s81:
1e1e : c9 3f __ CMP #$3f
1e20 : 90 c9 __ BCC $1deb ; (nformf.l80 + 0)
.s120:
1e22 : d0 0e __ BNE $1e32 ; (nformf.s69 + 0)
.s82:
1e24 : e0 80 __ CPX #$80
1e26 : 90 c3 __ BCC $1deb ; (nformf.l80 + 0)
.s121:
1e28 : d0 08 __ BNE $1e32 ; (nformf.s69 + 0)
.s83:
1e2a : a5 1c __ LDA ACCU + 1 
1e2c : d0 bb __ BNE $1de9 ; (nformf.s85 + 0)
.s84:
1e2e : a5 1b __ LDA ACCU + 0 
1e30 : d0 b7 __ BNE $1de9 ; (nformf.s85 + 0)
.s69:
1e32 : a5 46 __ LDA T0 + 3 
1e34 : 30 5b __ BMI $1e91 ; (nformf.s9 + 0)
.s75:
1e36 : c9 41 __ CMP #$41
1e38 : d0 0e __ BNE $1e48 ; (nformf.l79 + 0)
.s76:
1e3a : a5 45 __ LDA T0 + 2 
1e3c : c9 20 __ CMP #$20
1e3e : d0 08 __ BNE $1e48 ; (nformf.l79 + 0)
.s77:
1e40 : a5 44 __ LDA T0 + 1 
1e42 : d0 04 __ BNE $1e48 ; (nformf.l79 + 0)
.s78:
1e44 : a5 43 __ LDA T0 + 0 
1e46 : f0 02 __ BEQ $1e4a ; (nformf.l70 + 0)
.l79:
1e48 : 90 47 __ BCC $1e91 ; (nformf.s9 + 0)
.l70:
1e4a : e6 4d __ INC T5 + 0 
1e4c : d0 02 __ BNE $1e50 ; (nformf.s117 + 0)
.s116:
1e4e : e6 4e __ INC T5 + 1 
.s117:
1e50 : a5 43 __ LDA T0 + 0 
1e52 : 85 1b __ STA ACCU + 0 
1e54 : a5 44 __ LDA T0 + 1 
1e56 : 85 1c __ STA ACCU + 1 
1e58 : a5 45 __ LDA T0 + 2 
1e5a : 85 1d __ STA ACCU + 2 
1e5c : a5 46 __ LDA T0 + 3 
1e5e : 85 1e __ STA ACCU + 3 
1e60 : a9 00 __ LDA #$00
1e62 : 85 03 __ STA WORK + 0 
1e64 : 85 04 __ STA WORK + 1 
1e66 : 20 9a 2e JSR $2e9a ; (freg@proxy + 0)
1e69 : 20 e2 29 JSR $29e2 ; (crt_fdiv + 0)
1e6c : a5 1b __ LDA ACCU + 0 
1e6e : 85 43 __ STA T0 + 0 
1e70 : a5 1c __ LDA ACCU + 1 
1e72 : 85 44 __ STA T0 + 1 
1e74 : a6 1d __ LDX ACCU + 2 
1e76 : 86 45 __ STX T0 + 2 
1e78 : a5 1e __ LDA ACCU + 3 
1e7a : 85 46 __ STA T0 + 3 
1e7c : 30 13 __ BMI $1e91 ; (nformf.s9 + 0)
.s71:
1e7e : c9 41 __ CMP #$41
1e80 : d0 c6 __ BNE $1e48 ; (nformf.l79 + 0)
.s72:
1e82 : e0 20 __ CPX #$20
1e84 : d0 c2 __ BNE $1e48 ; (nformf.l79 + 0)
.s73:
1e86 : a5 1c __ LDA ACCU + 1 
1e88 : 38 __ __ SEC
1e89 : d0 bd __ BNE $1e48 ; (nformf.l79 + 0)
.s74:
1e8b : a5 1b __ LDA ACCU + 0 
1e8d : f0 bb __ BEQ $1e4a ; (nformf.l70 + 0)
1e8f : d0 b7 __ BNE $1e48 ; (nformf.l79 + 0)
.s9:
1e91 : a5 15 __ LDA P8 ; (type + 0)
1e93 : c9 65 __ CMP #$65
1e95 : d0 04 __ BNE $1e9b ; (nformf.s11 + 0)
.s10:
1e97 : a9 01 __ LDA #$01
1e99 : d0 02 __ BNE $1e9d ; (nformf.s12 + 0)
.s11:
1e9b : a9 00 __ LDA #$00
.s12:
1e9d : 85 53 __ STA T10 + 0 
1e9f : a6 4b __ LDX T4 + 0 
1ea1 : e8 __ __ INX
1ea2 : 86 4f __ STX T6 + 0 
1ea4 : a5 15 __ LDA P8 ; (type + 0)
1ea6 : c9 67 __ CMP #$67
1ea8 : d0 13 __ BNE $1ebd ; (nformf.s13 + 0)
.s63:
1eaa : a5 4e __ LDA T5 + 1 
1eac : 30 08 __ BMI $1eb6 ; (nformf.s64 + 0)
.s66:
1eae : d0 06 __ BNE $1eb6 ; (nformf.s64 + 0)
.s65:
1eb0 : a5 4d __ LDA T5 + 0 
1eb2 : c9 04 __ CMP #$04
1eb4 : 90 07 __ BCC $1ebd ; (nformf.s13 + 0)
.s64:
1eb6 : a9 01 __ LDA #$01
1eb8 : 85 53 __ STA T10 + 0 
1eba : 4c 1e 21 JMP $211e ; (nformf.s53 + 0)
.s13:
1ebd : a5 53 __ LDA T10 + 0 
1ebf : d0 f9 __ BNE $1eba ; (nformf.s64 + 4)
.s14:
1ec1 : 24 4e __ BIT T5 + 1 
1ec3 : 10 3b __ BPL $1f00 ; (nformf.s15 + 0)
.s52:
1ec5 : a5 43 __ LDA T0 + 0 
1ec7 : 85 1b __ STA ACCU + 0 
1ec9 : a5 44 __ LDA T0 + 1 
1ecb : 85 1c __ STA ACCU + 1 
1ecd : a5 45 __ LDA T0 + 2 
1ecf : 85 1d __ STA ACCU + 2 
1ed1 : a5 46 __ LDA T0 + 3 
1ed3 : 85 1e __ STA ACCU + 3 
.l106:
1ed5 : a9 00 __ LDA #$00
1ed7 : 85 03 __ STA WORK + 0 
1ed9 : 85 04 __ STA WORK + 1 
1edb : 20 9a 2e JSR $2e9a ; (freg@proxy + 0)
1ede : 20 e2 29 JSR $29e2 ; (crt_fdiv + 0)
1ee1 : 18 __ __ CLC
1ee2 : a5 4d __ LDA T5 + 0 
1ee4 : 69 01 __ ADC #$01
1ee6 : 85 4d __ STA T5 + 0 
1ee8 : a5 4e __ LDA T5 + 1 
1eea : 69 00 __ ADC #$00
1eec : 85 4e __ STA T5 + 1 
1eee : 30 e5 __ BMI $1ed5 ; (nformf.l106 + 0)
.s107:
1ef0 : a5 1e __ LDA ACCU + 3 
1ef2 : 85 46 __ STA T0 + 3 
1ef4 : a5 1d __ LDA ACCU + 2 
1ef6 : 85 45 __ STA T0 + 2 
1ef8 : a5 1c __ LDA ACCU + 1 
1efa : 85 44 __ STA T0 + 1 
1efc : a5 1b __ LDA ACCU + 0 
1efe : 85 43 __ STA T0 + 0 
.s15:
1f00 : 18 __ __ CLC
1f01 : a5 4b __ LDA T4 + 0 
1f03 : 65 4d __ ADC T5 + 0 
1f05 : 18 __ __ CLC
1f06 : 69 01 __ ADC #$01
1f08 : 85 4f __ STA T6 + 0 
1f0a : c9 07 __ CMP #$07
1f0c : 90 14 __ BCC $1f22 ; (nformf.s51 + 0)
.s16:
1f0e : ad 1a 2f LDA $2f1a ; (fround5[0] + 24)
1f11 : 85 47 __ STA T1 + 0 
1f13 : ad 1b 2f LDA $2f1b ; (fround5[0] + 25)
1f16 : 85 48 __ STA T1 + 1 
1f18 : ad 1c 2f LDA $2f1c ; (fround5[0] + 26)
1f1b : 85 49 __ STA T1 + 2 
1f1d : ad 1d 2f LDA $2f1d ; (fround5[0] + 27)
1f20 : b0 15 __ BCS $1f37 ; (nformf.s17 + 0)
.s51:
1f22 : 0a __ __ ASL
1f23 : 0a __ __ ASL
1f24 : aa __ __ TAX
1f25 : bd fe 2e LDA $2efe,x ; (current_page + 0)
1f28 : 85 47 __ STA T1 + 0 
1f2a : bd ff 2e LDA $2eff,x ; (current_page + 1)
1f2d : 85 48 __ STA T1 + 1 
1f2f : bd 00 2f LDA $2f00,x ; (search_query_len + 0)
1f32 : 85 49 __ STA T1 + 2 
1f34 : bd 01 2f LDA $2f01,x ; (search_query_len + 1)
.s17:
1f37 : 85 4a __ STA T1 + 3 
1f39 : a2 47 __ LDX #$47
1f3b : 20 a5 2e JSR $2ea5 ; (freg@proxy + 0)
1f3e : 20 33 28 JSR $2833 ; (faddsub + 6)
1f41 : a5 1c __ LDA ACCU + 1 
1f43 : 85 12 __ STA P5 ; (f + 1)
1f45 : a5 1d __ LDA ACCU + 2 
1f47 : 85 13 __ STA P6 ; (f + 2)
1f49 : a6 1b __ LDX ACCU + 0 
1f4b : a5 1e __ LDA ACCU + 3 
1f4d : 85 14 __ STA P7 ; (f + 3)
1f4f : 30 32 __ BMI $1f83 ; (nformf.s18 + 0)
.s46:
1f51 : c9 41 __ CMP #$41
1f53 : d0 0d __ BNE $1f62 ; (nformf.s50 + 0)
.s47:
1f55 : a5 13 __ LDA P6 ; (f + 2)
1f57 : c9 20 __ CMP #$20
1f59 : d0 07 __ BNE $1f62 ; (nformf.s50 + 0)
.s48:
1f5b : a5 12 __ LDA P5 ; (f + 1)
1f5d : d0 03 __ BNE $1f62 ; (nformf.s50 + 0)
.s49:
1f5f : 8a __ __ TXA
1f60 : f0 02 __ BEQ $1f64 ; (nformf.s45 + 0)
.s50:
1f62 : 90 1f __ BCC $1f83 ; (nformf.s18 + 0)
.s45:
1f64 : a9 00 __ LDA #$00
1f66 : 85 03 __ STA WORK + 0 
1f68 : 85 04 __ STA WORK + 1 
1f6a : 20 9a 2e JSR $2e9a ; (freg@proxy + 0)
1f6d : 20 e2 29 JSR $29e2 ; (crt_fdiv + 0)
1f70 : a5 1c __ LDA ACCU + 1 
1f72 : 85 12 __ STA P5 ; (f + 1)
1f74 : a5 1d __ LDA ACCU + 2 
1f76 : 85 13 __ STA P6 ; (f + 2)
1f78 : a5 1e __ LDA ACCU + 3 
1f7a : 85 14 __ STA P7 ; (f + 3)
1f7c : a6 4b __ LDX T4 + 0 
1f7e : ca __ __ DEX
1f7f : 86 50 __ STX T7 + 0 
1f81 : a6 1b __ LDX ACCU + 0 
.s18:
1f83 : 38 __ __ SEC
1f84 : a5 4f __ LDA T6 + 0 
1f86 : e5 50 __ SBC T7 + 0 
1f88 : 85 4b __ STA T4 + 0 
1f8a : a9 00 __ LDA #$00
1f8c : e9 00 __ SBC #$00
1f8e : 85 4c __ STA T4 + 1 
1f90 : a9 14 __ LDA #$14
1f92 : c5 4f __ CMP T6 + 0 
1f94 : b0 02 __ BCS $1f98 ; (nformf.s19 + 0)
.s44:
1f96 : 85 4f __ STA T6 + 0 
.s19:
1f98 : a5 4b __ LDA T4 + 0 
1f9a : d0 08 __ BNE $1fa4 ; (nformf.s21 + 0)
.s20:
1f9c : a9 30 __ LDA #$30
1f9e : a4 52 __ LDY T9 + 0 
1fa0 : 91 0f __ STA (P2),y ; (str + 0)
1fa2 : e6 52 __ INC T9 + 0 
.s21:
1fa4 : a9 00 __ LDA #$00
1fa6 : 85 54 __ STA T11 + 0 
1fa8 : c5 4b __ CMP T4 + 0 
1faa : f0 67 __ BEQ $2013 ; (nformf.l43 + 0)
.s23:
1fac : c9 07 __ CMP #$07
1fae : 90 04 __ BCC $1fb4 ; (nformf.s24 + 0)
.l42:
1fb0 : a9 30 __ LDA #$30
1fb2 : b0 4d __ BCS $2001 ; (nformf.l25 + 0)
.s24:
1fb4 : 86 1b __ STX ACCU + 0 
1fb6 : 86 43 __ STX T0 + 0 
1fb8 : a5 12 __ LDA P5 ; (f + 1)
1fba : 85 1c __ STA ACCU + 1 
1fbc : 85 44 __ STA T0 + 1 
1fbe : a5 13 __ LDA P6 ; (f + 2)
1fc0 : 85 1d __ STA ACCU + 2 
1fc2 : 85 45 __ STA T0 + 2 
1fc4 : a5 14 __ LDA P7 ; (f + 3)
1fc6 : 85 1e __ STA ACCU + 3 
1fc8 : 85 46 __ STA T0 + 3 
1fca : 20 a3 2b JSR $2ba3 ; (f32_to_i16 + 0)
1fcd : a5 1b __ LDA ACCU + 0 
1fcf : 85 51 __ STA T8 + 0 
1fd1 : 20 ef 2b JSR $2bef ; (sint16_to_float + 0)
1fd4 : a2 43 __ LDX #$43
1fd6 : 20 ec 27 JSR $27ec ; (freg + 4)
1fd9 : a5 1e __ LDA ACCU + 3 
1fdb : 49 80 __ EOR #$80
1fdd : 85 1e __ STA ACCU + 3 
1fdf : 20 33 28 JSR $2833 ; (faddsub + 6)
1fe2 : a9 00 __ LDA #$00
1fe4 : 85 03 __ STA WORK + 0 
1fe6 : 85 04 __ STA WORK + 1 
1fe8 : 20 9a 2e JSR $2e9a ; (freg@proxy + 0)
1feb : 20 1a 29 JSR $291a ; (crt_fmul + 0)
1fee : a5 1c __ LDA ACCU + 1 
1ff0 : 85 12 __ STA P5 ; (f + 1)
1ff2 : a5 1d __ LDA ACCU + 2 
1ff4 : 85 13 __ STA P6 ; (f + 2)
1ff6 : a5 1e __ LDA ACCU + 3 
1ff8 : 85 14 __ STA P7 ; (f + 3)
1ffa : 18 __ __ CLC
1ffb : a5 51 __ LDA T8 + 0 
1ffd : 69 30 __ ADC #$30
1fff : a6 1b __ LDX ACCU + 0 
.l25:
2001 : a4 52 __ LDY T9 + 0 
2003 : 91 0f __ STA (P2),y ; (str + 0)
2005 : e6 52 __ INC T9 + 0 
2007 : e6 54 __ INC T11 + 0 
2009 : a5 54 __ LDA T11 + 0 
200b : c5 4f __ CMP T6 + 0 
200d : b0 14 __ BCS $2023 ; (nformf.s26 + 0)
.s22:
200f : c5 4b __ CMP T4 + 0 
2011 : d0 99 __ BNE $1fac ; (nformf.s23 + 0)
.l43:
2013 : a9 2e __ LDA #$2e
2015 : a4 52 __ LDY T9 + 0 
2017 : 91 0f __ STA (P2),y ; (str + 0)
2019 : e6 52 __ INC T9 + 0 
201b : a5 54 __ LDA T11 + 0 
201d : c9 07 __ CMP #$07
201f : 90 93 __ BCC $1fb4 ; (nformf.s24 + 0)
2021 : b0 8d __ BCS $1fb0 ; (nformf.l42 + 0)
.s26:
2023 : a5 53 __ LDA T10 + 0 
2025 : f0 66 __ BEQ $208d ; (nformf.s27 + 0)
.s38:
2027 : a0 03 __ LDY #$03
2029 : b1 0d __ LDA (P0),y ; (si + 0)
202b : 69 03 __ ADC #$03
202d : a4 52 __ LDY T9 + 0 
202f : 91 0f __ STA (P2),y ; (str + 0)
2031 : c8 __ __ INY
2032 : 84 52 __ STY T9 + 0 
2034 : 24 4e __ BIT T5 + 1 
2036 : 30 06 __ BMI $203e ; (nformf.s41 + 0)
.s39:
2038 : a9 2b __ LDA #$2b
203a : 91 0f __ STA (P2),y ; (str + 0)
203c : d0 11 __ BNE $204f ; (nformf.s40 + 0)
.s41:
203e : a9 2d __ LDA #$2d
2040 : 91 0f __ STA (P2),y ; (str + 0)
2042 : 38 __ __ SEC
2043 : a9 00 __ LDA #$00
2045 : e5 4d __ SBC T5 + 0 
2047 : 85 4d __ STA T5 + 0 
2049 : a9 00 __ LDA #$00
204b : e5 4e __ SBC T5 + 1 
204d : 85 4e __ STA T5 + 1 
.s40:
204f : e6 52 __ INC T9 + 0 
2051 : a5 4d __ LDA T5 + 0 
2053 : 85 1b __ STA ACCU + 0 
2055 : a5 4e __ LDA T5 + 1 
2057 : 85 1c __ STA ACCU + 1 
2059 : a9 0a __ LDA #$0a
205b : 85 03 __ STA WORK + 0 
205d : a9 00 __ LDA #$00
205f : 85 04 __ STA WORK + 1 
2061 : 20 90 2a JSR $2a90 ; (divs16 + 0)
2064 : 18 __ __ CLC
2065 : a5 1b __ LDA ACCU + 0 
2067 : 69 30 __ ADC #$30
2069 : a4 52 __ LDY T9 + 0 
206b : 91 0f __ STA (P2),y ; (str + 0)
206d : e6 52 __ INC T9 + 0 
206f : a5 4d __ LDA T5 + 0 
2071 : 85 1b __ STA ACCU + 0 
2073 : a5 4e __ LDA T5 + 1 
2075 : 85 1c __ STA ACCU + 1 
2077 : a9 0a __ LDA #$0a
2079 : 85 03 __ STA WORK + 0 
207b : a9 00 __ LDA #$00
207d : 85 04 __ STA WORK + 1 
207f : 20 4c 2b JSR $2b4c ; (mods16 + 0)
2082 : 18 __ __ CLC
2083 : a5 05 __ LDA WORK + 2 
2085 : 69 30 __ ADC #$30
2087 : a4 52 __ LDY T9 + 0 
2089 : 91 0f __ STA (P2),y ; (str + 0)
208b : e6 52 __ INC T9 + 0 
.s27:
208d : a5 52 __ LDA T9 + 0 
208f : a0 01 __ LDY #$01
2091 : d1 0d __ CMP (P0),y ; (si + 0)
2093 : b0 6d __ BCS $2102 ; (nformf.s3 + 0)
.s28:
2095 : a0 06 __ LDY #$06
2097 : b1 0d __ LDA (P0),y ; (si + 0)
2099 : f0 04 __ BEQ $209f ; (nformf.s29 + 0)
.s108:
209b : a6 52 __ LDX T9 + 0 
209d : 90 70 __ BCC $210f ; (nformf.l36 + 0)
.s29:
209f : a5 52 __ LDA T9 + 0 
20a1 : f0 40 __ BEQ $20e3 ; (nformf.s30 + 0)
.s35:
20a3 : e9 00 __ SBC #$00
20a5 : a8 __ __ TAY
20a6 : a9 00 __ LDA #$00
20a8 : e9 00 __ SBC #$00
20aa : aa __ __ TAX
20ab : 98 __ __ TYA
20ac : 18 __ __ CLC
20ad : 65 0f __ ADC P2 ; (str + 0)
20af : 85 43 __ STA T0 + 0 
20b1 : 8a __ __ TXA
20b2 : 65 10 __ ADC P3 ; (str + 1)
20b4 : 85 44 __ STA T0 + 1 
20b6 : a9 01 __ LDA #$01
20b8 : 85 4b __ STA T4 + 0 
20ba : a6 52 __ LDX T9 + 0 
20bc : 38 __ __ SEC
.l109:
20bd : a0 01 __ LDY #$01
20bf : b1 0d __ LDA (P0),y ; (si + 0)
20c1 : e5 4b __ SBC T4 + 0 
20c3 : 85 47 __ STA T1 + 0 
20c5 : a9 00 __ LDA #$00
20c7 : e5 4c __ SBC T4 + 1 
20c9 : 18 __ __ CLC
20ca : 65 10 __ ADC P3 ; (str + 1)
20cc : 85 48 __ STA T1 + 1 
20ce : 88 __ __ DEY
20cf : b1 43 __ LDA (T0 + 0),y 
20d1 : a4 0f __ LDY P2 ; (str + 0)
20d3 : 91 47 __ STA (T1 + 0),y 
20d5 : a5 43 __ LDA T0 + 0 
20d7 : d0 02 __ BNE $20db ; (nformf.s112 + 0)
.s111:
20d9 : c6 44 __ DEC T0 + 1 
.s112:
20db : c6 43 __ DEC T0 + 0 
20dd : e6 4b __ INC T4 + 0 
20df : e4 4b __ CPX T4 + 0 
20e1 : b0 da __ BCS $20bd ; (nformf.l109 + 0)
.s30:
20e3 : a9 00 __ LDA #$00
20e5 : 85 4b __ STA T4 + 0 
20e7 : 90 08 __ BCC $20f1 ; (nformf.l31 + 0)
.s33:
20e9 : a9 20 __ LDA #$20
20eb : a4 4b __ LDY T4 + 0 
20ed : 91 0f __ STA (P2),y ; (str + 0)
20ef : e6 4b __ INC T4 + 0 
.l31:
20f1 : a0 01 __ LDY #$01
20f3 : b1 0d __ LDA (P0),y ; (si + 0)
20f5 : 38 __ __ SEC
20f6 : e5 52 __ SBC T9 + 0 
20f8 : 90 ef __ BCC $20e9 ; (nformf.s33 + 0)
.s34:
20fa : c5 4b __ CMP T4 + 0 
20fc : 90 02 __ BCC $2100 ; (nformf.s32 + 0)
.s110:
20fe : d0 e9 __ BNE $20e9 ; (nformf.s33 + 0)
.s32:
2100 : b1 0d __ LDA (P0),y ; (si + 0)
.s3:
2102 : 85 1b __ STA ACCU + 0 
2104 : ad ed 9f LDA $9fed ; (nformf@stack + 0)
2107 : 85 53 __ STA T10 + 0 
2109 : ad ee 9f LDA $9fee ; (nformf@stack + 1)
210c : 85 54 __ STA T11 + 0 
210e : 60 __ __ RTS
.l36:
210f : 8a __ __ TXA
2110 : a0 01 __ LDY #$01
2112 : d1 0d __ CMP (P0),y ; (si + 0)
2114 : b0 ea __ BCS $2100 ; (nformf.s32 + 0)
.s37:
2116 : a8 __ __ TAY
2117 : a9 20 __ LDA #$20
2119 : 91 0f __ STA (P2),y ; (str + 0)
211b : e8 __ __ INX
211c : 90 f1 __ BCC $210f ; (nformf.l36 + 0)
.s53:
211e : a5 4f __ LDA T6 + 0 
2120 : c9 07 __ CMP #$07
2122 : 90 14 __ BCC $2138 ; (nformf.s62 + 0)
.s54:
2124 : ad 1a 2f LDA $2f1a ; (fround5[0] + 24)
2127 : 85 47 __ STA T1 + 0 
2129 : ad 1b 2f LDA $2f1b ; (fround5[0] + 25)
212c : 85 48 __ STA T1 + 1 
212e : ad 1c 2f LDA $2f1c ; (fround5[0] + 26)
2131 : 85 49 __ STA T1 + 2 
2133 : ad 1d 2f LDA $2f1d ; (fround5[0] + 27)
2136 : b0 15 __ BCS $214d ; (nformf.s55 + 0)
.s62:
2138 : 0a __ __ ASL
2139 : 0a __ __ ASL
213a : aa __ __ TAX
213b : bd fe 2e LDA $2efe,x ; (current_page + 0)
213e : 85 47 __ STA T1 + 0 
2140 : bd ff 2e LDA $2eff,x ; (current_page + 1)
2143 : 85 48 __ STA T1 + 1 
2145 : bd 00 2f LDA $2f00,x ; (search_query_len + 0)
2148 : 85 49 __ STA T1 + 2 
214a : bd 01 2f LDA $2f01,x ; (search_query_len + 1)
.s55:
214d : 85 4a __ STA T1 + 3 
214f : a2 47 __ LDX #$47
2151 : 20 a5 2e JSR $2ea5 ; (freg@proxy + 0)
2154 : 20 33 28 JSR $2833 ; (faddsub + 6)
2157 : a5 1c __ LDA ACCU + 1 
2159 : 85 12 __ STA P5 ; (f + 1)
215b : a5 1d __ LDA ACCU + 2 
215d : 85 13 __ STA P6 ; (f + 2)
215f : a6 1b __ LDX ACCU + 0 
2161 : a5 1e __ LDA ACCU + 3 
2163 : 85 14 __ STA P7 ; (f + 3)
2165 : 10 03 __ BPL $216a ; (nformf.s57 + 0)
2167 : 4c 83 1f JMP $1f83 ; (nformf.s18 + 0)
.s57:
216a : c9 41 __ CMP #$41
216c : d0 0d __ BNE $217b ; (nformf.s61 + 0)
.s58:
216e : a5 13 __ LDA P6 ; (f + 2)
2170 : c9 20 __ CMP #$20
2172 : d0 07 __ BNE $217b ; (nformf.s61 + 0)
.s59:
2174 : a5 12 __ LDA P5 ; (f + 1)
2176 : d0 03 __ BNE $217b ; (nformf.s61 + 0)
.s60:
2178 : 8a __ __ TXA
2179 : f0 02 __ BEQ $217d ; (nformf.s56 + 0)
.s61:
217b : 90 ea __ BCC $2167 ; (nformf.s55 + 26)
.s56:
217d : a9 00 __ LDA #$00
217f : 85 03 __ STA WORK + 0 
2181 : 85 04 __ STA WORK + 1 
2183 : 20 9a 2e JSR $2e9a ; (freg@proxy + 0)
2186 : 20 e2 29 JSR $29e2 ; (crt_fdiv + 0)
2189 : a5 1c __ LDA ACCU + 1 
218b : 85 12 __ STA P5 ; (f + 1)
218d : a5 1d __ LDA ACCU + 2 
218f : 85 13 __ STA P6 ; (f + 2)
2191 : a5 1e __ LDA ACCU + 3 
2193 : 85 14 __ STA P7 ; (f + 3)
2195 : a6 1b __ LDX ACCU + 0 
2197 : e6 4d __ INC T5 + 0 
2199 : d0 cc __ BNE $2167 ; (nformf.s55 + 26)
.s115:
219b : e6 4e __ INC T5 + 1 
219d : 4c 83 1f JMP $1f83 ; (nformf.s18 + 0)
--------------------------------------------------------------------
21a0 : __ __ __ BYT 25 64 2d 25 64 20 6f 66 20 25 64 00             : %d-%d of %d.
--------------------------------------------------------------------
21ac : __ __ __ BYT 3e 00                                           : >.
--------------------------------------------------------------------
21ae : __ __ __ BYT 77 2f 73 3a 6d 6f 76 65 20 65 6e 74 65 72 3a 73 : w/s:move enter:s
21be : __ __ __ BYT 65 6c 20 2f 3a 73 65 61 72 63 68 20 71 3a 71 75 : el /:search q:qu
21ce : __ __ __ BYT 69 74 00                                        : it.
--------------------------------------------------------------------
21d1 : __ __ __ BYT 77 2f 73 3a 6d 6f 76 65 20 65 6e 74 65 72 3a 72 : w/s:move enter:r
21e1 : __ __ __ BYT 75 6e 20 64 65 6c 3a 62 61 63 6b 20 6e 2f 70 3a : un del:back n/p:
21f1 : __ __ __ BYT 70 61 67 65 00                                  : page.
--------------------------------------------------------------------
21f6 : __ __ __ BYT 4c 49 53 54 20 00                               : LIST .
--------------------------------------------------------------------
21fc : __ __ __ BYT 20 00                                           :  .
--------------------------------------------------------------------
spentry:
21fe : __ __ __ BYT 00                                              : .
--------------------------------------------------------------------
uci_target:
21ff : __ __ __ BYT 01                                              : .
--------------------------------------------------------------------
2200 : __ __ __ BYT 74 79 70 65 20 74 6f 20 73 65 61 72 63 68 20 65 : type to search e
2210 : __ __ __ BYT 6e 74 65 72 3a 72 75 6e 20 64 65 6c 3a 62 61 63 : nter:run del:bac
2220 : __ __ __ BYT 6b 00                                           : k.
--------------------------------------------------------------------
2222 : __ __ __ BYT 61 73 73 65 6d 62 6c 79 36 34 20 2d 20 63 61 74 : assembly64 - cat
2232 : __ __ __ BYT 65 67 6f 72 69 65 73 00                         : egories.
--------------------------------------------------------------------
get_key: ; get_key()->u8
; 355, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s1:
223a : a5 53 __ LDA T1 + 0 
223c : 8d b5 9f STA $9fb5 ; (get_key@stack + 0)
223f : a5 54 __ LDA T3 + 0 
2241 : 8d b6 9f STA $9fb6 ; (get_key@stack + 1)
.s4:
2244 : 20 79 0e JSR $0e79 ; (keyb_poll.s4 + 0)
2247 : ad 9e 36 LDA $369e ; (keyb_key + 0)
224a : 30 03 __ BMI $224f ; (get_key.s6 + 0)
224c : 4c db 22 JMP $22db ; (get_key.s5 + 0)
.s6:
224f : 29 40 __ AND #$40
2251 : f0 02 __ BEQ $2255 ; (get_key.s42 + 0)
.s41:
2253 : a9 01 __ LDA #$01
.s42:
2255 : 85 54 __ STA T3 + 0 
2257 : 8d fe 9f STA $9ffe ; (sstack + 8)
225a : ad 9e 36 LDA $369e ; (keyb_key + 0)
225d : 29 3f __ AND #$3f
225f : 85 53 __ STA T1 + 0 
2261 : 85 18 __ STA P11 
2263 : 20 88 0c JSR $0c88 ; (debug_key.s4 + 0)
2266 : a5 53 __ LDA T1 + 0 
2268 : c9 01 __ CMP #$01
226a : d0 0f __ BNE $227b ; (get_key.s7 + 0)
.s40:
226c : a9 0d __ LDA #$0d
.s3:
226e : 85 1b __ STA ACCU + 0 
2270 : ad b5 9f LDA $9fb5 ; (get_key@stack + 0)
2273 : 85 53 __ STA T1 + 0 
2275 : ad b6 9f LDA $9fb6 ; (get_key@stack + 1)
2278 : 85 54 __ STA T3 + 0 
227a : 60 __ __ RTS
.s7:
227b : aa __ __ TAX
227c : d0 04 __ BNE $2282 ; (get_key.s9 + 0)
.s8:
227e : a9 08 __ LDA #$08
2280 : d0 ec __ BNE $226e ; (get_key.s3 + 0)
.s9:
2282 : ad fe 2e LDA $2efe ; (current_page + 0)
2285 : 0d ff 2e ORA $2eff ; (current_page + 1)
2288 : d0 03 __ BNE $228d ; (get_key.s10 + 0)
228a : 4c 0b 23 JMP $230b ; (get_key.s33 + 0)
.s10:
228d : ad ff 2e LDA $2eff ; (current_page + 1)
2290 : d0 49 __ BNE $22db ; (get_key.s5 + 0)
.s32:
2292 : ae fe 2e LDX $2efe ; (current_page + 0)
2295 : ca __ __ DEX
2296 : f0 53 __ BEQ $22eb ; (get_key.s25 + 0)
.s24:
2298 : ad fe 2e LDA $2efe ; (current_page + 0)
229b : c9 02 __ CMP #$02
229d : d0 3c __ BNE $22db ; (get_key.s5 + 0)
.s11:
229f : ad f7 2e LDA $2ef7 ; (item_count + 1)
22a2 : 30 0b __ BMI $22af ; (get_key.s12 + 0)
.s23:
22a4 : 0d f6 2e ORA $2ef6 ; (item_count + 0)
22a7 : f0 06 __ BEQ $22af ; (get_key.s12 + 0)
.s21:
22a9 : a5 53 __ LDA T1 + 0 
22ab : c9 07 __ CMP #$07
22ad : f0 30 __ BEQ $22df ; (get_key.s22 + 0)
.s12:
22af : a5 54 __ LDA T3 + 0 
22b1 : f0 06 __ BEQ $22b9 ; (get_key.s13 + 0)
.s20:
22b3 : a5 53 __ LDA T1 + 0 
22b5 : 09 40 __ ORA #$40
22b7 : 85 53 __ STA T1 + 0 
.s13:
22b9 : a6 53 __ LDX T1 + 0 
22bb : bd 1e 2f LDA $2f1e,x ; (keyb_codes[0] + 0)
22be : c9 61 __ CMP #$61
22c0 : 90 09 __ BCC $22cb ; (get_key.s14 + 0)
.s18:
22c2 : c9 7b __ CMP #$7b
22c4 : b0 05 __ BCS $22cb ; (get_key.s14 + 0)
.s19:
22c6 : e9 1f __ SBC #$1f
22c8 : 4c 6e 22 JMP $226e ; (get_key.s3 + 0)
.s14:
22cb : c9 41 __ CMP #$41
22cd : 90 04 __ BCC $22d3 ; (get_key.s15 + 0)
.s17:
22cf : c9 5b __ CMP #$5b
22d1 : 90 9b __ BCC $226e ; (get_key.s3 + 0)
.s15:
22d3 : c9 30 __ CMP #$30
22d5 : 90 04 __ BCC $22db ; (get_key.s5 + 0)
.s16:
22d7 : c9 3a __ CMP #$3a
22d9 : 90 93 __ BCC $226e ; (get_key.s3 + 0)
.s5:
22db : a9 00 __ LDA #$00
22dd : f0 8f __ BEQ $226e ; (get_key.s3 + 0)
.s22:
22df : a5 54 __ LDA T3 + 0 
22e1 : f0 04 __ BEQ $22e7 ; (get_key.s43 + 0)
.s44:
22e3 : a9 75 __ LDA #$75
22e5 : d0 87 __ BNE $226e ; (get_key.s3 + 0)
.s43:
22e7 : a9 64 __ LDA #$64
22e9 : d0 83 __ BNE $226e ; (get_key.s3 + 0)
.s25:
22eb : a5 53 __ LDA T1 + 0 
22ed : c9 09 __ CMP #$09
22ef : f0 f2 __ BEQ $22e3 ; (get_key.s44 + 0)
.s26:
22f1 : c9 07 __ CMP #$07
22f3 : f0 ea __ BEQ $22df ; (get_key.s22 + 0)
.s27:
22f5 : c9 0d __ CMP #$0d
22f7 : f0 ee __ BEQ $22e7 ; (get_key.s43 + 0)
.s28:
22f9 : c9 27 __ CMP #$27
22fb : d0 05 __ BNE $2302 ; (get_key.s29 + 0)
.s31:
22fd : a9 6e __ LDA #$6e
22ff : 4c 6e 22 JMP $226e ; (get_key.s3 + 0)
.s29:
2302 : c9 29 __ CMP #$29
2304 : d0 d5 __ BNE $22db ; (get_key.s5 + 0)
.s30:
2306 : a9 70 __ LDA #$70
2308 : 4c 6e 22 JMP $226e ; (get_key.s3 + 0)
.s33:
230b : a5 53 __ LDA T1 + 0 
230d : c9 3e __ CMP #$3e
230f : d0 05 __ BNE $2316 ; (get_key.s34 + 0)
.s39:
2311 : a9 71 __ LDA #$71
2313 : 4c 6e 22 JMP $226e ; (get_key.s3 + 0)
.s34:
2316 : c9 09 __ CMP #$09
2318 : f0 c9 __ BEQ $22e3 ; (get_key.s44 + 0)
.s35:
231a : c9 07 __ CMP #$07
231c : f0 c1 __ BEQ $22df ; (get_key.s22 + 0)
.s36:
231e : c9 0d __ CMP #$0d
2320 : f0 c5 __ BEQ $22e7 ; (get_key.s43 + 0)
.s37:
2322 : c9 37 __ CMP #$37
2324 : d0 b5 __ BNE $22db ; (get_key.s5 + 0)
.s38:
2326 : a9 2f __ LDA #$2f
2328 : 4c 6e 22 JMP $226e ; (get_key.s3 + 0)
--------------------------------------------------------------------
232b : __ __ __ BYT 6b 3d 25 30 32 78 20 63 3d 25 30 32 78 00       : k=%02x c=%02x.
--------------------------------------------------------------------
2339 : __ __ __ BYT 61 73 73 65 6d 62 6c 79 36 34 20 2d 20 73 65 61 : assembly64 - sea
2349 : __ __ __ BYT 72 63 68 00                                     : rch.
--------------------------------------------------------------------
load_entries: ; load_entries(const u8*,i16)->void
; 207, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s1:
234d : a2 07 __ LDX #$07
234f : b5 53 __ LDA T0 + 0,x 
2351 : 9d 86 9f STA $9f86,x ; (load_entries@stack + 0)
2354 : ca __ __ DEX
2355 : 10 f8 __ BPL $234f ; (load_entries.s1 + 2)
.s4:
2357 : a9 00 __ LDA #$00
2359 : 85 0d __ STA P0 
235b : a9 18 __ LDA #$18
235d : 85 0e __ STA P1 
235f : a9 20 __ LDA #$20
2361 : a2 28 __ LDX #$28
.l5:
2363 : ca __ __ DEX
2364 : 9d c0 07 STA $07c0,x 
2367 : d0 fa __ BNE $2363 ; (load_entries.l5 + 0)
.s6:
2369 : a9 23 __ LDA #$23
236b : 85 0f __ STA P2 
236d : a9 25 __ LDA #$25
236f : 85 10 __ STA P3 
2371 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
2374 : a9 98 __ LDA #$98
2376 : 85 0d __ STA P0 
2378 : a9 9f __ LDA #$9f
237a : 85 0e __ STA P1 
237c : a2 ff __ LDX #$ff
.l7:
237e : e8 __ __ INX
237f : bd f6 21 LDA $21f6,x 
2382 : 9d 98 9f STA $9f98,x ; (cmd[0] + 0)
2385 : d0 f7 __ BNE $237e ; (load_entries.l7 + 0)
.s8:
2387 : a9 00 __ LDA #$00
2389 : 85 0f __ STA P2 
238b : a9 3b __ LDA #$3b
238d : 85 10 __ STA P3 
238f : 20 2e 25 JSR $252e ; (strcat.s4 + 0)
2392 : a9 fc __ LDA #$fc
2394 : 85 0f __ STA P2 
2396 : a9 21 __ LDA #$21
2398 : 85 10 __ STA P3 
239a : 20 2e 25 JSR $252e ; (strcat.s4 + 0)
239d : ad fe 9f LDA $9ffe ; (sstack + 8)
23a0 : 85 57 __ STA T3 + 0 
23a2 : 8d f8 9f STA $9ff8 ; (sstack + 2)
23a5 : a9 90 __ LDA #$90
23a7 : 85 16 __ STA P9 
23a9 : a9 9f __ LDA #$9f
23ab : 85 17 __ STA P10 
23ad : a9 61 __ LDA #$61
23af : 8d f6 9f STA $9ff6 ; (sstack + 0)
23b2 : a9 25 __ LDA #$25
23b4 : 8d f7 9f STA $9ff7 ; (sstack + 1)
23b7 : ad ff 9f LDA $9fff ; (sstack + 9)
23ba : 85 58 __ STA T3 + 1 
23bc : 8d f9 9f STA $9ff9 ; (sstack + 3)
23bf : 20 0d 17 JSR $170d ; (sprintf.s1 + 0)
23c2 : a9 98 __ LDA #$98
23c4 : 85 0d __ STA P0 
23c6 : a9 9f __ LDA #$9f
23c8 : 85 10 __ STA P3 
23ca : a9 9f __ LDA #$9f
23cc : 85 0e __ STA P1 
23ce : a9 90 __ LDA #$90
23d0 : 85 0f __ STA P2 
23d2 : 20 2e 25 JSR $252e ; (strcat.s4 + 0)
23d5 : a9 64 __ LDA #$64
23d7 : 85 0f __ STA P2 
23d9 : a9 25 __ LDA #$25
23db : 85 10 __ STA P3 
23dd : 20 2e 25 JSR $252e ; (strcat.s4 + 0)
23e0 : a9 98 __ LDA #$98
23e2 : 85 14 __ STA P7 
23e4 : a9 9f __ LDA #$9f
23e6 : 85 15 __ STA P8 
23e8 : 20 ff 12 JSR $12ff ; (send_command.s4 + 0)
23eb : 20 10 11 JSR $1110 ; (read_line.s4 + 0)
23ee : 20 c4 13 JSR $13c4 ; (atoi@proxy + 0)
23f1 : a5 1b __ LDA ACCU + 0 
23f3 : 85 55 __ STA T2 + 0 
23f5 : a5 1c __ LDA ACCU + 1 
23f7 : 85 56 __ STA T2 + 1 
23f9 : 20 b8 2e JSR $2eb8 ; (strchr@proxy + 0)
23fc : a5 1c __ LDA ACCU + 1 
23fe : 05 1b __ ORA ACCU + 0 
2400 : f0 1a __ BEQ $241c ; (load_entries.s9 + 0)
.s28:
2402 : 18 __ __ CLC
2403 : a5 1b __ LDA ACCU + 0 
2405 : 69 01 __ ADC #$01
2407 : 85 0d __ STA P0 
2409 : a5 1c __ LDA ACCU + 1 
240b : 69 00 __ ADC #$00
240d : 85 0e __ STA P1 
240f : 20 cc 13 JSR $13cc ; (atoi.l4 + 0)
2412 : a5 1b __ LDA ACCU + 0 
2414 : 8d f8 2e STA $2ef8 ; (total_count + 0)
2417 : a5 1c __ LDA ACCU + 1 
2419 : 8d f9 2e STA $2ef9 ; (total_count + 1)
.s9:
241c : a5 57 __ LDA T3 + 0 
241e : 8d fc 2e STA $2efc ; (offset + 0)
2421 : a5 58 __ LDA T3 + 1 
2423 : 8d fd 2e STA $2efd ; (offset + 1)
2426 : a9 00 __ LDA #$00
2428 : 8d f6 2e STA $2ef6 ; (item_count + 0)
242b : 8d f7 2e STA $2ef7 ; (item_count + 1)
242e : a5 56 __ LDA T2 + 1 
2430 : 30 3e __ BMI $2470 ; (load_entries.s10 + 0)
.s27:
2432 : 05 55 __ ORA T2 + 0 
2434 : f0 3a __ BEQ $2470 ; (load_entries.s10 + 0)
.s15:
2436 : a9 00 __ LDA #$00
2438 : 85 57 __ STA T3 + 0 
.l16:
243a : 20 10 11 JSR $1110 ; (read_line.s4 + 0)
243d : ad 00 38 LDA $3800 ; (line_buffer[0] + 0)
2440 : c9 2e __ CMP #$2e
2442 : f0 2c __ BEQ $2470 ; (load_entries.s10 + 0)
.s17:
2444 : 20 76 14 JSR $1476 ; (strchr@proxy + 0)
2447 : a5 1c __ LDA ACCU + 1 
2449 : 05 1b __ ORA ACCU + 0 
244b : d0 62 __ BNE $24af ; (load_entries.s24 + 0)
.s18:
244d : ad f6 2e LDA $2ef6 ; (item_count + 0)
2450 : 85 57 __ STA T3 + 0 
2452 : ad f7 2e LDA $2ef7 ; (item_count + 1)
2455 : 30 e3 __ BMI $243a ; (load_entries.l16 + 0)
.s23:
2457 : d0 17 __ BNE $2470 ; (load_entries.s10 + 0)
.s22:
2459 : a5 57 __ LDA T3 + 0 
245b : c9 14 __ CMP #$14
245d : b0 11 __ BCS $2470 ; (load_entries.s10 + 0)
.s19:
245f : ad f7 2e LDA $2ef7 ; (item_count + 1)
2462 : 30 d6 __ BMI $243a ; (load_entries.l16 + 0)
.s21:
2464 : c5 56 __ CMP T2 + 1 
2466 : 90 d2 __ BCC $243a ; (load_entries.l16 + 0)
.s29:
2468 : d0 06 __ BNE $2470 ; (load_entries.s10 + 0)
.s20:
246a : a5 57 __ LDA T3 + 0 
246c : c5 55 __ CMP T2 + 0 
246e : 90 ca __ BCC $243a ; (load_entries.l16 + 0)
.s10:
2470 : ad 00 38 LDA $3800 ; (line_buffer[0] + 0)
2473 : c9 2e __ CMP #$2e
2475 : f0 0a __ BEQ $2481 ; (load_entries.s11 + 0)
.l14:
2477 : 20 10 11 JSR $1110 ; (read_line.s4 + 0)
247a : ad 00 38 LDA $3800 ; (line_buffer[0] + 0)
247d : c9 2e __ CMP #$2e
247f : d0 f6 __ BNE $2477 ; (load_entries.l14 + 0)
.s11:
2481 : a9 00 __ LDA #$00
2483 : 85 0d __ STA P0 
2485 : 8d ff 2e STA $2eff ; (current_page + 1)
2488 : 8d fa 2e STA $2efa ; (cursor + 0)
248b : 8d fb 2e STA $2efb ; (cursor + 1)
248e : a9 18 __ LDA #$18
2490 : 85 0e __ STA P1 
2492 : a9 01 __ LDA #$01
2494 : 8d fe 2e STA $2efe ; (current_page + 0)
2497 : a9 20 __ LDA #$20
2499 : a2 28 __ LDX #$28
.l12:
249b : ca __ __ DEX
249c : 9d c0 07 STA $07c0,x 
249f : d0 fa __ BNE $249b ; (load_entries.l12 + 0)
.s13:
24a1 : 20 de 12 JSR $12de ; (print_at@proxy + 0)
.s3:
24a4 : a2 07 __ LDX #$07
24a6 : bd 86 9f LDA $9f86,x ; (load_entries@stack + 0)
24a9 : 95 53 __ STA T0 + 0,x 
24ab : ca __ __ DEX
24ac : 10 f8 __ BPL $24a6 ; (load_entries.s3 + 2)
24ae : 60 __ __ RTS
.s24:
24af : a5 1c __ LDA ACCU + 1 
24b1 : 85 5a __ STA T4 + 1 
24b3 : a5 1b __ LDA ACCU + 0 
24b5 : 85 59 __ STA T4 + 0 
24b7 : a9 00 __ LDA #$00
24b9 : a8 __ __ TAY
24ba : 91 1b __ STA (ACCU + 0),y 
24bc : 20 cb 2e JSR $2ecb ; (atoi@proxy + 0)
24bf : a5 57 __ LDA T3 + 0 
24c1 : 0a __ __ ASL
24c2 : aa __ __ TAX
24c3 : a5 1b __ LDA ACCU + 0 
24c5 : 9d aa 36 STA $36aa,x ; (item_ids[0] + 0)
24c8 : a5 1c __ LDA ACCU + 1 
24ca : 9d ab 36 STA $36ab,x ; (item_ids[0] + 1)
24cd : 18 __ __ CLC
24ce : a5 59 __ LDA T4 + 0 
24d0 : 69 01 __ ADC #$01
24d2 : 85 59 __ STA T4 + 0 
24d4 : 85 0d __ STA P0 
24d6 : a5 5a __ LDA T4 + 1 
24d8 : 69 00 __ ADC #$00
24da : 85 5a __ STA T4 + 1 
24dc : 85 0e __ STA P1 
24de : 20 86 14 JSR $1486 ; (strchr.l4 + 0)
24e1 : a5 59 __ LDA T4 + 0 
24e3 : 85 0f __ STA P2 
24e5 : a5 5a __ LDA T4 + 1 
24e7 : 85 10 __ STA P3 
24e9 : a5 1b __ LDA ACCU + 0 
24eb : 05 1c __ ORA ACCU + 1 
24ed : f0 05 __ BEQ $24f4 ; (load_entries.s25 + 0)
.s26:
24ef : a9 00 __ LDA #$00
24f1 : a8 __ __ TAY
24f2 : 91 1b __ STA (ACCU + 0),y 
.s25:
24f4 : a5 57 __ LDA T3 + 0 
24f6 : 4a __ __ LSR
24f7 : 6a __ __ ROR
24f8 : 6a __ __ ROR
24f9 : aa __ __ TAX
24fa : 29 c0 __ AND #$c0
24fc : 6a __ __ ROR
24fd : 69 80 __ ADC #$80
24ff : 85 53 __ STA T0 + 0 
2501 : 85 0d __ STA P0 
2503 : 8a __ __ TXA
2504 : 29 1f __ AND #$1f
2506 : 69 38 __ ADC #$38
2508 : 85 54 __ STA T0 + 1 
250a : 85 0e __ STA P1 
250c : 20 a8 14 JSR $14a8 ; (strncpy.s4 + 0)
250f : a9 00 __ LDA #$00
2511 : a0 1f __ LDY #$1f
2513 : 91 53 __ STA (T0 + 0),y 
2515 : a6 57 __ LDX T3 + 0 
2517 : e8 __ __ INX
2518 : 8e f6 2e STX $2ef6 ; (item_count + 0)
251b : a9 00 __ LDA #$00
251d : 8d f7 2e STA $2ef7 ; (item_count + 1)
2520 : 4c 4d 24 JMP $244d ; (load_entries.s18 + 0)
--------------------------------------------------------------------
2523 : __ __ __ BYT 6c 6f 61 64 69 6e 67 2e 2e 2e 00                : loading....
--------------------------------------------------------------------
strcat: ; strcat(u8*,const u8*)->void
;  14, "/usr/local/include/oscar64/string.h"
.s4:
252e : a5 0d __ LDA P0 ; (dst + 0)
2530 : 85 1b __ STA ACCU + 0 
2532 : a5 0e __ LDA P1 ; (dst + 1)
2534 : 85 1c __ STA ACCU + 1 
2536 : a0 00 __ LDY #$00
2538 : b1 0d __ LDA (P0),y ; (dst + 0)
253a : f0 0f __ BEQ $254b ; (strcat.s5 + 0)
.s6:
253c : 84 1b __ STY ACCU + 0 
253e : a4 0d __ LDY P0 ; (dst + 0)
.l7:
2540 : c8 __ __ INY
2541 : d0 02 __ BNE $2545 ; (strcat.s11 + 0)
.s10:
2543 : e6 1c __ INC ACCU + 1 
.s11:
2545 : b1 1b __ LDA (ACCU + 0),y 
2547 : d0 f7 __ BNE $2540 ; (strcat.l7 + 0)
.s8:
2549 : 84 1b __ STY ACCU + 0 
.s5:
254b : a8 __ __ TAY
.l9:
254c : b1 0f __ LDA (P2),y ; (src + 0)
254e : 91 1b __ STA (ACCU + 0),y 
2550 : aa __ __ TAX
2551 : e6 0f __ INC P2 ; (src + 0)
2553 : d0 02 __ BNE $2557 ; (strcat.s13 + 0)
.s12:
2555 : e6 10 __ INC P3 ; (src + 1)
.s13:
2557 : e6 1b __ INC ACCU + 0 
2559 : d0 02 __ BNE $255d ; (strcat.s15 + 0)
.s14:
255b : e6 1c __ INC ACCU + 1 
.s15:
255d : 8a __ __ TXA
255e : d0 ec __ BNE $254c ; (strcat.l9 + 0)
.s3:
2560 : 60 __ __ RTS
--------------------------------------------------------------------
2561 : __ __ __ BYT 25 64 00                                        : %d.
--------------------------------------------------------------------
2564 : __ __ __ BYT 20 32 30 00                                     :  20.
--------------------------------------------------------------------
run_entry: ; run_entry(i16)->void
; 272, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
2568 : a9 00 __ LDA #$00
256a : 85 0d __ STA P0 
256c : a9 18 __ LDA #$18
256e : 85 0e __ STA P1 
2570 : a9 20 __ LDA #$20
2572 : a2 28 __ LDX #$28
.l5:
2574 : ca __ __ DEX
2575 : 9d c0 07 STA $07c0,x 
2578 : d0 fa __ BNE $2574 ; (run_entry.l5 + 0)
.s6:
257a : a9 d1 __ LDA #$d1
257c : 85 0f __ STA P2 
257e : a9 25 __ LDA #$25
2580 : 85 10 __ STA P3 
2582 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
2585 : a9 b8 __ LDA #$b8
2587 : 85 16 __ STA P9 
2589 : a9 dc __ LDA #$dc
258b : 8d f6 9f STA $9ff6 ; (sstack + 0)
258e : a9 9f __ LDA #$9f
2590 : 85 17 __ STA P10 
2592 : a9 25 __ LDA #$25
2594 : 8d f7 9f STA $9ff7 ; (sstack + 1)
2597 : ad fe 9f LDA $9ffe ; (sstack + 8)
259a : 8d f8 9f STA $9ff8 ; (sstack + 2)
259d : ad ff 9f LDA $9fff ; (sstack + 9)
25a0 : 8d f9 9f STA $9ff9 ; (sstack + 3)
25a3 : 20 0d 17 JSR $170d ; (sprintf.s1 + 0)
25a6 : a9 b8 __ LDA #$b8
25a8 : 85 14 __ STA P7 
25aa : a9 9f __ LDA #$9f
25ac : 85 15 __ STA P8 
25ae : 20 ff 12 JSR $12ff ; (send_command.s4 + 0)
25b1 : 20 10 11 JSR $1110 ; (read_line.s4 + 0)
25b4 : a9 00 __ LDA #$00
25b6 : 85 0d __ STA P0 
25b8 : a9 18 __ LDA #$18
25ba : 85 0e __ STA P1 
25bc : a9 20 __ LDA #$20
25be : a2 28 __ LDX #$28
.l7:
25c0 : ca __ __ DEX
25c1 : 9d c0 07 STA $07c0,x 
25c4 : d0 fa __ BNE $25c0 ; (run_entry.l7 + 0)
.s8:
25c6 : a9 00 __ LDA #$00
25c8 : 85 0f __ STA P2 
25ca : a9 38 __ LDA #$38
25cc : 85 10 __ STA P3 
25ce : 4c d7 0c JMP $0cd7 ; (print_at.s4 + 0)
--------------------------------------------------------------------
25d1 : __ __ __ BYT 72 75 6e 6e 69 6e 67 2e 2e 2e 00                : running....
--------------------------------------------------------------------
25dc : __ __ __ BYT 52 55 4e 20 25 64 00                            : RUN %d.
--------------------------------------------------------------------
do_search: ; do_search(const u8*,i16)->void
; 285, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s1:
25e3 : a2 06 __ LDX #$06
25e5 : b5 53 __ LDA T0 + 0,x 
25e7 : 9d 8e 9f STA $9f8e,x ; (do_search@stack + 0)
25ea : ca __ __ DEX
25eb : 10 f8 __ BPL $25e5 ; (do_search.s1 + 2)
.s4:
25ed : a9 00 __ LDA #$00
25ef : 85 0d __ STA P0 
25f1 : a9 18 __ LDA #$18
25f3 : 85 0e __ STA P1 
25f5 : a9 20 __ LDA #$20
25f7 : a2 28 __ LDX #$28
.l5:
25f9 : ca __ __ DEX
25fa : 9d c0 07 STA $07c0,x 
25fd : d0 fa __ BNE $25f9 ; (do_search.l5 + 0)
.s6:
25ff : a9 70 __ LDA #$70
2601 : 85 0f __ STA P2 
2603 : a9 27 __ LDA #$27
2605 : 85 10 __ STA P3 
2607 : 20 d7 0c JSR $0cd7 ; (print_at.s4 + 0)
260a : a9 00 __ LDA #$00
260c : 8d fa 9f STA $9ffa ; (sstack + 4)
260f : 8d fb 9f STA $9ffb ; (sstack + 5)
2612 : a9 98 __ LDA #$98
2614 : 85 16 __ STA P9 
2616 : a9 7d __ LDA #$7d
2618 : 8d f6 9f STA $9ff6 ; (sstack + 0)
261b : a9 9f __ LDA #$9f
261d : 85 17 __ STA P10 
261f : a9 27 __ LDA #$27
2621 : 8d f7 9f STA $9ff7 ; (sstack + 1)
2624 : a9 d2 __ LDA #$d2
2626 : 8d f8 9f STA $9ff8 ; (sstack + 2)
2629 : a9 36 __ LDA #$36
262b : 8d f9 9f STA $9ff9 ; (sstack + 3)
262e : 20 0d 17 JSR $170d ; (sprintf.s1 + 0)
2631 : a9 98 __ LDA #$98
2633 : 85 14 __ STA P7 
2635 : a9 9f __ LDA #$9f
2637 : 85 15 __ STA P8 
2639 : 20 ff 12 JSR $12ff ; (send_command.s4 + 0)
263c : 20 10 11 JSR $1110 ; (read_line.s4 + 0)
263f : 20 c4 13 JSR $13c4 ; (atoi@proxy + 0)
2642 : a5 1b __ LDA ACCU + 0 
2644 : 85 55 __ STA T2 + 0 
2646 : a5 1c __ LDA ACCU + 1 
2648 : 85 56 __ STA T2 + 1 
264a : 20 b8 2e JSR $2eb8 ; (strchr@proxy + 0)
264d : a5 1c __ LDA ACCU + 1 
264f : 05 1b __ ORA ACCU + 0 
2651 : f0 1a __ BEQ $266d ; (do_search.s7 + 0)
.s26:
2653 : 18 __ __ CLC
2654 : a5 1b __ LDA ACCU + 0 
2656 : 69 01 __ ADC #$01
2658 : 85 0d __ STA P0 
265a : a5 1c __ LDA ACCU + 1 
265c : 69 00 __ ADC #$00
265e : 85 0e __ STA P1 
2660 : 20 cc 13 JSR $13cc ; (atoi.l4 + 0)
2663 : a5 1b __ LDA ACCU + 0 
2665 : 8d f8 2e STA $2ef8 ; (total_count + 0)
2668 : a5 1c __ LDA ACCU + 1 
266a : 8d f9 2e STA $2ef9 ; (total_count + 1)
.s7:
266d : a9 00 __ LDA #$00
266f : 8d fc 2e STA $2efc ; (offset + 0)
2672 : 8d fd 2e STA $2efd ; (offset + 1)
2675 : 8d f6 2e STA $2ef6 ; (item_count + 0)
2678 : 8d f7 2e STA $2ef7 ; (item_count + 1)
267b : a5 56 __ LDA T2 + 1 
267d : 30 3e __ BMI $26bd ; (do_search.s8 + 0)
.s25:
267f : 05 55 __ ORA T2 + 0 
2681 : f0 3a __ BEQ $26bd ; (do_search.s8 + 0)
.s13:
2683 : a9 00 __ LDA #$00
2685 : 85 57 __ STA T3 + 0 
.l14:
2687 : 20 10 11 JSR $1110 ; (read_line.s4 + 0)
268a : ad 00 38 LDA $3800 ; (line_buffer[0] + 0)
268d : c9 2e __ CMP #$2e
268f : f0 2c __ BEQ $26bd ; (do_search.s8 + 0)
.s15:
2691 : 20 76 14 JSR $1476 ; (strchr@proxy + 0)
2694 : a5 1c __ LDA ACCU + 1 
2696 : 05 1b __ ORA ACCU + 0 
2698 : d0 62 __ BNE $26fc ; (do_search.s22 + 0)
.s16:
269a : ad f6 2e LDA $2ef6 ; (item_count + 0)
269d : 85 57 __ STA T3 + 0 
269f : ad f7 2e LDA $2ef7 ; (item_count + 1)
26a2 : 30 e3 __ BMI $2687 ; (do_search.l14 + 0)
.s21:
26a4 : d0 17 __ BNE $26bd ; (do_search.s8 + 0)
.s20:
26a6 : a5 57 __ LDA T3 + 0 
26a8 : c9 14 __ CMP #$14
26aa : b0 11 __ BCS $26bd ; (do_search.s8 + 0)
.s17:
26ac : ad f7 2e LDA $2ef7 ; (item_count + 1)
26af : 30 d6 __ BMI $2687 ; (do_search.l14 + 0)
.s19:
26b1 : c5 56 __ CMP T2 + 1 
26b3 : 90 d2 __ BCC $2687 ; (do_search.l14 + 0)
.s27:
26b5 : d0 06 __ BNE $26bd ; (do_search.s8 + 0)
.s18:
26b7 : a5 57 __ LDA T3 + 0 
26b9 : c5 55 __ CMP T2 + 0 
26bb : 90 ca __ BCC $2687 ; (do_search.l14 + 0)
.s8:
26bd : ad 00 38 LDA $3800 ; (line_buffer[0] + 0)
26c0 : c9 2e __ CMP #$2e
26c2 : f0 0a __ BEQ $26ce ; (do_search.s9 + 0)
.l12:
26c4 : 20 10 11 JSR $1110 ; (read_line.s4 + 0)
26c7 : ad 00 38 LDA $3800 ; (line_buffer[0] + 0)
26ca : c9 2e __ CMP #$2e
26cc : d0 f6 __ BNE $26c4 ; (do_search.l12 + 0)
.s9:
26ce : a9 00 __ LDA #$00
26d0 : 85 0d __ STA P0 
26d2 : 8d ff 2e STA $2eff ; (current_page + 1)
26d5 : 8d fa 2e STA $2efa ; (cursor + 0)
26d8 : 8d fb 2e STA $2efb ; (cursor + 1)
26db : a9 18 __ LDA #$18
26dd : 85 0e __ STA P1 
26df : a9 02 __ LDA #$02
26e1 : 8d fe 2e STA $2efe ; (current_page + 0)
26e4 : a9 20 __ LDA #$20
26e6 : a2 28 __ LDX #$28
.l10:
26e8 : ca __ __ DEX
26e9 : 9d c0 07 STA $07c0,x 
26ec : d0 fa __ BNE $26e8 ; (do_search.l10 + 0)
.s11:
26ee : 20 de 12 JSR $12de ; (print_at@proxy + 0)
.s3:
26f1 : a2 06 __ LDX #$06
26f3 : bd 8e 9f LDA $9f8e,x ; (do_search@stack + 0)
26f6 : 95 53 __ STA T0 + 0,x 
26f8 : ca __ __ DEX
26f9 : 10 f8 __ BPL $26f3 ; (do_search.s3 + 2)
26fb : 60 __ __ RTS
.s22:
26fc : a5 1c __ LDA ACCU + 1 
26fe : 85 59 __ STA T4 + 1 
2700 : a5 1b __ LDA ACCU + 0 
2702 : 85 58 __ STA T4 + 0 
2704 : a9 00 __ LDA #$00
2706 : a8 __ __ TAY
2707 : 91 1b __ STA (ACCU + 0),y 
2709 : 20 cb 2e JSR $2ecb ; (atoi@proxy + 0)
270c : a5 57 __ LDA T3 + 0 
270e : 0a __ __ ASL
270f : aa __ __ TAX
2710 : a5 1b __ LDA ACCU + 0 
2712 : 9d aa 36 STA $36aa,x ; (item_ids[0] + 0)
2715 : a5 1c __ LDA ACCU + 1 
2717 : 9d ab 36 STA $36ab,x ; (item_ids[0] + 1)
271a : 18 __ __ CLC
271b : a5 58 __ LDA T4 + 0 
271d : 69 01 __ ADC #$01
271f : 85 58 __ STA T4 + 0 
2721 : 85 0d __ STA P0 
2723 : a5 59 __ LDA T4 + 1 
2725 : 69 00 __ ADC #$00
2727 : 85 59 __ STA T4 + 1 
2729 : 85 0e __ STA P1 
272b : 20 86 14 JSR $1486 ; (strchr.l4 + 0)
272e : a5 58 __ LDA T4 + 0 
2730 : 85 0f __ STA P2 
2732 : a5 59 __ LDA T4 + 1 
2734 : 85 10 __ STA P3 
2736 : a5 1b __ LDA ACCU + 0 
2738 : 05 1c __ ORA ACCU + 1 
273a : f0 05 __ BEQ $2741 ; (do_search.s23 + 0)
.s24:
273c : a9 00 __ LDA #$00
273e : a8 __ __ TAY
273f : 91 1b __ STA (ACCU + 0),y 
.s23:
2741 : a5 57 __ LDA T3 + 0 
2743 : 4a __ __ LSR
2744 : 6a __ __ ROR
2745 : 6a __ __ ROR
2746 : aa __ __ TAX
2747 : 29 c0 __ AND #$c0
2749 : 6a __ __ ROR
274a : 69 80 __ ADC #$80
274c : 85 53 __ STA T0 + 0 
274e : 85 0d __ STA P0 
2750 : 8a __ __ TXA
2751 : 29 1f __ AND #$1f
2753 : 69 38 __ ADC #$38
2755 : 85 54 __ STA T0 + 1 
2757 : 85 0e __ STA P1 
2759 : 20 a8 14 JSR $14a8 ; (strncpy.s4 + 0)
275c : a9 00 __ LDA #$00
275e : a0 1f __ LDY #$1f
2760 : 91 53 __ STA (T0 + 0),y 
2762 : a6 57 __ LDX T3 + 0 
2764 : e8 __ __ INX
2765 : 8e f6 2e STX $2ef6 ; (item_count + 0)
2768 : a9 00 __ LDA #$00
276a : 8d f7 2e STA $2ef7 ; (item_count + 1)
276d : 4c 9a 26 JMP $269a ; (do_search.s16 + 0)
--------------------------------------------------------------------
2770 : __ __ __ BYT 73 65 61 72 63 68 69 6e 67 2e 2e 2e 00          : searching....
--------------------------------------------------------------------
277d : __ __ __ BYT 53 45 41 52 43 48 20 25 73 20 25 64 20 32 30 00 : SEARCH %s %d 20.
--------------------------------------------------------------------
disconnect_from_server: ; disconnect_from_server()->void
; 134, "/home/jalanara/Devel/Omat/C64U/c64uploader/c64client/src/main.c"
.s4:
278d : ad f5 2e LDA $2ef5 ; (connected + 0)
2790 : f0 46 __ BEQ $27d8 ; (disconnect_from_server.s3 + 0)
.s5:
2792 : a9 d9 __ LDA #$d9
2794 : 85 12 __ STA P5 
2796 : a9 27 __ LDA #$27
2798 : 85 13 __ STA P6 
279a : 20 d6 2e JSR $2ed6 ; (uci_socket_write@proxy + 0)
279d : a9 00 __ LDA #$00
279f : 85 10 __ STA P3 
27a1 : 8d f3 9f STA $9ff3 ; (cmd[0] + 0)
27a4 : a9 09 __ LDA #$09
27a6 : 8d f4 9f STA $9ff4 ; (cmd[0] + 1)
27a9 : a5 11 __ LDA P4 
27ab : 8d f5 9f STA $9ff5 ; (cmd[0] + 2)
27ae : ad ff 21 LDA $21ff ; (uci_target + 0)
27b1 : 85 4a __ STA T1 + 0 
27b3 : a9 03 __ LDA #$03
27b5 : 85 0f __ STA P2 
27b7 : 8d ff 21 STA $21ff ; (uci_target + 0)
27ba : a9 f3 __ LDA #$f3
27bc : 85 0d __ STA P0 
27be : a9 9f __ LDA #$9f
27c0 : 85 0e __ STA P1 
27c2 : 20 73 0d JSR $0d73 ; (uci_sendcommand.s4 + 0)
27c5 : 20 d8 0d JSR $0dd8 ; (uci_readdata.s4 + 0)
27c8 : 20 01 0e JSR $0e01 ; (uci_readstatus.s4 + 0)
27cb : 20 2a 0e JSR $0e2a ; (uci_accept.s4 + 0)
27ce : a9 00 __ LDA #$00
27d0 : 8d f5 2e STA $2ef5 ; (connected + 0)
27d3 : a5 4a __ LDA T1 + 0 
27d5 : 8d ff 21 STA $21ff ; (uci_target + 0)
.s3:
27d8 : 60 __ __ RTS
--------------------------------------------------------------------
27d9 : __ __ __ BYT 51 55 49 54 0a 00                               : QUIT..
--------------------------------------------------------------------
27df : __ __ __ BYT 67 6f 6f 64 62 79 65 21 00                      : goodbye!.
--------------------------------------------------------------------
freg: ; freg
27e8 : b1 19 __ LDA (IP + 0),y 
27ea : c8 __ __ INY
27eb : aa __ __ TAX
27ec : b5 00 __ LDA $00,x 
27ee : 85 03 __ STA WORK + 0 
27f0 : b5 01 __ LDA $01,x 
27f2 : 85 04 __ STA WORK + 1 
27f4 : b5 02 __ LDA $02,x 
27f6 : 85 05 __ STA WORK + 2 
27f8 : b5 03 __ LDA WORK + 0,x 
27fa : 85 06 __ STA WORK + 3 
27fc : a5 05 __ LDA WORK + 2 
27fe : 0a __ __ ASL
27ff : a5 06 __ LDA WORK + 3 
2801 : 2a __ __ ROL
2802 : 85 08 __ STA WORK + 5 
2804 : f0 06 __ BEQ $280c ; (freg + 36)
2806 : a5 05 __ LDA WORK + 2 
2808 : 09 80 __ ORA #$80
280a : 85 05 __ STA WORK + 2 
280c : a5 1d __ LDA ACCU + 2 
280e : 0a __ __ ASL
280f : a5 1e __ LDA ACCU + 3 
2811 : 2a __ __ ROL
2812 : 85 07 __ STA WORK + 4 
2814 : f0 06 __ BEQ $281c ; (freg + 52)
2816 : a5 1d __ LDA ACCU + 2 
2818 : 09 80 __ ORA #$80
281a : 85 1d __ STA ACCU + 2 
281c : 60 __ __ RTS
281d : 06 1e __ ASL ACCU + 3 
281f : a5 07 __ LDA WORK + 4 
2821 : 6a __ __ ROR
2822 : 85 1e __ STA ACCU + 3 
2824 : b0 06 __ BCS $282c ; (freg + 68)
2826 : a5 1d __ LDA ACCU + 2 
2828 : 29 7f __ AND #$7f
282a : 85 1d __ STA ACCU + 2 
282c : 60 __ __ RTS
--------------------------------------------------------------------
faddsub: ; faddsub
282d : a5 06 __ LDA WORK + 3 
282f : 49 80 __ EOR #$80
2831 : 85 06 __ STA WORK + 3 
2833 : a9 ff __ LDA #$ff
2835 : c5 07 __ CMP WORK + 4 
2837 : f0 04 __ BEQ $283d ; (faddsub + 16)
2839 : c5 08 __ CMP WORK + 5 
283b : d0 11 __ BNE $284e ; (faddsub + 33)
283d : a5 1e __ LDA ACCU + 3 
283f : 09 7f __ ORA #$7f
2841 : 85 1e __ STA ACCU + 3 
2843 : a9 80 __ LDA #$80
2845 : 85 1d __ STA ACCU + 2 
2847 : a9 00 __ LDA #$00
2849 : 85 1b __ STA ACCU + 0 
284b : 85 1c __ STA ACCU + 1 
284d : 60 __ __ RTS
284e : 38 __ __ SEC
284f : a5 07 __ LDA WORK + 4 
2851 : e5 08 __ SBC WORK + 5 
2853 : f0 38 __ BEQ $288d ; (faddsub + 96)
2855 : aa __ __ TAX
2856 : b0 25 __ BCS $287d ; (faddsub + 80)
2858 : e0 e9 __ CPX #$e9
285a : b0 0e __ BCS $286a ; (faddsub + 61)
285c : a5 08 __ LDA WORK + 5 
285e : 85 07 __ STA WORK + 4 
2860 : a9 00 __ LDA #$00
2862 : 85 1b __ STA ACCU + 0 
2864 : 85 1c __ STA ACCU + 1 
2866 : 85 1d __ STA ACCU + 2 
2868 : f0 23 __ BEQ $288d ; (faddsub + 96)
286a : a5 1d __ LDA ACCU + 2 
286c : 4a __ __ LSR
286d : 66 1c __ ROR ACCU + 1 
286f : 66 1b __ ROR ACCU + 0 
2871 : e8 __ __ INX
2872 : d0 f8 __ BNE $286c ; (faddsub + 63)
2874 : 85 1d __ STA ACCU + 2 
2876 : a5 08 __ LDA WORK + 5 
2878 : 85 07 __ STA WORK + 4 
287a : 4c 8d 28 JMP $288d ; (faddsub + 96)
287d : e0 18 __ CPX #$18
287f : b0 33 __ BCS $28b4 ; (faddsub + 135)
2881 : a5 05 __ LDA WORK + 2 
2883 : 4a __ __ LSR
2884 : 66 04 __ ROR WORK + 1 
2886 : 66 03 __ ROR WORK + 0 
2888 : ca __ __ DEX
2889 : d0 f8 __ BNE $2883 ; (faddsub + 86)
288b : 85 05 __ STA WORK + 2 
288d : a5 1e __ LDA ACCU + 3 
288f : 29 80 __ AND #$80
2891 : 85 1e __ STA ACCU + 3 
2893 : 45 06 __ EOR WORK + 3 
2895 : 30 31 __ BMI $28c8 ; (faddsub + 155)
2897 : 18 __ __ CLC
2898 : a5 1b __ LDA ACCU + 0 
289a : 65 03 __ ADC WORK + 0 
289c : 85 1b __ STA ACCU + 0 
289e : a5 1c __ LDA ACCU + 1 
28a0 : 65 04 __ ADC WORK + 1 
28a2 : 85 1c __ STA ACCU + 1 
28a4 : a5 1d __ LDA ACCU + 2 
28a6 : 65 05 __ ADC WORK + 2 
28a8 : 85 1d __ STA ACCU + 2 
28aa : 90 08 __ BCC $28b4 ; (faddsub + 135)
28ac : 66 1d __ ROR ACCU + 2 
28ae : 66 1c __ ROR ACCU + 1 
28b0 : 66 1b __ ROR ACCU + 0 
28b2 : e6 07 __ INC WORK + 4 
28b4 : a5 07 __ LDA WORK + 4 
28b6 : c9 ff __ CMP #$ff
28b8 : f0 83 __ BEQ $283d ; (faddsub + 16)
28ba : 4a __ __ LSR
28bb : 05 1e __ ORA ACCU + 3 
28bd : 85 1e __ STA ACCU + 3 
28bf : b0 06 __ BCS $28c7 ; (faddsub + 154)
28c1 : a5 1d __ LDA ACCU + 2 
28c3 : 29 7f __ AND #$7f
28c5 : 85 1d __ STA ACCU + 2 
28c7 : 60 __ __ RTS
28c8 : 38 __ __ SEC
28c9 : a5 1b __ LDA ACCU + 0 
28cb : e5 03 __ SBC WORK + 0 
28cd : 85 1b __ STA ACCU + 0 
28cf : a5 1c __ LDA ACCU + 1 
28d1 : e5 04 __ SBC WORK + 1 
28d3 : 85 1c __ STA ACCU + 1 
28d5 : a5 1d __ LDA ACCU + 2 
28d7 : e5 05 __ SBC WORK + 2 
28d9 : 85 1d __ STA ACCU + 2 
28db : b0 19 __ BCS $28f6 ; (faddsub + 201)
28dd : 38 __ __ SEC
28de : a9 00 __ LDA #$00
28e0 : e5 1b __ SBC ACCU + 0 
28e2 : 85 1b __ STA ACCU + 0 
28e4 : a9 00 __ LDA #$00
28e6 : e5 1c __ SBC ACCU + 1 
28e8 : 85 1c __ STA ACCU + 1 
28ea : a9 00 __ LDA #$00
28ec : e5 1d __ SBC ACCU + 2 
28ee : 85 1d __ STA ACCU + 2 
28f0 : a5 1e __ LDA ACCU + 3 
28f2 : 49 80 __ EOR #$80
28f4 : 85 1e __ STA ACCU + 3 
28f6 : a5 1d __ LDA ACCU + 2 
28f8 : 30 ba __ BMI $28b4 ; (faddsub + 135)
28fa : 05 1c __ ORA ACCU + 1 
28fc : 05 1b __ ORA ACCU + 0 
28fe : f0 0f __ BEQ $290f ; (faddsub + 226)
2900 : c6 07 __ DEC WORK + 4 
2902 : f0 0b __ BEQ $290f ; (faddsub + 226)
2904 : 06 1b __ ASL ACCU + 0 
2906 : 26 1c __ ROL ACCU + 1 
2908 : 26 1d __ ROL ACCU + 2 
290a : 10 f4 __ BPL $2900 ; (faddsub + 211)
290c : 4c b4 28 JMP $28b4 ; (faddsub + 135)
290f : a9 00 __ LDA #$00
2911 : 85 1b __ STA ACCU + 0 
2913 : 85 1c __ STA ACCU + 1 
2915 : 85 1d __ STA ACCU + 2 
2917 : 85 1e __ STA ACCU + 3 
2919 : 60 __ __ RTS
--------------------------------------------------------------------
crt_fmul: ; crt_fmul
291a : a5 1b __ LDA ACCU + 0 
291c : 05 1c __ ORA ACCU + 1 
291e : 05 1d __ ORA ACCU + 2 
2920 : f0 0e __ BEQ $2930 ; (crt_fmul + 22)
2922 : a5 03 __ LDA WORK + 0 
2924 : 05 04 __ ORA WORK + 1 
2926 : 05 05 __ ORA WORK + 2 
2928 : d0 09 __ BNE $2933 ; (crt_fmul + 25)
292a : 85 1b __ STA ACCU + 0 
292c : 85 1c __ STA ACCU + 1 
292e : 85 1d __ STA ACCU + 2 
2930 : 85 1e __ STA ACCU + 3 
2932 : 60 __ __ RTS
2933 : a5 1e __ LDA ACCU + 3 
2935 : 45 06 __ EOR WORK + 3 
2937 : 29 80 __ AND #$80
2939 : 85 1e __ STA ACCU + 3 
293b : a9 ff __ LDA #$ff
293d : c5 07 __ CMP WORK + 4 
293f : f0 42 __ BEQ $2983 ; (crt_fmul + 105)
2941 : c5 08 __ CMP WORK + 5 
2943 : f0 3e __ BEQ $2983 ; (crt_fmul + 105)
2945 : a9 00 __ LDA #$00
2947 : 85 09 __ STA WORK + 6 
2949 : 85 0a __ STA WORK + 7 
294b : 85 0b __ STA WORK + 8 
294d : a4 1b __ LDY ACCU + 0 
294f : a5 03 __ LDA WORK + 0 
2951 : d0 06 __ BNE $2959 ; (crt_fmul + 63)
2953 : a5 04 __ LDA WORK + 1 
2955 : f0 0a __ BEQ $2961 ; (crt_fmul + 71)
2957 : d0 05 __ BNE $295e ; (crt_fmul + 68)
2959 : 20 b4 29 JSR $29b4 ; (crt_fmul8 + 0)
295c : a5 04 __ LDA WORK + 1 
295e : 20 b4 29 JSR $29b4 ; (crt_fmul8 + 0)
2961 : a5 05 __ LDA WORK + 2 
2963 : 20 b4 29 JSR $29b4 ; (crt_fmul8 + 0)
2966 : 38 __ __ SEC
2967 : a5 0b __ LDA WORK + 8 
2969 : 30 06 __ BMI $2971 ; (crt_fmul + 87)
296b : 06 09 __ ASL WORK + 6 
296d : 26 0a __ ROL WORK + 7 
296f : 2a __ __ ROL
2970 : 18 __ __ CLC
2971 : 29 7f __ AND #$7f
2973 : 85 0b __ STA WORK + 8 
2975 : a5 07 __ LDA WORK + 4 
2977 : 65 08 __ ADC WORK + 5 
2979 : 90 19 __ BCC $2994 ; (crt_fmul + 122)
297b : e9 7f __ SBC #$7f
297d : b0 04 __ BCS $2983 ; (crt_fmul + 105)
297f : c9 ff __ CMP #$ff
2981 : d0 15 __ BNE $2998 ; (crt_fmul + 126)
2983 : a5 1e __ LDA ACCU + 3 
2985 : 09 7f __ ORA #$7f
2987 : 85 1e __ STA ACCU + 3 
2989 : a9 80 __ LDA #$80
298b : 85 1d __ STA ACCU + 2 
298d : a9 00 __ LDA #$00
298f : 85 1b __ STA ACCU + 0 
2991 : 85 1c __ STA ACCU + 1 
2993 : 60 __ __ RTS
2994 : e9 7e __ SBC #$7e
2996 : 90 15 __ BCC $29ad ; (crt_fmul + 147)
2998 : 4a __ __ LSR
2999 : 05 1e __ ORA ACCU + 3 
299b : 85 1e __ STA ACCU + 3 
299d : a9 00 __ LDA #$00
299f : 6a __ __ ROR
29a0 : 05 0b __ ORA WORK + 8 
29a2 : 85 1d __ STA ACCU + 2 
29a4 : a5 0a __ LDA WORK + 7 
29a6 : 85 1c __ STA ACCU + 1 
29a8 : a5 09 __ LDA WORK + 6 
29aa : 85 1b __ STA ACCU + 0 
29ac : 60 __ __ RTS
29ad : a9 00 __ LDA #$00
29af : 85 1e __ STA ACCU + 3 
29b1 : f0 d8 __ BEQ $298b ; (crt_fmul + 113)
29b3 : 60 __ __ RTS
--------------------------------------------------------------------
crt_fmul8: ; crt_fmul8
29b4 : 38 __ __ SEC
29b5 : 6a __ __ ROR
29b6 : 90 1e __ BCC $29d6 ; (crt_fmul8 + 34)
29b8 : aa __ __ TAX
29b9 : 18 __ __ CLC
29ba : 98 __ __ TYA
29bb : 65 09 __ ADC WORK + 6 
29bd : 85 09 __ STA WORK + 6 
29bf : a5 0a __ LDA WORK + 7 
29c1 : 65 1c __ ADC ACCU + 1 
29c3 : 85 0a __ STA WORK + 7 
29c5 : a5 0b __ LDA WORK + 8 
29c7 : 65 1d __ ADC ACCU + 2 
29c9 : 6a __ __ ROR
29ca : 85 0b __ STA WORK + 8 
29cc : 8a __ __ TXA
29cd : 66 0a __ ROR WORK + 7 
29cf : 66 09 __ ROR WORK + 6 
29d1 : 4a __ __ LSR
29d2 : f0 0d __ BEQ $29e1 ; (crt_fmul8 + 45)
29d4 : b0 e2 __ BCS $29b8 ; (crt_fmul8 + 4)
29d6 : 66 0b __ ROR WORK + 8 
29d8 : 66 0a __ ROR WORK + 7 
29da : 66 09 __ ROR WORK + 6 
29dc : 4a __ __ LSR
29dd : 90 f7 __ BCC $29d6 ; (crt_fmul8 + 34)
29df : d0 d7 __ BNE $29b8 ; (crt_fmul8 + 4)
29e1 : 60 __ __ RTS
--------------------------------------------------------------------
crt_fdiv: ; crt_fdiv
29e2 : a5 1b __ LDA ACCU + 0 
29e4 : 05 1c __ ORA ACCU + 1 
29e6 : 05 1d __ ORA ACCU + 2 
29e8 : d0 03 __ BNE $29ed ; (crt_fdiv + 11)
29ea : 85 1e __ STA ACCU + 3 
29ec : 60 __ __ RTS
29ed : a5 1e __ LDA ACCU + 3 
29ef : 45 06 __ EOR WORK + 3 
29f1 : 29 80 __ AND #$80
29f3 : 85 1e __ STA ACCU + 3 
29f5 : a5 08 __ LDA WORK + 5 
29f7 : f0 62 __ BEQ $2a5b ; (crt_fdiv + 121)
29f9 : a5 07 __ LDA WORK + 4 
29fb : c9 ff __ CMP #$ff
29fd : f0 5c __ BEQ $2a5b ; (crt_fdiv + 121)
29ff : a9 00 __ LDA #$00
2a01 : 85 09 __ STA WORK + 6 
2a03 : 85 0a __ STA WORK + 7 
2a05 : 85 0b __ STA WORK + 8 
2a07 : a2 18 __ LDX #$18
2a09 : a5 1b __ LDA ACCU + 0 
2a0b : c5 03 __ CMP WORK + 0 
2a0d : a5 1c __ LDA ACCU + 1 
2a0f : e5 04 __ SBC WORK + 1 
2a11 : a5 1d __ LDA ACCU + 2 
2a13 : e5 05 __ SBC WORK + 2 
2a15 : 90 13 __ BCC $2a2a ; (crt_fdiv + 72)
2a17 : a5 1b __ LDA ACCU + 0 
2a19 : e5 03 __ SBC WORK + 0 
2a1b : 85 1b __ STA ACCU + 0 
2a1d : a5 1c __ LDA ACCU + 1 
2a1f : e5 04 __ SBC WORK + 1 
2a21 : 85 1c __ STA ACCU + 1 
2a23 : a5 1d __ LDA ACCU + 2 
2a25 : e5 05 __ SBC WORK + 2 
2a27 : 85 1d __ STA ACCU + 2 
2a29 : 38 __ __ SEC
2a2a : 26 09 __ ROL WORK + 6 
2a2c : 26 0a __ ROL WORK + 7 
2a2e : 26 0b __ ROL WORK + 8 
2a30 : ca __ __ DEX
2a31 : f0 0a __ BEQ $2a3d ; (crt_fdiv + 91)
2a33 : 06 1b __ ASL ACCU + 0 
2a35 : 26 1c __ ROL ACCU + 1 
2a37 : 26 1d __ ROL ACCU + 2 
2a39 : b0 dc __ BCS $2a17 ; (crt_fdiv + 53)
2a3b : 90 cc __ BCC $2a09 ; (crt_fdiv + 39)
2a3d : 38 __ __ SEC
2a3e : a5 0b __ LDA WORK + 8 
2a40 : 30 06 __ BMI $2a48 ; (crt_fdiv + 102)
2a42 : 06 09 __ ASL WORK + 6 
2a44 : 26 0a __ ROL WORK + 7 
2a46 : 2a __ __ ROL
2a47 : 18 __ __ CLC
2a48 : 29 7f __ AND #$7f
2a4a : 85 0b __ STA WORK + 8 
2a4c : a5 07 __ LDA WORK + 4 
2a4e : e5 08 __ SBC WORK + 5 
2a50 : 90 1a __ BCC $2a6c ; (crt_fdiv + 138)
2a52 : 18 __ __ CLC
2a53 : 69 7f __ ADC #$7f
2a55 : b0 04 __ BCS $2a5b ; (crt_fdiv + 121)
2a57 : c9 ff __ CMP #$ff
2a59 : d0 15 __ BNE $2a70 ; (crt_fdiv + 142)
2a5b : a5 1e __ LDA ACCU + 3 
2a5d : 09 7f __ ORA #$7f
2a5f : 85 1e __ STA ACCU + 3 
2a61 : a9 80 __ LDA #$80
2a63 : 85 1d __ STA ACCU + 2 
2a65 : a9 00 __ LDA #$00
2a67 : 85 1c __ STA ACCU + 1 
2a69 : 85 1b __ STA ACCU + 0 
2a6b : 60 __ __ RTS
2a6c : 69 7f __ ADC #$7f
2a6e : 90 15 __ BCC $2a85 ; (crt_fdiv + 163)
2a70 : 4a __ __ LSR
2a71 : 05 1e __ ORA ACCU + 3 
2a73 : 85 1e __ STA ACCU + 3 
2a75 : a9 00 __ LDA #$00
2a77 : 6a __ __ ROR
2a78 : 05 0b __ ORA WORK + 8 
2a7a : 85 1d __ STA ACCU + 2 
2a7c : a5 0a __ LDA WORK + 7 
2a7e : 85 1c __ STA ACCU + 1 
2a80 : a5 09 __ LDA WORK + 6 
2a82 : 85 1b __ STA ACCU + 0 
2a84 : 60 __ __ RTS
2a85 : a9 00 __ LDA #$00
2a87 : 85 1e __ STA ACCU + 3 
2a89 : 85 1d __ STA ACCU + 2 
2a8b : 85 1c __ STA ACCU + 1 
2a8d : 85 1b __ STA ACCU + 0 
2a8f : 60 __ __ RTS
--------------------------------------------------------------------
divs16: ; divs16
2a90 : 24 1c __ BIT ACCU + 1 
2a92 : 10 0d __ BPL $2aa1 ; (divs16 + 17)
2a94 : 20 ab 2a JSR $2aab ; (negaccu + 0)
2a97 : 24 04 __ BIT WORK + 1 
2a99 : 10 0d __ BPL $2aa8 ; (divs16 + 24)
2a9b : 20 b9 2a JSR $2ab9 ; (negtmp + 0)
2a9e : 4c c7 2a JMP $2ac7 ; (divmod + 0)
2aa1 : 24 04 __ BIT WORK + 1 
2aa3 : 10 f9 __ BPL $2a9e ; (divs16 + 14)
2aa5 : 20 b9 2a JSR $2ab9 ; (negtmp + 0)
2aa8 : 20 c7 2a JSR $2ac7 ; (divmod + 0)
--------------------------------------------------------------------
negaccu: ; negaccu
2aab : 38 __ __ SEC
2aac : a9 00 __ LDA #$00
2aae : e5 1b __ SBC ACCU + 0 
2ab0 : 85 1b __ STA ACCU + 0 
2ab2 : a9 00 __ LDA #$00
2ab4 : e5 1c __ SBC ACCU + 1 
2ab6 : 85 1c __ STA ACCU + 1 
2ab8 : 60 __ __ RTS
--------------------------------------------------------------------
negtmp: ; negtmp
2ab9 : 38 __ __ SEC
2aba : a9 00 __ LDA #$00
2abc : e5 03 __ SBC WORK + 0 
2abe : 85 03 __ STA WORK + 0 
2ac0 : a9 00 __ LDA #$00
2ac2 : e5 04 __ SBC WORK + 1 
2ac4 : 85 04 __ STA WORK + 1 
2ac6 : 60 __ __ RTS
--------------------------------------------------------------------
divmod: ; divmod
2ac7 : a5 1c __ LDA ACCU + 1 
2ac9 : d0 31 __ BNE $2afc ; (divmod + 53)
2acb : a5 04 __ LDA WORK + 1 
2acd : d0 1e __ BNE $2aed ; (divmod + 38)
2acf : 85 06 __ STA WORK + 3 
2ad1 : a2 04 __ LDX #$04
2ad3 : 06 1b __ ASL ACCU + 0 
2ad5 : 2a __ __ ROL
2ad6 : c5 03 __ CMP WORK + 0 
2ad8 : 90 02 __ BCC $2adc ; (divmod + 21)
2ada : e5 03 __ SBC WORK + 0 
2adc : 26 1b __ ROL ACCU + 0 
2ade : 2a __ __ ROL
2adf : c5 03 __ CMP WORK + 0 
2ae1 : 90 02 __ BCC $2ae5 ; (divmod + 30)
2ae3 : e5 03 __ SBC WORK + 0 
2ae5 : 26 1b __ ROL ACCU + 0 
2ae7 : ca __ __ DEX
2ae8 : d0 eb __ BNE $2ad5 ; (divmod + 14)
2aea : 85 05 __ STA WORK + 2 
2aec : 60 __ __ RTS
2aed : a5 1b __ LDA ACCU + 0 
2aef : 85 05 __ STA WORK + 2 
2af1 : a5 1c __ LDA ACCU + 1 
2af3 : 85 06 __ STA WORK + 3 
2af5 : a9 00 __ LDA #$00
2af7 : 85 1b __ STA ACCU + 0 
2af9 : 85 1c __ STA ACCU + 1 
2afb : 60 __ __ RTS
2afc : a5 04 __ LDA WORK + 1 
2afe : d0 1f __ BNE $2b1f ; (divmod + 88)
2b00 : a5 03 __ LDA WORK + 0 
2b02 : 30 1b __ BMI $2b1f ; (divmod + 88)
2b04 : a9 00 __ LDA #$00
2b06 : 85 06 __ STA WORK + 3 
2b08 : a2 10 __ LDX #$10
2b0a : 06 1b __ ASL ACCU + 0 
2b0c : 26 1c __ ROL ACCU + 1 
2b0e : 2a __ __ ROL
2b0f : c5 03 __ CMP WORK + 0 
2b11 : 90 02 __ BCC $2b15 ; (divmod + 78)
2b13 : e5 03 __ SBC WORK + 0 
2b15 : 26 1b __ ROL ACCU + 0 
2b17 : 26 1c __ ROL ACCU + 1 
2b19 : ca __ __ DEX
2b1a : d0 f2 __ BNE $2b0e ; (divmod + 71)
2b1c : 85 05 __ STA WORK + 2 
2b1e : 60 __ __ RTS
2b1f : a9 00 __ LDA #$00
2b21 : 85 05 __ STA WORK + 2 
2b23 : 85 06 __ STA WORK + 3 
2b25 : 84 02 __ STY $02 
2b27 : a0 10 __ LDY #$10
2b29 : 18 __ __ CLC
2b2a : 26 1b __ ROL ACCU + 0 
2b2c : 26 1c __ ROL ACCU + 1 
2b2e : 26 05 __ ROL WORK + 2 
2b30 : 26 06 __ ROL WORK + 3 
2b32 : 38 __ __ SEC
2b33 : a5 05 __ LDA WORK + 2 
2b35 : e5 03 __ SBC WORK + 0 
2b37 : aa __ __ TAX
2b38 : a5 06 __ LDA WORK + 3 
2b3a : e5 04 __ SBC WORK + 1 
2b3c : 90 04 __ BCC $2b42 ; (divmod + 123)
2b3e : 86 05 __ STX WORK + 2 
2b40 : 85 06 __ STA WORK + 3 
2b42 : 88 __ __ DEY
2b43 : d0 e5 __ BNE $2b2a ; (divmod + 99)
2b45 : 26 1b __ ROL ACCU + 0 
2b47 : 26 1c __ ROL ACCU + 1 
2b49 : a4 02 __ LDY $02 
2b4b : 60 __ __ RTS
--------------------------------------------------------------------
mods16: ; mods16
2b4c : 24 1c __ BIT ACCU + 1 
2b4e : 10 10 __ BPL $2b60 ; (mods16 + 20)
2b50 : 20 ab 2a JSR $2aab ; (negaccu + 0)
2b53 : 24 04 __ BIT WORK + 1 
2b55 : 10 03 __ BPL $2b5a ; (mods16 + 14)
2b57 : 20 b9 2a JSR $2ab9 ; (negtmp + 0)
2b5a : 20 c7 2a JSR $2ac7 ; (divmod + 0)
2b5d : 4c 95 2b JMP $2b95 ; (negtmpb + 0)
2b60 : 24 04 __ BIT WORK + 1 
2b62 : 10 03 __ BPL $2b67 ; (mods16 + 27)
2b64 : 20 b9 2a JSR $2ab9 ; (negtmp + 0)
2b67 : 4c c7 2a JMP $2ac7 ; (divmod + 0)
2b6a : 60 __ __ RTS
--------------------------------------------------------------------
negtmpb: ; negtmpb
2b95 : 38 __ __ SEC
2b96 : a9 00 __ LDA #$00
2b98 : e5 05 __ SBC WORK + 2 
2b9a : 85 05 __ STA WORK + 2 
2b9c : a9 00 __ LDA #$00
2b9e : e5 06 __ SBC WORK + 3 
2ba0 : 85 06 __ STA WORK + 3 
2ba2 : 60 __ __ RTS
--------------------------------------------------------------------
f32_to_i16: ; f32_to_i16
2ba3 : 20 0c 28 JSR $280c ; (freg + 36)
2ba6 : a5 07 __ LDA WORK + 4 
2ba8 : c9 7f __ CMP #$7f
2baa : b0 07 __ BCS $2bb3 ; (f32_to_i16 + 16)
2bac : a9 00 __ LDA #$00
2bae : 85 1b __ STA ACCU + 0 
2bb0 : 85 1c __ STA ACCU + 1 
2bb2 : 60 __ __ RTS
2bb3 : e9 8e __ SBC #$8e
2bb5 : 90 16 __ BCC $2bcd ; (f32_to_i16 + 42)
2bb7 : 24 1e __ BIT ACCU + 3 
2bb9 : 30 09 __ BMI $2bc4 ; (f32_to_i16 + 33)
2bbb : a9 ff __ LDA #$ff
2bbd : 85 1b __ STA ACCU + 0 
2bbf : a9 7f __ LDA #$7f
2bc1 : 85 1c __ STA ACCU + 1 
2bc3 : 60 __ __ RTS
2bc4 : a9 00 __ LDA #$00
2bc6 : 85 1b __ STA ACCU + 0 
2bc8 : a9 80 __ LDA #$80
2bca : 85 1c __ STA ACCU + 1 
2bcc : 60 __ __ RTS
2bcd : aa __ __ TAX
2bce : a5 1c __ LDA ACCU + 1 
2bd0 : 46 1d __ LSR ACCU + 2 
2bd2 : 6a __ __ ROR
2bd3 : e8 __ __ INX
2bd4 : d0 fa __ BNE $2bd0 ; (f32_to_i16 + 45)
2bd6 : 24 1e __ BIT ACCU + 3 
2bd8 : 10 0e __ BPL $2be8 ; (f32_to_i16 + 69)
2bda : 38 __ __ SEC
2bdb : 49 ff __ EOR #$ff
2bdd : 69 00 __ ADC #$00
2bdf : 85 1b __ STA ACCU + 0 
2be1 : a9 00 __ LDA #$00
2be3 : e5 1d __ SBC ACCU + 2 
2be5 : 85 1c __ STA ACCU + 1 
2be7 : 60 __ __ RTS
2be8 : 85 1b __ STA ACCU + 0 
2bea : a5 1d __ LDA ACCU + 2 
2bec : 85 1c __ STA ACCU + 1 
2bee : 60 __ __ RTS
--------------------------------------------------------------------
sint16_to_float: ; sint16_to_float
2bef : 24 1c __ BIT ACCU + 1 
2bf1 : 30 03 __ BMI $2bf6 ; (sint16_to_float + 7)
2bf3 : 4c 0d 2c JMP $2c0d ; (uint16_to_float + 0)
2bf6 : 38 __ __ SEC
2bf7 : a9 00 __ LDA #$00
2bf9 : e5 1b __ SBC ACCU + 0 
2bfb : 85 1b __ STA ACCU + 0 
2bfd : a9 00 __ LDA #$00
2bff : e5 1c __ SBC ACCU + 1 
2c01 : 85 1c __ STA ACCU + 1 
2c03 : 20 0d 2c JSR $2c0d ; (uint16_to_float + 0)
2c06 : a5 1e __ LDA ACCU + 3 
2c08 : 09 80 __ ORA #$80
2c0a : 85 1e __ STA ACCU + 3 
2c0c : 60 __ __ RTS
--------------------------------------------------------------------
uint16_to_float: ; uint16_to_float
2c0d : a5 1b __ LDA ACCU + 0 
2c0f : 05 1c __ ORA ACCU + 1 
2c11 : d0 05 __ BNE $2c18 ; (uint16_to_float + 11)
2c13 : 85 1d __ STA ACCU + 2 
2c15 : 85 1e __ STA ACCU + 3 
2c17 : 60 __ __ RTS
2c18 : a2 8e __ LDX #$8e
2c1a : a5 1c __ LDA ACCU + 1 
2c1c : 30 06 __ BMI $2c24 ; (uint16_to_float + 23)
2c1e : ca __ __ DEX
2c1f : 06 1b __ ASL ACCU + 0 
2c21 : 2a __ __ ROL
2c22 : 10 fa __ BPL $2c1e ; (uint16_to_float + 17)
2c24 : 0a __ __ ASL
2c25 : 85 1d __ STA ACCU + 2 
2c27 : a5 1b __ LDA ACCU + 0 
2c29 : 85 1c __ STA ACCU + 1 
2c2b : 8a __ __ TXA
2c2c : 4a __ __ LSR
2c2d : 85 1e __ STA ACCU + 3 
2c2f : a9 00 __ LDA #$00
2c31 : 85 1b __ STA ACCU + 0 
2c33 : 66 1d __ ROR ACCU + 2 
2c35 : 60 __ __ RTS
--------------------------------------------------------------------
divmod32: ; divmod32
2c54 : 84 02 __ STY $02 
2c56 : a0 20 __ LDY #$20
2c58 : a9 00 __ LDA #$00
2c5a : 85 07 __ STA WORK + 4 
2c5c : 85 08 __ STA WORK + 5 
2c5e : 85 09 __ STA WORK + 6 
2c60 : 85 0a __ STA WORK + 7 
2c62 : a5 05 __ LDA WORK + 2 
2c64 : 05 06 __ ORA WORK + 3 
2c66 : d0 78 __ BNE $2ce0 ; (divmod32 + 140)
2c68 : a5 04 __ LDA WORK + 1 
2c6a : d0 27 __ BNE $2c93 ; (divmod32 + 63)
2c6c : 18 __ __ CLC
2c6d : 26 1b __ ROL ACCU + 0 
2c6f : 26 1c __ ROL ACCU + 1 
2c71 : 26 1d __ ROL ACCU + 2 
2c73 : 26 1e __ ROL ACCU + 3 
2c75 : 2a __ __ ROL
2c76 : 90 05 __ BCC $2c7d ; (divmod32 + 41)
2c78 : e5 03 __ SBC WORK + 0 
2c7a : 38 __ __ SEC
2c7b : b0 06 __ BCS $2c83 ; (divmod32 + 47)
2c7d : c5 03 __ CMP WORK + 0 
2c7f : 90 02 __ BCC $2c83 ; (divmod32 + 47)
2c81 : e5 03 __ SBC WORK + 0 
2c83 : 88 __ __ DEY
2c84 : d0 e7 __ BNE $2c6d ; (divmod32 + 25)
2c86 : 85 07 __ STA WORK + 4 
2c88 : 26 1b __ ROL ACCU + 0 
2c8a : 26 1c __ ROL ACCU + 1 
2c8c : 26 1d __ ROL ACCU + 2 
2c8e : 26 1e __ ROL ACCU + 3 
2c90 : a4 02 __ LDY $02 
2c92 : 60 __ __ RTS
2c93 : a5 1e __ LDA ACCU + 3 
2c95 : d0 10 __ BNE $2ca7 ; (divmod32 + 83)
2c97 : a6 1d __ LDX ACCU + 2 
2c99 : 86 1e __ STX ACCU + 3 
2c9b : a6 1c __ LDX ACCU + 1 
2c9d : 86 1d __ STX ACCU + 2 
2c9f : a6 1b __ LDX ACCU + 0 
2ca1 : 86 1c __ STX ACCU + 1 
2ca3 : 85 1b __ STA ACCU + 0 
2ca5 : a0 18 __ LDY #$18
2ca7 : 18 __ __ CLC
2ca8 : 26 1b __ ROL ACCU + 0 
2caa : 26 1c __ ROL ACCU + 1 
2cac : 26 1d __ ROL ACCU + 2 
2cae : 26 1e __ ROL ACCU + 3 
2cb0 : 26 07 __ ROL WORK + 4 
2cb2 : 26 08 __ ROL WORK + 5 
2cb4 : 90 0c __ BCC $2cc2 ; (divmod32 + 110)
2cb6 : a5 07 __ LDA WORK + 4 
2cb8 : e5 03 __ SBC WORK + 0 
2cba : aa __ __ TAX
2cbb : a5 08 __ LDA WORK + 5 
2cbd : e5 04 __ SBC WORK + 1 
2cbf : 38 __ __ SEC
2cc0 : b0 0c __ BCS $2cce ; (divmod32 + 122)
2cc2 : 38 __ __ SEC
2cc3 : a5 07 __ LDA WORK + 4 
2cc5 : e5 03 __ SBC WORK + 0 
2cc7 : aa __ __ TAX
2cc8 : a5 08 __ LDA WORK + 5 
2cca : e5 04 __ SBC WORK + 1 
2ccc : 90 04 __ BCC $2cd2 ; (divmod32 + 126)
2cce : 86 07 __ STX WORK + 4 
2cd0 : 85 08 __ STA WORK + 5 
2cd2 : 88 __ __ DEY
2cd3 : d0 d3 __ BNE $2ca8 ; (divmod32 + 84)
2cd5 : 26 1b __ ROL ACCU + 0 
2cd7 : 26 1c __ ROL ACCU + 1 
2cd9 : 26 1d __ ROL ACCU + 2 
2cdb : 26 1e __ ROL ACCU + 3 
2cdd : a4 02 __ LDY $02 
2cdf : 60 __ __ RTS
2ce0 : a0 10 __ LDY #$10
2ce2 : a5 1e __ LDA ACCU + 3 
2ce4 : 85 08 __ STA WORK + 5 
2ce6 : a5 1d __ LDA ACCU + 2 
2ce8 : 85 07 __ STA WORK + 4 
2cea : a9 00 __ LDA #$00
2cec : 85 1d __ STA ACCU + 2 
2cee : 85 1e __ STA ACCU + 3 
2cf0 : 18 __ __ CLC
2cf1 : 26 1b __ ROL ACCU + 0 
2cf3 : 26 1c __ ROL ACCU + 1 
2cf5 : 26 07 __ ROL WORK + 4 
2cf7 : 26 08 __ ROL WORK + 5 
2cf9 : 26 09 __ ROL WORK + 6 
2cfb : 26 0a __ ROL WORK + 7 
2cfd : a5 07 __ LDA WORK + 4 
2cff : c5 03 __ CMP WORK + 0 
2d01 : a5 08 __ LDA WORK + 5 
2d03 : e5 04 __ SBC WORK + 1 
2d05 : a5 09 __ LDA WORK + 6 
2d07 : e5 05 __ SBC WORK + 2 
2d09 : aa __ __ TAX
2d0a : a5 0a __ LDA WORK + 7 
2d0c : e5 06 __ SBC WORK + 3 
2d0e : 90 11 __ BCC $2d21 ; (divmod32 + 205)
2d10 : 86 09 __ STX WORK + 6 
2d12 : 85 0a __ STA WORK + 7 
2d14 : a5 07 __ LDA WORK + 4 
2d16 : e5 03 __ SBC WORK + 0 
2d18 : 85 07 __ STA WORK + 4 
2d1a : a5 08 __ LDA WORK + 5 
2d1c : e5 04 __ SBC WORK + 1 
2d1e : 85 08 __ STA WORK + 5 
2d20 : 38 __ __ SEC
2d21 : 88 __ __ DEY
2d22 : d0 cd __ BNE $2cf1 ; (divmod32 + 157)
2d24 : 26 1b __ ROL ACCU + 0 
2d26 : 26 1c __ ROL ACCU + 1 
2d28 : a4 02 __ LDY $02 
2d2a : 60 __ __ RTS
--------------------------------------------------------------------
crt_malloc: ; crt_malloc
2d2b : 18 __ __ CLC
2d2c : a5 1b __ LDA ACCU + 0 
2d2e : 69 05 __ ADC #$05
2d30 : 29 fc __ AND #$fc
2d32 : 85 03 __ STA WORK + 0 
2d34 : a5 1c __ LDA ACCU + 1 
2d36 : 69 00 __ ADC #$00
2d38 : 85 04 __ STA WORK + 1 
2d3a : ad f4 36 LDA $36f4 ; (HeapNode.end + 0)
2d3d : d0 26 __ BNE $2d65 ; (crt_malloc + 58)
2d3f : a9 00 __ LDA #$00
2d41 : 8d 22 3b STA $3b22 
2d44 : 8d 23 3b STA $3b23 
2d47 : ee f4 36 INC $36f4 ; (HeapNode.end + 0)
2d4a : a9 20 __ LDA #$20
2d4c : 09 02 __ ORA #$02
2d4e : 8d f2 36 STA $36f2 ; (HeapNode.next + 0)
2d51 : a9 3b __ LDA #$3b
2d53 : 8d f3 36 STA $36f3 ; (HeapNode.next + 1)
2d56 : 38 __ __ SEC
2d57 : a9 00 __ LDA #$00
2d59 : e9 02 __ SBC #$02
2d5b : 8d 24 3b STA $3b24 
2d5e : a9 90 __ LDA #$90
2d60 : e9 00 __ SBC #$00
2d62 : 8d 25 3b STA $3b25 
2d65 : a9 f2 __ LDA #$f2
2d67 : a2 36 __ LDX #$36
2d69 : 85 1d __ STA ACCU + 2 
2d6b : 86 1e __ STX ACCU + 3 
2d6d : 18 __ __ CLC
2d6e : a0 00 __ LDY #$00
2d70 : b1 1d __ LDA (ACCU + 2),y 
2d72 : 85 1b __ STA ACCU + 0 
2d74 : 65 03 __ ADC WORK + 0 
2d76 : 85 05 __ STA WORK + 2 
2d78 : c8 __ __ INY
2d79 : b1 1d __ LDA (ACCU + 2),y 
2d7b : 85 1c __ STA ACCU + 1 
2d7d : f0 20 __ BEQ $2d9f ; (crt_malloc + 116)
2d7f : 65 04 __ ADC WORK + 1 
2d81 : 85 06 __ STA WORK + 3 
2d83 : b0 14 __ BCS $2d99 ; (crt_malloc + 110)
2d85 : a0 02 __ LDY #$02
2d87 : b1 1b __ LDA (ACCU + 0),y 
2d89 : c5 05 __ CMP WORK + 2 
2d8b : c8 __ __ INY
2d8c : b1 1b __ LDA (ACCU + 0),y 
2d8e : e5 06 __ SBC WORK + 3 
2d90 : b0 0e __ BCS $2da0 ; (crt_malloc + 117)
2d92 : a5 1b __ LDA ACCU + 0 
2d94 : a6 1c __ LDX ACCU + 1 
2d96 : 4c 69 2d JMP $2d69 ; (crt_malloc + 62)
2d99 : a9 00 __ LDA #$00
2d9b : 85 1b __ STA ACCU + 0 
2d9d : 85 1c __ STA ACCU + 1 
2d9f : 60 __ __ RTS
2da0 : a5 05 __ LDA WORK + 2 
2da2 : 85 07 __ STA WORK + 4 
2da4 : a5 06 __ LDA WORK + 3 
2da6 : 85 08 __ STA WORK + 5 
2da8 : a0 02 __ LDY #$02
2daa : a5 07 __ LDA WORK + 4 
2dac : d1 1b __ CMP (ACCU + 0),y 
2dae : d0 15 __ BNE $2dc5 ; (crt_malloc + 154)
2db0 : c8 __ __ INY
2db1 : a5 08 __ LDA WORK + 5 
2db3 : d1 1b __ CMP (ACCU + 0),y 
2db5 : d0 0e __ BNE $2dc5 ; (crt_malloc + 154)
2db7 : a0 00 __ LDY #$00
2db9 : b1 1b __ LDA (ACCU + 0),y 
2dbb : 91 1d __ STA (ACCU + 2),y 
2dbd : c8 __ __ INY
2dbe : b1 1b __ LDA (ACCU + 0),y 
2dc0 : 91 1d __ STA (ACCU + 2),y 
2dc2 : 4c e2 2d JMP $2de2 ; (crt_malloc + 183)
2dc5 : a0 00 __ LDY #$00
2dc7 : b1 1b __ LDA (ACCU + 0),y 
2dc9 : 91 07 __ STA (WORK + 4),y 
2dcb : a5 07 __ LDA WORK + 4 
2dcd : 91 1d __ STA (ACCU + 2),y 
2dcf : c8 __ __ INY
2dd0 : b1 1b __ LDA (ACCU + 0),y 
2dd2 : 91 07 __ STA (WORK + 4),y 
2dd4 : a5 08 __ LDA WORK + 5 
2dd6 : 91 1d __ STA (ACCU + 2),y 
2dd8 : c8 __ __ INY
2dd9 : b1 1b __ LDA (ACCU + 0),y 
2ddb : 91 07 __ STA (WORK + 4),y 
2ddd : c8 __ __ INY
2dde : b1 1b __ LDA (ACCU + 0),y 
2de0 : 91 07 __ STA (WORK + 4),y 
2de2 : a0 00 __ LDY #$00
2de4 : a5 05 __ LDA WORK + 2 
2de6 : 91 1b __ STA (ACCU + 0),y 
2de8 : c8 __ __ INY
2de9 : a5 06 __ LDA WORK + 3 
2deb : 91 1b __ STA (ACCU + 0),y 
2ded : 18 __ __ CLC
2dee : a5 1b __ LDA ACCU + 0 
2df0 : 69 02 __ ADC #$02
2df2 : 85 1b __ STA ACCU + 0 
2df4 : 90 02 __ BCC $2df8 ; (crt_malloc + 205)
2df6 : e6 1c __ INC ACCU + 1 
2df8 : 60 __ __ RTS
--------------------------------------------------------------------
crt_free@proxy: ; crt_free@proxy
2df9 : a5 0d __ LDA P0 
2dfb : 85 1b __ STA ACCU + 0 
2dfd : a5 0e __ LDA P1 
2dff : 85 1c __ STA ACCU + 1 
--------------------------------------------------------------------
crt_free: ; crt_free
2e01 : a5 1b __ LDA ACCU + 0 
2e03 : 05 1c __ ORA ACCU + 1 
2e05 : d0 01 __ BNE $2e08 ; (crt_free + 7)
2e07 : 60 __ __ RTS
2e08 : 38 __ __ SEC
2e09 : a5 1b __ LDA ACCU + 0 
2e0b : e9 02 __ SBC #$02
2e0d : 85 1b __ STA ACCU + 0 
2e0f : b0 02 __ BCS $2e13 ; (crt_free + 18)
2e11 : c6 1c __ DEC ACCU + 1 
2e13 : a0 00 __ LDY #$00
2e15 : b1 1b __ LDA (ACCU + 0),y 
2e17 : 85 1d __ STA ACCU + 2 
2e19 : c8 __ __ INY
2e1a : b1 1b __ LDA (ACCU + 0),y 
2e1c : 85 1e __ STA ACCU + 3 
2e1e : a9 f2 __ LDA #$f2
2e20 : a2 36 __ LDX #$36
2e22 : 85 05 __ STA WORK + 2 
2e24 : 86 06 __ STX WORK + 3 
2e26 : a0 01 __ LDY #$01
2e28 : b1 05 __ LDA (WORK + 2),y 
2e2a : f0 28 __ BEQ $2e54 ; (crt_free + 83)
2e2c : aa __ __ TAX
2e2d : 88 __ __ DEY
2e2e : b1 05 __ LDA (WORK + 2),y 
2e30 : e4 1e __ CPX ACCU + 3 
2e32 : 90 ee __ BCC $2e22 ; (crt_free + 33)
2e34 : d0 1e __ BNE $2e54 ; (crt_free + 83)
2e36 : c5 1d __ CMP ACCU + 2 
2e38 : 90 e8 __ BCC $2e22 ; (crt_free + 33)
2e3a : d0 18 __ BNE $2e54 ; (crt_free + 83)
2e3c : a0 00 __ LDY #$00
2e3e : b1 1d __ LDA (ACCU + 2),y 
2e40 : 91 1b __ STA (ACCU + 0),y 
2e42 : c8 __ __ INY
2e43 : b1 1d __ LDA (ACCU + 2),y 
2e45 : 91 1b __ STA (ACCU + 0),y 
2e47 : c8 __ __ INY
2e48 : b1 1d __ LDA (ACCU + 2),y 
2e4a : 91 1b __ STA (ACCU + 0),y 
2e4c : c8 __ __ INY
2e4d : b1 1d __ LDA (ACCU + 2),y 
2e4f : 91 1b __ STA (ACCU + 0),y 
2e51 : 4c 69 2e JMP $2e69 ; (crt_free + 104)
2e54 : a0 00 __ LDY #$00
2e56 : b1 05 __ LDA (WORK + 2),y 
2e58 : 91 1b __ STA (ACCU + 0),y 
2e5a : c8 __ __ INY
2e5b : b1 05 __ LDA (WORK + 2),y 
2e5d : 91 1b __ STA (ACCU + 0),y 
2e5f : c8 __ __ INY
2e60 : a5 1d __ LDA ACCU + 2 
2e62 : 91 1b __ STA (ACCU + 0),y 
2e64 : c8 __ __ INY
2e65 : a5 1e __ LDA ACCU + 3 
2e67 : 91 1b __ STA (ACCU + 0),y 
2e69 : a0 02 __ LDY #$02
2e6b : b1 05 __ LDA (WORK + 2),y 
2e6d : c5 1b __ CMP ACCU + 0 
2e6f : d0 1d __ BNE $2e8e ; (crt_free + 141)
2e71 : c8 __ __ INY
2e72 : b1 05 __ LDA (WORK + 2),y 
2e74 : c5 1c __ CMP ACCU + 1 
2e76 : d0 16 __ BNE $2e8e ; (crt_free + 141)
2e78 : a0 00 __ LDY #$00
2e7a : b1 1b __ LDA (ACCU + 0),y 
2e7c : 91 05 __ STA (WORK + 2),y 
2e7e : c8 __ __ INY
2e7f : b1 1b __ LDA (ACCU + 0),y 
2e81 : 91 05 __ STA (WORK + 2),y 
2e83 : c8 __ __ INY
2e84 : b1 1b __ LDA (ACCU + 0),y 
2e86 : 91 05 __ STA (WORK + 2),y 
2e88 : c8 __ __ INY
2e89 : b1 1b __ LDA (ACCU + 0),y 
2e8b : 91 05 __ STA (WORK + 2),y 
2e8d : 60 __ __ RTS
2e8e : a0 00 __ LDY #$00
2e90 : a5 1b __ LDA ACCU + 0 
2e92 : 91 05 __ STA (WORK + 2),y 
2e94 : c8 __ __ INY
2e95 : a5 1c __ LDA ACCU + 1 
2e97 : 91 05 __ STA (WORK + 2),y 
2e99 : 60 __ __ RTS
--------------------------------------------------------------------
freg@proxy: ; freg@proxy
2e9a : a9 20 __ LDA #$20
2e9c : 85 05 __ STA WORK + 2 
2e9e : a9 41 __ LDA #$41
2ea0 : 85 06 __ STA WORK + 3 
2ea2 : 4c fc 27 JMP $27fc ; (freg + 20)
--------------------------------------------------------------------
freg@proxy: ; freg@proxy
2ea5 : a5 43 __ LDA $43 
2ea7 : 85 1b __ STA ACCU + 0 
2ea9 : a5 44 __ LDA $44 
2eab : 85 1c __ STA ACCU + 1 
2ead : a5 45 __ LDA $45 
2eaf : 85 1d __ STA ACCU + 2 
2eb1 : a5 46 __ LDA $46 
2eb3 : 85 1e __ STA ACCU + 3 
2eb5 : 4c ec 27 JMP $27ec ; (freg + 4)
--------------------------------------------------------------------
strchr@proxy: ; strchr@proxy
2eb8 : a9 03 __ LDA #$03
2eba : 85 0d __ STA P0 
2ebc : a9 38 __ LDA #$38
2ebe : 85 0e __ STA P1 
2ec0 : a9 20 __ LDA #$20
2ec2 : 85 0f __ STA P2 
2ec4 : a9 00 __ LDA #$00
2ec6 : 85 10 __ STA P3 
2ec8 : 4c 86 14 JMP $1486 ; (strchr.l4 + 0)
--------------------------------------------------------------------
atoi@proxy: ; atoi@proxy
2ecb : a9 00 __ LDA #$00
2ecd : 85 0d __ STA P0 
2ecf : a9 38 __ LDA #$38
2ed1 : 85 0e __ STA P1 
2ed3 : 4c cc 13 JMP $13cc ; (atoi.l4 + 0)
--------------------------------------------------------------------
uci_socket_write@proxy: ; uci_socket_write@proxy
2ed6 : ad f4 2e LDA $2ef4 ; (socket_id + 0)
2ed9 : 85 11 __ STA P4 
2edb : 4c 22 13 JMP $1322 ; (uci_socket_write.s4 + 0)
--------------------------------------------------------------------
print_at@proxy: ; print_at@proxy
2ede : a9 00 __ LDA #$00
2ee0 : 85 0d __ STA P0 
2ee2 : a9 04 __ LDA #$04
2ee4 : 85 0e __ STA P1 
2ee6 : 4c d7 0c JMP $0cd7 ; (print_at.s4 + 0)
--------------------------------------------------------------------
print_at@proxy: ; print_at@proxy
2ee9 : a9 00 __ LDA #$00
2eeb : 85 0d __ STA P0 
2eed : 4c d7 0c JMP $0cd7 ; (print_at.s4 + 0)
--------------------------------------------------------------------
uci_data_index:
2ef0 : __ __ __ BYT 00 00                                           : ..
--------------------------------------------------------------------
uci_data_len:
2ef2 : __ __ __ BYT 00 00                                           : ..
--------------------------------------------------------------------
socket_id:
2ef4 : __ __ __ BYT 00                                              : .
--------------------------------------------------------------------
connected:
2ef5 : __ __ __ BYT 00                                              : .
--------------------------------------------------------------------
item_count:
2ef6 : __ __ __ BYT 00 00                                           : ..
--------------------------------------------------------------------
total_count:
2ef8 : __ __ __ BYT 00 00                                           : ..
--------------------------------------------------------------------
cursor:
2efa : __ __ __ BYT 00 00                                           : ..
--------------------------------------------------------------------
offset:
2efc : __ __ __ BYT 00 00                                           : ..
--------------------------------------------------------------------
current_page:
2efe : __ __ __ BYT 00 00                                           : ..
--------------------------------------------------------------------
search_query_len:
2f00 : __ __ __ BYT 00 00                                           : ..
--------------------------------------------------------------------
fround5:
2f02 : __ __ __ BYT 00 00 00 3f cd cc 4c 3d 0a d7 a3 3b 6f 12 03 3a : ...?..L=...;o..:
2f12 : __ __ __ BYT 17 b7 51 38 ac c5 a7 36 bd 37 06 35             : ..Q8...6.7.5
--------------------------------------------------------------------
keyb_codes:
2f1e : __ __ __ BYT 14 0d 1d 88 85 86 87 11 33 77 61 34 7a 73 65 00 : ........3wa4zse.
2f2e : __ __ __ BYT 35 72 64 36 63 66 74 78 37 79 67 38 62 68 75 76 : 5rd6cftx7yg8bhuv
2f3e : __ __ __ BYT 39 69 6a 30 6d 6b 6f 6e 2b 70 6c 2d 2e 3a 40 2c : 9ij0mkon+pl-.:@,
2f4e : __ __ __ BYT 00 2a 3b 13 00 3d 5e 2f 31 5f 00 32 20 00 71 1b : .*;..=^/1_.2 .q.
2f5e : __ __ __ BYT 94 0d 9d 8c 89 8a 8b 91 23 57 41 24 5a 53 45 00 : ........#WA$ZSE.
2f6e : __ __ __ BYT 25 52 44 26 43 46 54 58 27 59 47 28 42 48 55 56 : %RD&CFTX'YG(BHUV
2f7e : __ __ __ BYT 29 49 4a 30 4d 4b 4f 4e 00 50 4c 00 3e 5b 40 3c : )IJ0MKON.PL.>[@<
2f8e : __ __ __ BYT 00 00 5d 93 00 00 5e 3f 21 00 00 22 20 00 51 1b : ..]...^?!.." .Q.
--------------------------------------------------------------------
uci_data:
2f9e : __ __ __ BSS	1792
--------------------------------------------------------------------
keyb_key:
369e : __ __ __ BSS	1
--------------------------------------------------------------------
keyb_matrix:
369f : __ __ __ BSS	8
--------------------------------------------------------------------
ciaa_pra_def:
36a7 : __ __ __ BSS	1
--------------------------------------------------------------------
temp_char:
36a8 : __ __ __ BSS	2
--------------------------------------------------------------------
item_ids:
36aa : __ __ __ BSS	40
--------------------------------------------------------------------
search_query:
36d2 : __ __ __ BSS	32
--------------------------------------------------------------------
HeapNode:
36f2 : __ __ __ BSS	4
--------------------------------------------------------------------
uci_status:
3700 : __ __ __ BSS	256
--------------------------------------------------------------------
line_buffer:
3800 : __ __ __ BSS	128
--------------------------------------------------------------------
item_names:
3880 : __ __ __ BSS	640
--------------------------------------------------------------------
current_category:
3b00 : __ __ __ BSS	32
