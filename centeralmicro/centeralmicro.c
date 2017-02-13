#include <mega32.h>
#include <stdio.h>
#include <string.h>
#include <delay.h>
#include <interrupt.h>


#include "usart.h"
#include "Includes/graph.h"
#include "Includes/GLCD.h"
#include "Includes/seq2.h"


eeprom char pattern[16][8][2];
eeprom char pattern_no;


char temp = 252;

const signed char codes[] = {7, 8, 9, -1, 4, 5, 6, -1, 1, 2, 3, -1, -1, 0, -1, -1};

/*
    Input handlers
*/
void (*keypad_handler)(char) = 0;
void (*button_handler)(char) = 0;

void main_window(void);


char temp_window_byte;
char temp_window_selected;
char temp_window_range_small;
char temp_window_range_large;


void temp_window_keypad(char key_num)
{
    char *byt = &temp_window_range_small;
    if (temp_window_byte)
        byt = &temp_window_range_large;

    if (codes[key_num] != -1) {
        char str[3];
        char clear = 0;

        if (*byt > 9 || *byt == 0xFF) {
            clear = 1;
            *byt = codes[key_num];
        }
        else {
                *byt *= 10;
                *byt += codes[key_num];
        }
        if (clear)
            sprintf(str, "%d ", *byt);
        else
            sprintf(str, "%d", *byt);
        glcd_puts(str, (4 + temp_window_byte * 5) * 8, 3, 0, 1, 0);
    }
}


void temp_window_button(char button_no)
{
    switch (button_no) {
        case 1: // Up button
        case 4: // Down button
            glcd_puts(" ", (6 - temp_window_selected * 2) * 8,
                      6 + temp_window_selected, 0, 1, 0);
            glcd_puts(" ", (9 + temp_window_selected * 2) * 8,
                      6 + temp_window_selected, 0, 1, 0);
            temp_window_selected ^= 1;
            glcd_puts("[", (6 - temp_window_selected * 2) * 8,
                      6 + temp_window_selected, 0, 1, 0);
            glcd_puts("]", (9 + temp_window_selected * 2) * 8,
                      6 + temp_window_selected, 0, 1, 0);
        break;
        case 2: // Right button
        case 3: // Left button
            rectangle((4 + temp_window_byte * 5) * 8 - 3,
                      3 * 8 - 3,
                      (6 + temp_window_byte * 5) * 8 + 3,
                      4 * 8 + 3, 0, 0);
            temp_window_byte ^= 1;
            rectangle(4 * 8 - 3, 3 * 8 - 3, 6 * 8 + 3, 4 * 8 + 3, temp_window_byte ,1);
            rectangle(9 * 8 - 3, 3 * 8 - 3, 11 * 8 + 3, 4 * 8 + 3, temp_window_byte ^ 1 ,1);
        break;
        case 0: // OK button
            // OK is selected in menu
            if (temp_window_selected == 0) {
                // If both ranges have values in them
                if (temp_window_range_small != 0xFF && temp_window_range_large != 0xFF) {
                    // Swap range variables if second one is smaller than the first one
                    if (temp_window_range_large < temp_window_range_small) {
                        char temporary = temp_window_range_large;
                        temp_window_range_large = temp_window_range_small;
                        temp_window_range_small = temporary;
                    }

                    send_range(temp_window_range_small, temp_window_range_large);
                    main_window();
                }
            }
            // Cancel is selected in menu
            else
                main_window();
    }
}


void temp_window(void)
{
    temp_window_byte = 0;
    temp_window_selected = 0;
    temp_window_range_small = 0xFF;
    temp_window_range_large = 0xFF;

    /*
        Display
    */
    glcd_clear();

    glcd_puts("Enter a range:", 0, 0, 0, 1, 0);
    glcd_puts(" - ", 6 * 8, 3, 0, 1, 0);
    rectangle(4 * 8 - 3, 3 * 8 - 3, 6 * 8 + 3, 4 * 8 + 3, 0 ,1);
    rectangle(9 * 8 - 3, 3 * 8 - 3, 11 * 8 + 3, 4 * 8 + 3, 1 ,1);
    glcd_puts("[OK]", 6 * 8, 6, 0, 1, 0);
    glcd_puts(" Cancel", 4 * 8, 7, 0, 1, 0);

    /*
        Init input handlers
    */
    keypad_handler = &temp_window_keypad;
    button_handler = &temp_window_button;

}

