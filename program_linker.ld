SECTIONS
{
    .text : AT(0x0)
    {
        *(.text)
        . = 0x200;
    }

    .data : AT(0x200) 
    {
        *(.data)
        . = 0x200;
    }
}

