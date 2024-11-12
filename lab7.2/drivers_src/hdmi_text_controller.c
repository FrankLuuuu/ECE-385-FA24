

/***************************** Include Files *******************************/
#include "hdmi_text_controller.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "sleep.h"

/************************** Function Definitions ***************************/

void paletteTest()
{
	textHDMIColorClr();

	for (int i = 0; i < 8; i ++)
	{
		char color_string[80];
		sprintf(color_string, "Foreground: %d background %d", 2*i, 2*i+1);
		textHDMIDrawColorText (color_string, 0, 2*i, 2*i, 2*i+1);
		sprintf(color_string, "Foreground: %d background %d", 2*i+1, 2*i);
		textHDMIDrawColorText (color_string, 40, 2*i, 2*i+1, 2*i);
	}
	textHDMIDrawColorText ("The above text should cycle through random colors", 0, 25, 0, 1);


	for (int i = 0; i < 10; i++)
	{
		sleep_MB (1);
		for (int j = 0; j < 16; j++)
			setColorPalette(j, 	rand() % 16, rand() % 16,rand() % 16); //set color 0 to random color;

	}
}

void textHDMIColorClr()
{
	for (int i = 0; i<(ROWS*COLUMNS) * 2; i++)
	{
		hdmi_ctrl->VRAM[i] = 0x00;
	}
}

void textHDMIDrawColorText(char* str, int x, int y, uint8_t background, uint8_t foreground)
{
	int i = 0;
	while (str[i]!=0)
	{
		hdmi_ctrl->VRAM[(y*COLUMNS + x + i) * 2] = foreground << 4 | background;
		hdmi_ctrl->VRAM[(y*COLUMNS + x + i) * 2 + 1] = str[i];
		i++;
	}
}

void setColorPalette (uint8_t color, uint8_t red, uint8_t green, uint8_t blue)
{
	//fill in this function to set the color palette starting at offset 0x0000 2000 (from base)
	// red green and blue are types uint_8 (8 bit wide data path), but only 4 of those paths are used
	// j color is the integer index into the color pallete where j is between 0 and 16
	// palate is organized as:
	// 		address	|	31-28	|	27-24	|	23-20	|	19-16	|	15-12	|	11-8	|	7-4		|	3-0
	// 		0x800	|	unused	|	c1_r	|	c1_g	|	c1_b	|	unused	|	c0_r	|	c0_g	|	c0_b
	// hdmi_ctrl->VRAM[2000 + 2*color : 2000 + 2*color + 2] = 0x0 << 12 | red << 8 | green << 4 | blue;
	
	// NEED TO CHANGE INDEXING LOGIC - needs to be 32 bits also
	uint32_t color_byte, orig_word, masked_word, new_word;
	int byte_in_word;
	color_byte = 0x0 << 12 | (uint32_t)red << 8 | (uint32_t)green << 4 | (uint32_t)blue;									// assuming colors are lower 4 bits of 8 bits

	orig_word = hdmi_ctrl->palatte[color / 2]; 		//stack overflow said c floor int divisio so blame them if this is wrong
	byte_in_word = color % 2;
	xil_printf("orig: %x\n",orig_word);

	masked_word = orig_word & (0x0000ffff << ((1-byte_in_word)*16));
	xil_printf("masked: %x\n",masked_word);
	new_word = masked_word | (color_byte << (byte_in_word*16));
	xil_printf("new: %x\n",new_word);


//	masked_word = orig_word & (0x0000ffff << ((1-color[0])*16));
//	new_word = masked_word | (color_byte << (color[0]*16));

	hdmi_ctrl->palatte[color / 2] = new_word;	

	// I think this is all that is needed for this function
}


void textHDMIColorScreenSaver()
{
	paletteTest();
	char color_string[80];
    int fg, bg, x, y;
	textHDMIColorClr();
	//initialize palette
	for (int i = 0; i < 16; i++)
	{
		setColorPalette (i, colors[i].red, colors[i].green, colors[i].blue);
	}
	while (1)
	{
		fg = rand() % 16;
		bg = rand() % 16;
		while (fg == bg)
		{
			fg = rand() % 16;
			bg = rand() % 16;
		}
		sprintf(color_string, "Drawing %s text with %s background", colors[fg].name, colors[bg].name);
		x = rand() % (80-strlen(color_string));
		y = rand() % 30;
		textHDMIDrawColorText (color_string, x, y, bg, fg);
		sleep_MB (1);
	}
}

//Call this function for your Week 2 test
hdmiTestWeek2()
{
    //On-chip memory write and readback test
	uint32_t checksum[ROWS], readsum[ROWS];

	for (int j = 0; j < ROWS; j++)
	{
		checksum[j] = 0;
		for (int i = 0; i < COLUMNS * 2; i++)
		{
			hdmi_ctrl->VRAM[j*COLUMNS*2 + i] = i + j;
			checksum[j] += i + j;
		}
	}
	
	for (int j = 0; j < ROWS; j++)
	{
		readsum[j] = 0;
		for (int i = 0; i < COLUMNS * 2; i++)
		{
			readsum[j] += hdmi_ctrl->VRAM[j*COLUMNS*2 + i];
			//printf ("%x \n\r", hdmi_ctrl->VRAM[j*COLUMNS*2 + i]);
		}
		printf ("Row: %d, Checksum: %x, Read-back Checksum: %x\n\r", j, checksum[j], readsum[j]);
		if (checksum[j] != readsum[j])
		{
			printf ("Checksum mismatch!, check your AXI4 code or your on-chip memory\n\r");
			while (1){};
		}
	}
	printf ("Checksum passed, beginning palette test\n\r");
	
	paletteTest();
	printf ("Palette test passed, beginning screensaver loop\n\r");
    textHDMIColorScreenSaver();
}