/*
    Draws a single LED
*/
inline void draw_led(unsigned int x, unsigned int y)
{
    rectangle(x - 1, y - 1, x + 1, y + 1, 0, 1);
}

/*
    Draws a block of LEDs
*/
inline void draw_block(unsigned int x, unsigned int y)
{
    char i, j;

    for (i = 0; i < 4; i++)
        for (j = 0; j < 4; j++)
            draw_led(x + (i * 4) + 1, y + (j * 4) + 1);
}

// Active block number in edit window
char edit_window_block_no;

/*
    Draws a border line for active block in edit window
*/
inline void draw_block_border(char black_dot)
{
    char block_x = (edit_window_block_no % 4) * 16,
         block_y = (edit_window_block_no / 4) * 16;

    h_line(block_x, block_y, 15, 0, black_dot);
    h_line(block_x, block_y + 14, 15, 0, black_dot);
    v_line(block_x + 14, block_y, 15, 0, black_dot);
    v_line(block_x, block_y, 15, 0, black_dot);

    if (!black_dot)
        draw_block(block_x, block_y);
}

// Current state of pattern which is being edited in edit window
char edit_window_pattern[16][2];

char activate_window_pattern_no;


char edit_window_selected;


void edit_window(char);


void edit_window_menu_button(char button_no)
{
    switch (button_no) {
        case 1: // Up
            glcd_puts(" ", 0, edit_window_selected + 2, 0, 1, 0);
            if (edit_window_selected == 0) {
                edit_window_selected = 3;
            }
            else {
                edit_window_selected -= 1;
            }
            glcd_puts(">", 0, edit_window_selected + 2, 0, 1, 0);
        break;
        case 4: // Down
            glcd_puts(" ", 0, edit_window_selected + 2, 0, 1, 0);
            edit_window_selected = (edit_window_selected + 1) % 4;
            glcd_puts(">", 0, edit_window_selected + 2, 0, 1, 0);
        break;
        case 0: // OK
        switch (edit_window_selected) {
            case 0: // Continue
                edit_window(0);
            break;
            case 1: // Save
            case 2: // Activate
                {
                    char i, j;

                    for (i = 0; i < 16; i++)
                        for (j = 0; j < 2; j++)
                            pattern[i][activate_window_pattern_no][j] = edit_window_pattern[i][j];

                    send_pattern(pattern, activate_window_pattern_no);

                    if (edit_window_selected == 2) {
                        pattern_no = activate_window_pattern_no;
                        send_active_pattern(activate_window_pattern_no);
                    }

                    main_window();
                }
            break;
            case 3: // Cancel
                main_window();
            break;
        }
    }
}


void edit_window_menu()
{
    edit_window_selected = 0;

    /*
        Init input handlers
    */
    keypad_handler = 0;
    button_handler = &edit_window_menu_button;

    /*
        Display
    */
    glcd_clear();

    {
        char str[9];
        sprintf(str, "Pattern: %d", activate_window_pattern_no + 1);
        glcd_puts(str, 0, 0, 0, 1, 0);
    }

    glcd_puts("> Continue", 0, 2, 0, 1, 0);
    glcd_puts("  Save", 0, 3, 0, 1, 0);
    glcd_puts("  Activate", 0, 4, 0, 1, 0);
    glcd_puts("  Cancel", 0, 5, 0, 1, 0);
}


void edit_window_button(char button_no)
{
    if (button_no != 0)
        draw_block_border(0);

    switch (button_no) {
        case 1: // Up button
            if (edit_window_block_no < 4)
                edit_window_block_no += 12;
            else
                edit_window_block_no -= 4;
        break;
        case 4: // Down button
            edit_window_block_no = (edit_window_block_no + 4) % 16;
        break;
        case 2: // Right button
            edit_window_block_no = (edit_window_block_no + 1) % 16;
        break;
        case 3: // Left button
            if (edit_window_block_no == 0)
                edit_window_block_no = 15;
            else
                edit_window_block_no--;
        break;
        case 0: // OK button - Menu
            edit_window_menu();
            return;
        break;
    }

    draw_block_border(1);
    {
        char str[3];
        glcd_puts("  ", 64 + 3 * 8, 3, 0, 1, 0);
        sprintf(str, "%d", edit_window_block_no + 1);
        glcd_puts(str, 64 + 3 * 8, 3, 0, 1, 0);
    }

}


