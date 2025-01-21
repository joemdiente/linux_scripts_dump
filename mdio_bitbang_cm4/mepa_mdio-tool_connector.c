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

int main () {

    char *buffer; //Buffer for storing shell output
    size_t len;
    int rc;
    FILE *pipe = popen("sudo mdio -h", "r");

    if (pipe == NULL) {
        perror("popen() failed");
        return -1;
    }
    
    while ((rc = getline(&buffer, &len, pipe)) != -1) {
        printf("%s", buffer); 
    }

    // output[strcspn(output,"\n")] = 0;

    pclose(pipe);
    return 0;
}
#endif /* TEST */