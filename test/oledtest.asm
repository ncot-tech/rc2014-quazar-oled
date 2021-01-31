    OUTPUT oledtest.z80

    ORG $8000
main:
    call oled_init
    call oled_invert
    LD A,0x02
    call oled_brightness
    call oled_test
    ret

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

oled_init:
    call reset
    ld HL, SEQUENCE
initloop:
    LD A,(HL)
    CP 0xFF
    RET Z
    CALL command
    INC HL
    JR initloop

oled_invert:
    LD A,0xA7
    call command
    ret

oled_normal:
    LD A,0xA6
    call command
    ret

oled_brightness:
    LD D,A
    LD A,0x81
    CALL command
    ld A,D
    call command
    ret

oled_test:
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