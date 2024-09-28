SECTIONS
{
    . = 0;
    .text (READONLY) : {
        *(.text)
        . = 128*4;
    }
    .data (READONLY) : {
        *(.data)
        . = 128*4;
    }
}

