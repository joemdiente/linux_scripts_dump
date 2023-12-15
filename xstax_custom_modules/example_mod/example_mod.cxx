/*******************************************************************************
* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
*
* Subject to your compliance with these terms, you may use Microchip software
* and any derivatives exclusively with Microchip products. It is your
* responsibility to comply with third party license terms applicable to your
* use of third party software (including open source software) that may
* accompany Microchip software.
*
* THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
* EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
* WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
* PARTICULAR PURPOSE.
*
* IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
* INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
* WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
* BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
* FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
* ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
* THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
*******************************************************************************/

#include "main.h"
#include "packet_api.h"
#include "port_api.h"
#include "microchip/ethernet/common.h"
#include "vtss/appl/module_id.h"

extern "C" int example_mod_icli_cmd_register();

/* Packet Transmit Function */
mesa_rc example_mod_packet_transmit(u32 packet_len)
{
    packet_tx_props_t my_tx_props;
    uchar *buffer;
    uchar frame[12] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, //Test DMAC (Broadcast Frame)
                        0x10, 0x22, 0x33, 0xAA, 0xBB, 0xFF}; //Test SMAC
    uchar ether_type[2] = {0x73, 0x57};
    u32 len;

    len = packet_len;
    buffer = packet_tx_alloc(len);

    //Fill-up Packet Data
    memcpy(buffer, frame, sizeof(frame));
    memcpy(buffer + sizeof(frame), ether_type, sizeof(ether_type));

    //packet_info is defined in packet/packet_api.h
    packet_tx_props_init(&my_tx_props);
    my_tx_props.packet_info.modid = VTSS_MODULE_ID_EXAMPLE_MOD;
    my_tx_props.packet_info.frm = buffer;
    my_tx_props.packet_info.len = len; 
    //tx_info is defined in microchip/ethernet/switch/api/packet.h
    my_tx_props.tx_info.switch_frm = FALSE;
    my_tx_props.tx_info.dst_port_mask = 1;

    if (packet_tx(&my_tx_props) != MESA_RC_OK) {
        printf("Frame transmit on port %d failed", my_tx_props.tx_info.dst_port);
        return -1;
    }

}
/* Packet Receive Filter Callback */
static BOOL example_mod_cb(void *contxt, const u8 *const frm, const mesa_packet_rx_info_t *const rx_info)
{
    printf("\nExample Mod Receive Filter Callback\n");
    printf("=======================================\n");
    printf("Receiving this means a packet was received by this module with EtherType: 0x7357\n");
    printf("=======================================\n");
    return true;
}

/* Initialize module */
mesa_rc example_mod_init(vtss_init_data_t *data) {

    vtss_isid_t isid = data->isid;
    mesa_rc rc = MESA_RC_OK;

    //Init Commands can be found in vtss_appl/main/main_types.h#136.
    switch(data->cmd) {
        case INIT_CMD_INIT:
            printf("%s\n", "Hello World! INIT");
            example_mod_icli_cmd_register();
            break;
        case INIT_CMD_START:
            printf("%s\n", "Hello World! START");
            break;
        case INIT_CMD_CONF_DEF:
            printf("%s\n", "Hello World! CONF DEF");
            break;
        case INIT_CMD_ICFG_LOADING_PRE:
            printf("%s\n", "Hello World! LOADING PRE");
            printf("%s\n", "Register Packet RX Filter");

            packet_rx_filter_t my_filter;
            void *my_filter_id;
            mesa_rc rc;
            mesa_port_no_t port_no;

            packet_rx_filter_init(&my_filter);
            my_filter.prio = PACKET_RX_FILTER_PRIO_HIGH;
            my_filter.modid = VTSS_MODULE_ID_EXAMPLE_MOD;
            my_filter.match = PACKET_RX_FILTER_MATCH_ETYPE;
            my_filter.etype = 0x7357;
            
            my_filter.cb = example_mod_cb;
            if (packet_rx_filter_register(&my_filter,&my_filter_id) != MESA_RC_OK) {
                printf("PACKET my_filter Register Failed\n");
            }
            break;

        case INIT_CMD_ICFG_LOADING_POST:
            printf("%s\n", "Hello World! LOADING PRE");
            break;

        default:
            break;
            
    }
    return rc;
}