void edit_window_keypad(char key_no)
{
    char led_x = ((edit_window_block_no % 4) * 16) + ((key_no % 4) * 4) + 1,
         led_y = ((edit_window_block_no / 4) * 16) + ((key_no / 4) * 4) + 1,
         led_bit;

    edit_window_pattern[edit_window_block_no][key_no / 8] ^= (1<<(key_no % 8));
    led_bit = edit_window_pattern[edit_window_block_no][key_no / 8] & (1<<(key_no % 8));
    if (led_bit == 0)
        point_at(led_x, led_y, 0);
    else
        point_at(led_x, led_y, 1);
}


void edit_window(char new_window)
{
    char i, j;

    glcd_clear();

    // Draws blocks and LEDs
    for (i = 0; i < 4; i++)
        for (j = 0; j < 4; j++)
            draw_block(16 * i, 16 * j);

    if (new_window) {
        // Copies pattern from EEPROM to a SRAM array
        for (i = 0; i < 16; i++)
            for (j = 0; j < 2; j++)
                edit_window_pattern[i][j] = pattern[i][activate_window_pattern_no][j];
    }

    // Draws LED states
    for (i = 0; i < 16; i++) {
        for (j = 0; j < 16; j++) {
            char led_x = ((i % 4) * 16) + ((j % 4) * 4) + 1,
                 led_y = ((i / 4) * 16) + ((j / 4) * 4) + 1,
                 led_bit = edit_window_pattern[i][j / 8] & (1<<(j % 8));

            if (led_bit == 0)
                point_at(led_x, led_y, 0);
            else
                point_at(led_x, led_y, 1);
        }
    }

    if (new_window)
        edit_window_block_no = 0;
    draw_block_border(1);

    {
        char str[9];
        glcd_puts("Pattern:", 64, 0, 0, 1, 0);
        sprintf(str, "%d", activate_window_pattern_no + 1);
        glcd_puts(str, 64 + 28, 1, 0, 1, 0);
        glcd_puts("Block:", 64 + 1 * 8, 2, 0, 1, 0);
        sprintf(str, "%d", edit_window_block_no + 1);
        glcd_puts(str, 64 + 3 * 8, 3, 0, 1, 0);
        glcd_puts("[Menu]", 64 + 1 * 8, 7, 0, 1, 0);
    }

    /*
        Init input handlers
    */
    keypad_handler = &edit_window_keypad;
    button_handler = &edit_window_button;
}


char activate_window_selected;
char activate_window_mode;

void activate_window_keypad(char key_num)
{
    if (codes[key_num] != -1 && codes[key_num] != 0) {
        char str[3];
        glcd_puts(" ", 7 * 8, 4, 0, 1, 0);
        activate_window_pattern_no = codes[key_num];
        sprintf(str, "%d", activate_window_pattern_no);
        glcd_puts(str, 7 * 8, 4, 0, 1, 0);
    }
}


void activate_window_button(char button_no)
{
    switch (button_no) {
        case 1: // Up button
        case 4: // Down button
            glcd_puts(" ", (6 - activate_window_selected * 2) * 8,
                      6 + activate_window_selected, 0, 1, 0);
            glcd_puts(" ", (9 + activate_window_selected * 2) * 8,
                      6 + activate_window_selected, 0, 1, 0);
            activate_window_selected ^= 1;
            glcd_puts("[", (6 - activate_window_selected * 2) * 8,
                      6 + activate_window_selected, 0, 1, 0);
            glcd_puts("]", (9 + activate_window_selected * 2) * 8,
                      6 + activate_window_selected, 0, 1, 0);
        break;
        case 0: // OK button
            // If OK is selected in menu
            if (activate_window_selected == 0) {
                // If pattern number is not empty
                if (activate_window_pattern_no != 0xFF) {
                    activate_window_pattern_no--;
                    // Change active pattern and send them to lightmicros
                    if (activate_window_mode == 0) {
                        pattern_no = activate_window_pattern_no;
                        send_active_pattern(activate_window_pattern_no);
                        main_window();
                    }
                    // Go to edit window
                    else
                        edit_window(1);
                }
            }
            // If cancel is selected in menu
            else
                main_window();
        break;
    }
}


