
#include <RadioHead/RadioHead.h>

#define RFPIN 12
#define BITSPERSEC 4000

#define REDPIN 5
#define GREENPIN 6
#define BLUEPIN 3 

int[8] redBits, blueBits, greenBits;
int r,g,b;
int bitCount = 0;
int* currentlyEditing;
void setup()
{
    vw_set_ptt_inverted(true); // Required for DR3100
    vw_set_rx_pin(RFPIN);
    vw_setup(BITSPERSEC);  // Bits per sec

    pinMode(REDPIN, OUTPUT);
    pinMode(GREENPIN, OUTPUT);
    pinMode(BLUEPIN, OUTPUT);

    vw_rx_start();       // Start the receiver PLL running
}
void loop()
{
    uint8_t buf[VW_MAX_MESSAGE_LEN];
    uint8_t buflen = VW_MAX_MESSAGE_LEN;

    if (vw_get_message(buf, &buflen)) // Non-blocking
    {
    	//make sure we're editing the right color
    	if(bitCount<8)
    	{
    		currentlyEditing = redBits;
    	}
    	else if (bitCount <16)
    	{
    		currentlyEditing = greenBits;
    	}
    	else if (bitCount<24)
    	{
    		currentlyEditing = blueBits;
    	}

	    if(buf[0]=='1')
        {
   	    	currentlyEditing[bitcount%8] = 1;
        }  
   	    if(buf[0]=='0')
   	    {
  	  	  currentlyEditing[bitcount%8] = 0;
        }
        attemptBindBits();
	}
}

void attemptBindBits()
{
    bitCount++; //this is in this function to allow us to reset the bitcount in the last condition

	if(bitCount==8)
	{
		r = convertToDecimal(currentlyEditing);
	}
	else if (bitCount ==16)
	{
		g = convertToDecimal(currentlyEditing);
	}
	else if (bitCount==24)
	{
		b = convertToDecimal(currentlyEditing);
		changeLED();
		bitcount = 0;
	}
}
int convertToDecimal(int[] arr)
{
	int sum = 0;
	int len = sizeof(arr)/sizeof(arr[0]); // should always be 8
	for(int i=0;i<len; i++)
	{
		if(arr[i]==1)
		{
			sum+=pow(2,i);
		}
	}
	return sum;

}
void changeLED()
{
	analogWrite(REDPIN, r);
	analogWrite(GREENPIN, g);
	analogWrite(BLUEPIN, b);

}