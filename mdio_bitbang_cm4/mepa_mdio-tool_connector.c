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

/* Define here */
#define TEST
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

#ifdef TEST
/* 
 * pseudo mepa-callout-ctx struct 
 */
typedef struct pseudo_mepa_callout_ctx {
    uint8_t inst;
    uint8_t port_no;
    uint8_t miim_controller;
    uint8_t miim_addr;
    uint8_t chip_no;
} pseudo_mepa_callout_ctx_t;

typedef uint8_t mepa_rc;
typedef mepa_rc (*mepa_miim_read_t)(struct pseudo_mepa_callout_ctx          *ctx,
                                    const uint8_t                     addr,
                                    uint16_t                         *const value);
typedef mepa_rc (*mepa_miim_write_t)(struct pseudo_mepa_callout_ctx         *ctx,
                                    const uint8_t                    addr,
                                    const uint16_t                   value);

/* 
 * pseudo mepa-callout struct 
 */
typedef struct pseudo_mepa_callout {
    mepa_miim_read_t mepa_miim_read;
    mepa_miim_write_t mepa_miim_write;
} pseudo_mepa_callout_t;

#endif /* TEST */

/* 
 * Came from from gemini.google.com
 * Used by connector for converting string output from mdio-tools to uint16
 */
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


/* mdio-tools (mt_) read function*/
mepa_rc mt_miim_read (struct pseudo_mepa_callout_ctx *ctx, uint8_t addr, uint16_t *const value)
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
mepa_rc mt_miim_write (struct pseudo_mepa_callout_ctx *ctx, uint8_t addr, uint16_t value)
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


#ifdef TEST
int main () {

    uint16_t reg_value;
    struct pseudo_mepa_callout test_callout;
    struct pseudo_mepa_callout_ctx *test_callout_ctx;
    DEBUG_PRINT("[Main] Starting TEST\r\n");

    test_callout.mepa_miim_read = mt_miim_read;
    test_callout.mepa_miim_write = mt_miim_write;

    test_callout.mepa_miim_read(test_callout_ctx,0x2,&reg_value);
    printf("%i\r\n", reg_value);

    if(mt_miim_write(test_callout_ctx, 0x0, 0x7040) != -1) {
         printf("mt_miim_write success. \r\n");
    }

    mt_miim_read(test_callout_ctx, 0x0,&reg_value);
     printf("%i\r\n", reg_value);

    return 0;
}
#endif /* TEST */