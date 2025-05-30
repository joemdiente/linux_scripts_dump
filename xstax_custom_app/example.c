#include <stdio.h>
#include <fcntl.h>

int main() {
//   FILE *file;

//   // Open the file for writing. "w" mode creates a new file or overwrites an existing one.
//   file = fopen("hello_world.txt", "w");

//   if (file == NULL) {
//     printf("Error creating file!\n");
//     return 1; // Indicate an error occurred
//   }

//   printf("File 'hello_world.txt' created successfully!\n");

//   // Close the file to release resources.
//   fclose(file);

// ASCII Cat Art Example
    // printf("\r\n");
    // printf("             ＿ ＿\n");
    // printf("　　　　　 ＞　　 フ  I don't want likes I want ham sandwich\n");
    // printf("　　　　　| 　_　_l     (edit: Got ham sandwich)\n");
    // printf("　 　　　／` ミ_wノ\n");
    // printf("　　 　 /　　　 |\n");
    // printf("　　　 /　 ヽ　 ﾉ\n");
    // printf("　 　 │　|　|　|\n");
    // printf("　／￣|　 |　|　|\n");
    // printf("　| (￣ヽ＿_ヽ_)__)\n");
    // printf("　＼二つ\n");

    printf("      |\\      _,,,---,,_\n");
    printf("ZZZzz /,`.-'`'    -.  ;-;;,_\n");
    printf("     |,4-  ) )-,_. ,\\ (  `'-'\n");
    printf("    '---''(_/--'  `-'\\_) \n");

    printf("Example code ran successfully\r\n");

    // Use fopen to create the file in write mode ("w")
    int fd = open("/tmp/example.ready", O_RDWR | O_CREAT, 0644);

    // Check if the file was created successfully
    if (fd == -1) {
        perror("Error creating file");
        return 1; // Indicate an error
    }
  
    printf("File example.ready created successfully.\n");
    // while(1); // Running as service

    return 0; // Indicate successful execution
}