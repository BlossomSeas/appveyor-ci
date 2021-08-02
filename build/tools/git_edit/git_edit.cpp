#include <stdio.h>
#include <string.h>

static char out_buffer[16 * 0x100000];
static int out_buffer_ptr = 0;

static char temp_buffer[0x100000];

int main(int argc, char **argv)
{
	int merge_mode = 0;
	int merge_once = 0;

	if (!strcmp(argv[2], "old")) {
		merge_mode = 1;
	}

	else if (!strcmp(argv[2], "new")) {
		merge_mode = 2;
	}

	else if (!strcmp(argv[2], "both")) {
		merge_mode = 3;
	}

	else if (!strcmp(argv[2], "old_once")) {
		merge_mode = 1;
		merge_once = 1;
	}

	else if (!strcmp(argv[2], "new_once")) {
		merge_mode = 2;
		merge_once = 1;
	}

	else if (!strcmp(argv[2], "both_once")) {
		merge_mode = 3;
		merge_once = 1;
	}



	FILE *fp = fopen(argv[1], "r");
	int diff_mode = 0;

	while (!feof(fp)) {
		bool print = false;

		temp_buffer[0] = 0;
		fgets(temp_buffer, 0x100000, fp);

		//printf("[%d] %s", strlen(temp_buffer), temp_buffer);

		switch (diff_mode) {

		case 0:
			if (
				strlen(temp_buffer) == 13 &&
				!strcmp(temp_buffer, "<<<<<<< HEAD\n")
			) {
				diff_mode = 1;
			}

			else {
				print = true;
			}
			break;


		case 1:
			if (
				strlen(temp_buffer) == 8 &&
				!strcmp(temp_buffer, "=======\n")
			) {
				diff_mode = 2;
			}

			else if (merge_mode == 1 || merge_mode == 3) {
				print = true;
			}
			break;


		case 2:
			if (
				strlen(temp_buffer) >= 8 &&
				!strncmp(temp_buffer, ">>>>>>> ", 8)
			) {
				diff_mode = 0;

				if (merge_once) {
					diff_mode = -1;
					merge_once = 0;
				}
			}

			else if (merge_mode == 2 || merge_mode == 3)
				print = true;
			break;


		default:
			print = true;
			break;
		}


		if (print) {
			sprintf(out_buffer + out_buffer_ptr, "%s", temp_buffer);
			out_buffer_ptr += strlen(temp_buffer);
		}
	}

	fclose(fp);



	fp = fopen(argv[1], "wb");
	fwrite(out_buffer, 1, out_buffer_ptr, fp);
	fclose(fp);

	return 0;
}
