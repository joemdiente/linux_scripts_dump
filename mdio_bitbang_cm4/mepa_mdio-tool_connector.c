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
#define STANDALONE_TEST

/* mdio-tools (mt_) read function*/
int mt_miim_read (uint8_t addr, uint16_t *const value)
{
    return -1;
}
/* mdio-tools (mt_) read function*/
int mt_miim_write (uint_t addr, uint16_t value)
{
    return -1;
}


#ifdef STANDALONE_TEST

int main () {

    printf("test printf\r\n");
    return 0;
}
#endif /* TEST */