void activate_window(char mode)
{
    activate_window_selected = 0;
    activate_window_mode = mode;
    activate_window_pattern_no = 0xFF;

    /*
        Display
    */
    glcd_clear();

    glcd_puts("Enter a pattern", 0, 0, 0, 1, 0);
    glcd_puts("number between", 0, 1, 0, 1, 0);
    glcd_puts("1 and 8 : ", 0, 2, 0, 1, 0);

    rectangle(7 * 8 - 3, 4 * 8 - 3, 8 * 8 + 3, 5 * 8 + 3, 0 ,1);

    glcd_puts("[OK]", 6 * 8, 6, 0, 1, 0);
    glcd_puts(" Cancel", 4 * 8, 7, 0, 1, 0);

    /*
        Init input handlers
    */
    keypad_handler = &activate_window_keypad;
    button_handler = &activate_window_button;
}

void debug_window_button(char button_no)
{
    if (button_no == 0) // OK
    {
        main_window();
    }
}


void debug_window(void)
{
    char i, test_response, micros[16] = {0, 0, 0, 0,
                                         0, 0, 0, 0,
                                         0, 0, 0, 0,
                                         0, 0, 0, 0},
         count = 0;

    glcd_clear();
    glcd_puts("Debugging,", 0, 0, 0, 1, 0);
    glcd_puts("Please wait...", 0, 1, 0, 1, 0);

    /*
        Testing section
    */

     // Receives USART from lightmicros
    PORTD.4 = 1;

    for (i = 0; i < 16; i++) {
        select_lightmicro(i);

        send_test_connection_lightmicro(i);

        delay_ms(15);

        if (UCSRA.RXC == 1) {
            test_response = UDR;
            if (test_response == (i * 4 + 2)) {
                continue;
            }
        }

        micros[i] = 1;
        count++;
    }

    // Receives USART from tempmicro
    PORTD.4 = 0;

    /*
        Display test result
    */

    glcd_clear();

    // If all micros all connected
    if (count == 0) {
        glcd_puts("All lightmicros,", 0, 0, 0, 1, 0);
        glcd_puts("are connected.", 0, 1, 0, 1, 0);
    }
    // If there is any disconnected micros
    else {
        char x = 0, y = 2;

        glcd_puts("lightmicros that", 0, 0, 0, 1, 0);
        glcd_puts("are disconnected", 0, 1, 0, 1, 0);

        for (i = 0; count != 0; i++) {
            // If lightmicro is disconnected
            if (micros[i] == 1) {
                char i_str[4];
                char len = (i >= 10) ? 2 : 1;

                if (15 - x < len) {
                    // Clear dash
                    glcd_puts(" ", (x - 1) * 8, y, 0, 1, 0);

                    x = 0;
                    y++;

                }
                else {
                    if (x != 0) {
                        glcd_puts("-", x * 8 ,y , 0, 1, 0);

                        x++;
                    }
                }

                sprintf(i_str, "%d", i + 1);
                glcd_puts(i_str, x * 8, y, 0, 1, 0);

                if (x + len > 15) {
                    x = 0;
                    y++;
                }
                else {
                    x += len;
                }

                count--;
            }
        }
    }

    glcd_puts("[OK]", 6 * 8, 7, 0, 1, 0);

    /*
        Init input handlers
    */
    keypad_handler = 0;
    button_handler = &debug_window_button;
}


char main_window_selected;


