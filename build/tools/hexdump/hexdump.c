#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LENGTH 80

#if 1
int main(int argc, char **argv)
{
	unsigned char buff[1024];
	char curr_out[64];

	int count, i;
	int line_length = 0;

	FILE *fp;

	fp = fopen(argv[argc-1],"rb");
	while(!feof(fp))
	{
		count = fread(buff, sizeof(char), sizeof(buff) / sizeof(char), fp);

		for(i = 0; i < count; i++)
		{
			line_length += sprintf(curr_out, "0x%02x, ", buff[i]);

			printf("%s", curr_out);
			if(line_length >= MAX_LENGTH)
			{
				printf("\n");
				line_length = 0;
			}
		}
	}

	fclose(fp);
	return EXIT_SUCCESS;
}
#else
int main(int argc, char **argv)
{
	static unsigned char buff[4096];

	FILE *fp = fopen(argv[argc-1],"rb");

	if(argv[argc-2][0]=='0')
	{
		fread(buff,1,256,fp);
		fwrite(buff,1,256,stdout);
	}
	else
	{
		fread(buff,1,2304,fp);
		fwrite(buff,1,2304,stdout);
	}

	fclose(fp);
	return EXIT_SUCCESS;
}
#endif
