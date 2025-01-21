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
#define DEBUG 1

/* Got from https://stackoverflow.com/questions/1941307/debug-print-macro-in-c
 * #define DEBUG greater than 0 to use DEBUG_PRINT()
 */
#if defined(DEBUG) && DEBUG > 0
 #define DEBUG_PRINT(fmt, args...) fprintf(stderr, "DEBUG: %s:%d:%s(): " fmt, \
    __FILE__, __LINE__, __func__, ##args)
#else
 #define DEBUG_PRINT(fmt, args...) /* Don't do anything in release builds */
#endif

uint16_t hex_string_to_uint16(const char* hex_str);

/* mdio-tools (mt_) read function*/
int mt_miim_read (uint8_t addr, uint16_t *const value)
{
    char output[1024]; //Buffer for storing shell output
    char command[2048];
    int rc = -1;

    //Format command
    snprintf(command, sizeof(command), "sudo mdio gpio-0 phy %i raw %i", 1, addr);

    DEBUG_PRINT("%s \r\n",command);


    //Open pipe
    FILE *pipe = popen(command,"r");

    //Check if opening popen failed
    if (pipe == NULL) {
        perror("popen() failed");
        return -1;
    }

    //Get output from pipe
    while (fgets(output, sizeof(output), pipe) != NULL) {
        // Process the output as needed (e.g., print it)
        //Debug
        DEBUG_PRINT("%s", output); 
    }

    /* Expected output string is 0x0000
     * Copy string to up to 6th char and then set 7th to \0 (null ptr) 
     */
    char *reg_val_str;
    output[6] = '\0';
    *value = hex_string_to_uint16(output);
    if (*value == -1 ) {
        DEBUG_PRINT("conversion failed\r\n");
        return -1;
    }
    pclose(pipe);

    return -1;
}
/* mdio-tools (mt_) read function*/
int mt_miim_write (uint8_t addr, uint16_t value)
{
    char command[2048];
    char output[512];
    int rc = -1;

    //Format command
    snprintf(command, sizeof(command), "sudo mdio gpio-0 phy %u raw %i %u", 1, addr, value);
    DEBUG_PRINT(" %s \r\n",command);

    //Open pipe
    FILE *pipe = popen(command,"r");

    //Check if opening popen failed
    if (pipe == NULL) {
        perror("popen() failed");
        return -1;
    }

    //Get output from pipe (unnecessary, just checking if fails)
    //If there is an output then it failed or something.
    if(fgets(output, sizeof(output), pipe) != NULL) {
        //There should be no output after writing.
        DEBUG_PRINT("%s", output); 
        rc = -1;
    }
    else rc = 0;
 
    pclose(pipe);

    return rc;
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
        return -1; 
    }

    char high_byte[3] = {stripped_str[0], stripped_str[1], '\0'};
    char low_byte[3] = {stripped_str[2], stripped_str[3], '\0'};

    uint8_t high_byte_val = (uint8_t)strtol(high_byte, NULL, 16);
    uint8_t low_byte_val = (uint8_t)strtol(low_byte, NULL, 16);

    free(stripped_str); 

    return (uint16_t)((high_byte_val << 8) | low_byte_val);
}

int main () {

    uint16_t reg_value;
    
    DEBUG_PRINT("[Main] Starting STANDALONE_TEST\r\n");

    mt_miim_read(0x2,&reg_value);
    printf("%i\r\n", reg_value);

    if(mt_miim_write(0x0, 0x7040) != -1) {
         printf("mt_miim_write success. \r\n");
    }

    mt_miim_read(0x0,&reg_value);
     printf("%i\r\n", reg_value);

    return 0;
}
#endif /* TEST */