void main_window_button(char button_no)
{
    switch (button_no) {
        case 1: // Up
            glcd_puts(" ", 0, main_window_selected, 0, 1, 0);
            if (main_window_selected == 0) {
                main_window_selected = 3;
            }
            else {
                main_window_selected -= 1;
            }
            glcd_puts(">", 0, main_window_selected, 0, 1, 0);
        break;
        case 4: // Down
            glcd_puts(" ", 0, main_window_selected, 0, 1, 0);
            main_window_selected = (main_window_selected + 1) % 4;
            glcd_puts(">", 0, main_window_selected, 0, 1, 0);
        break;
        case 0: // OK
        // Don't recieve temperatures from tempmicro
        UCSRB.RXCIE = 0;

        switch (main_window_selected) {
            case 0: // Edit
                activate_window(1);
            break;
            case 1: // Activate
                activate_window(0);
            break;
            case 2: // Debug
                debug_window();
            break;
            case 3: // Temp range
                temp_window();
            break;
        }
    }
}


void main_window(void)
{
    char pattern_no_str[2];

    main_window_selected = 0;

    temp = 252;

    /*
        Display
    */
    glcd_clear();

    glcd_puts(">Edit", 0, 0, 0, 1, 0);
    glcd_puts("Activate", 1*8, 1, 0, 1, 0);
    glcd_puts("Debug", 1*8, 2, 0, 1, 0);
    glcd_puts("Temp range", 1*8, 3, 0, 1, 0);

    h_line(0, 5 * 8, 16 * 8, 0, 1);

    glcd_puts("Pattern: ", 0, 6, 0, 1, 0);
    sprintf(pattern_no_str, "%d", pattern_no + 1);
    glcd_puts(pattern_no_str, 9*8, 6, 0, 1, 0);

    glcd_puts("Temp: meausring", 0, 7, 0, 1, 0);

    // Receive temperatures from tempmicro
    UCSRB.RXCIE = 1;

    /*
        Init input handlers
    */
    keypad_handler = 0;
    button_handler = &main_window_button;
}

void main(void)
{
    /*
		Give pattern_no initial value
	*/
    if (pattern_no == 0xFF) {
        pattern_no = 0;
    }

    /*
		Port initialize
	*/
    DDRA = 0xFF;

    DDRB = 0xF0;
    PORTB = 0x0F;

    DDRC = 0x0F;
    PORTC |= 0xF0;

    DDRD = 0b10010010;
    PORTD |= 0b01001101;

    /*
		USART initialize
	*/
    UCSRB = (1<<RXEN) | (1<<TXEN);
    UCSRC = (1<<UCSZ1)|(1<<UCSZ0)|(1<<URSEL);
    UBRRL = 0x33;

    /*
        External interrupt initialize
    */
    MCUCR = 0x0A;
    GICR = (1<<INT0) | (1<<INT1);

    main_window();

    sei();


    /*
		Program's main loop
	*/
    while (1) {
    }
}


/*
    New temperature has been sent
*/
interrupt [USART_RXC] void usart_rxc_isr(void)
{
    char temp_str[2], new_temp;

    new_temp = UDR;
    if (new_temp == temp)
        return;
    temp = new_temp;
    sprintf(temp_str, "%d", new_temp);
    glcd_puts("         ", 6*8, 7, 0, 1, 0);
    glcd_puts(temp_str, 6*8, 7, 0, 1, 0);
}


/*
    A button has been pressed
*/
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    char button_no = 0;

    if (!button_handler)
        return;

    if (!PINC.7)
        button_no = 1; // Up
    else if (!PINC.5)
        button_no = 2; // Right
    else if (!PINC.4)
        button_no = 3; // Left
    else if (!PINC.6)
        button_no = 4; // Down


    (*button_handler)(button_no);

}


/*
    Keypad has been pressed
*/
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    char pinb_rows,
         pinb_columns,
         i,
         j;

    if (!keypad_handler)
        return;

    pinb_rows = PINB | 0xF0;

    for (i = 0 ;; i++)
        if (!(pinb_rows & (1<<i)))
            break;

    DDRB = 0;
    PORTB = 0;

    DDRB = 0x0F;
    PORTB = 0xF0;

    pinb_columns = PINB>>4;

    for (j = 0 ;; j++)
        if (!(pinb_columns & (1<<j)))
            break;
    DDRB = 0;
    PORTB = 0;

    DDRB = 0xF0;
    PORTB = 0x0F;

    (*keypad_handler)(i * 4 + j);
}
