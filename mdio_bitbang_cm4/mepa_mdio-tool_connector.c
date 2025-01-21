/* 
 * mdio-tool output to Microchip Ethernet PHY API MII management functions connector
 *
 * Pre-requisites: Install kernel module and tool at wkz/mdio-tools (https://github.com/wkz/mdio-tools)
 * 
 * Usage: Takes output of mdio utility to mepa_callout.miim_read/write
 * Author: Joemel John Diente <joemdiente@gmail.com>
 *
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define STANDALONE_TEST

/* mdio-tools (mt_) read function*/
int mt_miim_read (uint8_t addr, uint16_t *const value)
{
    return -1;
}
/* mdio-tools (mt_) read function*/
int mt_miim_write (uint8_t addr, uint16_t value)
{
    return -1;
}


#ifdef STANDALONE_TEST

//From gemini.google.com
uint16_t hex_string_to_uint16(const char* hex_str) {
    // Remove the "0x" prefix if present
    char* stripped_str = strdup(hex_str); 
    if (stripped_str[0] == '0' && stripped_str[1] == 'x') {
        memmove(stripped_str, stripped_str + 2, strlen(stripped_str) - 1); 
    }

    if (strlen(stripped_str) != 4) {
        fprintf(stderr, "Error: Invalid hex string length. Expected 4 characters.\n");
        free(stripped_str); 
        return 0; 
    }

    char high_byte[3] = {stripped_str[0], stripped_str[1], '\0'};
    char low_byte[3] = {stripped_str[2], stripped_str[3], '\0'};

    uint8_t high_byte_val = (uint8_t)strtol(high_byte, NULL, 16);
    uint8_t low_byte_val = (uint8_t)strtol(low_byte, NULL, 16);

    free(stripped_str); 

    return (uint16_t)((high_byte_val << 8) | low_byte_val);
}

int main () {

    char output[1024]; //Buffer for storing shell output
    char command[2048];

    uint8_t phy_addr;
    uint16_t reg_val;
    size_t len;

    int rc;

    printf("Starting STANDALONE_TEST\r\n");

    //Format command
    phy_addr = 1;
    reg_val = 2;
    snprintf(command, sizeof(command), "sudo mdio gpio-0 phy %i raw %i", phy_addr, reg_val);

    //Debug
    printf("[DEBUG] %s \r\n",command);

    //Open pipe
    FILE *pipe = popen(command,"r");

    //Check if opening popen failed
    if (pipe == NULL) {
        perror("popen() failed");
        return -1;
    }

    while (fgets(output, sizeof(output), pipe) != NULL) {
        // Process the output as needed (e.g., print it)
        //Debug
        printf("[DEBUG] %s", output); 
    }

    /* Expected output string is 0x0000
     * Copy string to up to 6th char and then set 7th to \n (null ptr) 
     */
    char *reg_val_str;
    output[6] = '\0';
    reg_val = hex_string_to_uint16(output);
    printf("[DEBUG] %s \r\n", output);

    printf("[DEBUG] %X \r\n", reg_val);
    
    pclose(pipe);
    return 0;
}
#endif /* TEST */