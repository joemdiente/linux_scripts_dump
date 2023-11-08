#include <stdio.h>

int main() {
   // printf() displays the string inside quotation
   printf("Hello, World!\r\n");
   return 0;
}


/* Notes on testing:
    1. gcc helloworld.c -o helloworld ;; normal build
    2. gcc -g helloworld -o helloworld_debug ;; debug build ;;https://www.cs.umd.edu/~srhuang/teaching/cmsc212/gdb-tutorial-handout.pdf
    3. gdb helloworld
        Reading symbols from helloworld...
        (No debugging symbols found in helloworld)
        (gdb) run
        Starting program: /home/joemdiente/linux_scripts_dump/app_testing/helloworld 
        Hello, World!
        [Inferior 1 (process 5295) exited normally]
        (gdb) run
        Starting program: /home/joemdiente/linux_scripts_dump/app_testing/helloworld 
        Hello, World!
        [Inferior 1 (process 5334) exited normally]
        (gdb) Quit
    4. gdb helloworld_debug
        Type "apropos word" to search for commands related to "word"...
        Reading symbols from helloworld_debug...
        (gdb) Quit
        (gdb) quit
    5. Setup remote debugging 
        RPi4 (192.168.0.x) <-> RPi3b+ (192.168.0.240)
        Debug here                  Code is running here
                                    gdbserver localhost:2001 ./helloworld_debug
        gdb-multiarch
        (gdb) target remote 192.168.0.240:2001
        Remote debugging using 192.168.0.240:2001
        Reading /home/joem/helloworld_debug from remote target...
        warning: File transfers from remote targets can be slow. Use "set sysroot" to access files locally instead.
        Reading /home/joem/helloworld_debug from remote target...
        Reading symbols from target:/home/joem/helloworld_debug...
        Reading /lib/ld-linux-armhf.so.3 from remote target...
        Reading /lib/ld-linux-armhf.so.3 from remote target...
        Reading symbols from target:/lib/ld-linux-armhf.so.3...
        Reading /lib/c29fc8e2acb871ef058e5450e2d5552300584d.debug from remote target...
        Reading /lib/.debug/c29fc8e2acb871ef058e5450e2d5552300584d.debug from remote target...
        Reading /usr/lib/debug//lib/c29fc8e2acb871ef058e5450e2d5552300584d.debug from remote target...
        Reading /usr/lib/debug/lib//c29fc8e2acb871ef058e5450e2d5552300584d.debug from remote target...
        Reading target:/usr/lib/debug/lib//c29fc8e2acb871ef058e5450e2d5552300584d.debug from remote target...
        (No debugging symbols found in target:/lib/ld-linux-armhf.so.3)
        0x76fcca50 in ?? () from target:/lib/ld-linux-armhf.so.3
        (gdb) list
        1	#include <stdio.h>
        2	
        3	int main() {
        4	   // printf() displays the string inside quotation
        5	   printf("Hello, World!\r\n");
        6	   return 0;
        7	}
        8	
        9	
        10	/* Notes on testing:
        (gdb) b 6
        Breakpoint 1 at 0x10414: file helloworld.c, line 6.
        (gdb) cont
        Continuing.


        
*/