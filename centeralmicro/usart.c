#include <mega32.h>

#include "usart.h"

void send_pattern(eeprom char pattern[16][8][2], char pattern_no)
{
    char block_no,
         byte_no;

    send_edit_pattern(pattern_no);

    for (block_no = 0; block_no < 16; block_no++) {
        for (byte_no = 0; byte_no < 2; byte_no++) {
            send_write_command(byte_no, block_no);
            send_usart(pattern[block_no][pattern_no][byte_no]);
        }
    }
}