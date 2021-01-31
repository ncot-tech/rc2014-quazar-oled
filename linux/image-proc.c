#include <stdio.h>
#include <stdlib.h>

void main(int argc, char *argv[]) {

    FILE *fp;
    int width, height;
    char buff[255];
    int *bits;
    char * line = NULL;
    size_t len = 0;
    ssize_t read;

    // Open the file
    fp = fopen(argv[1], "r");
    // Get the image header
    fgets(buff, 255, fp);
    // Get the comment
    fgets(buff, 255, fp);
    // Get image dimensions
    fscanf(fp, "%d %d", &width, &height);
   

    // Read each "bit" and convert to an actual binary 1 or 0
    bits = malloc (width * height * sizeof(int));
    int bitcount = 0;

    while ((read = getline(&line, &len, fp)) != -1) {
        for (int i = 0; i < read-1; i+=2)
            if (line[i] == '0')
                bits[bitcount++] = 0;
            else if (line[i] == '1')
                bits[bitcount++] = 1;
            else
                printf ("Invalid bit found %c\n", line[i]);
    }

    fclose(fp);
    if (line)
        free(line);



    unsigned char data[128*4];
    int stride = 0;
    int pixel = 0;
    int row = 0;

    // Yeah, I could have used memset() ¯\_(ツ)_/¯
    for (int i = 0; i < 128*4; i++)
        data[i] = 0;

    // Group the bits into vertical strips of 8
    for (int i = 0; i < width*height; i++) {
        stride = i % 128;
        if (stride == 0 && i > 0)
            pixel++;
            if (pixel > 0 && pixel % 8 == 0) {
                row++;
                pixel = 0;
            }

        data[stride + (row * 128)] |= bits[i] << pixel;        
    }


    // Print the code to the screen for copy-pasta later
    printf ("unsigned char %s[512] = {", argv[1]);
    for (int i = 0; i < 128*4; i++) {
        printf ("0x%02x,",data[i]);
        if (i > 0 && i % 128 == 0)
            printf("\n");
    }
    printf ("};\n");
}