SECTION code_user

PUBLIC _oled_init
PUBLIC _oled_normal
PUBLIC _oled_invert
PUBLIC _oled_test
PUBLIC _oled_clear
PUBLIC _oled_set_full_screen
PUBLIC _oled_draw_image

reset:
    LD C,0x50
    LD B,0x06
    OUT (C),A
    NOP
    NOP
    NOP
    NOP

    RES 2,B
    OUT (C),A

    NOP
    NOP
    NOP
    NOP
    NOP

    NOP
    NOP
    NOP
    NOP
    NOP

    NOP
    NOP
    NOP
    NOP
    NOP

    NOP
    NOP
    NOP
    NOP
    NOP

    RET

command:
    LD C,0x50
    LD B,0x00
    OUT (C),A

    NOP
    NOP
    NOP
    NOP

    SET 1,B
    OUT (C),A

    NOP
    NOP
    NOP
    NOP
    NOP

    NOP
    NOP
    NOP
    NOP
    NOP

    NOP
    NOP
    NOP
    NOP
    NOP

    NOP
    NOP
    NOP
    NOP
    NOP
    RET

oleddata:
    LD C,0x50
    LD B,0x01
    OUT (C),A

    NOP
    NOP
    NOP
    NOP

    SET 1,B
    OUT (C),A

    NOP
    NOP
    
    RET

_oled_init:
    call reset
    ld HL, SEQUENCE
initloop:
    LD A,(HL)
    CP 0xFF
    RET Z
    CALL command
    INC HL
    JR initloop

_oled_invert:
    LD A,0xA7
    call command
    ret

_oled_normal:
    LD A,0xA6
    call command
    ret

_oled_set_full_screen:
    LD A,0x20
    CALL command
    LD A,0x00
    CALL command
    LD A,0x21
    CALL command
    LD A,0x04
    CALL command
    LD A,0x83
    CALL command

    LD A,0x22
    CALL command
    LD A,0x00
    CALL command
    LD A,0x03
    CALL command

    LD A,0xB0
    CALL command
    LD A,0x10
    CALL command
    LD A,0x04
    CALL command

_oled_draw_image:
    POP BC  ; get return address
    POP HL  ; get address of image data
    PUSH HL ; put the stack back together
    PUSH BC ; again
    LD D,0
winloop:
    LD A,(HL)
    CALL oleddata
    INC HL
    LD A,(HL)
    CALL oleddata
    INC HL
    DEC D
    JR NZ,winloop
    RET

_oled_clear:
    LD A,0xB0
    CALL command
    CALL clearrow
    LD A,0xB1
    CALL command
    CALL clearrow
    LD A,0xB2
    CALL command
    CALL clearrow
    LD A,0xB3
    CALL command
    CALL clearrow
    RET
clearrow:
    LD A,0x10
    CALL command
    LD A,0x04
    CALL command
    XOR A
    LD D,0x80
clearloop:
    CALL oleddata
    DEC D
    JR NZ, clearloop
    RET

_oled_brightness:
    POP HL  ; return address
    DEC SP
    POP AF  ; brightness
    LD D,A
    LD A,0x81
    CALL command
    ld A,D
    call command

    PUSH AF ; restore stack
    INC SP
    PUSH HL
    ret

_oled_test:
    LD A,0xB0
    CALL command
    LD A,0x10
    CALL command
    LD A,0x04
    call command
    XOR A
rowloop:
    CALL oleddata
    INC A
    CP 0x80
    RET Z
    JR rowloop

SEQUENCE:
    DB 0xAE, 0xD5, 0xA0, 0xA8
    DB 0x1F, 0xD3, 0x00, 0xAD
    DB 0x8E, 0xD8, 0x05, 0xA1
    DB 0xC8, 0xDA, 0x12, 0x91
    DB 0x3F, 0x3F, 0x3F, 0x3F
    DB 0x81, 0x80, 0xD9, 0xD2
    DB 0xDB, 0x34, 0xA6, 0xA4
    DB 0xAF
    DB 0xFF