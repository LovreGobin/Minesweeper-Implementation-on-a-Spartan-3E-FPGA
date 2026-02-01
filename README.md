DESCRIPTION OF USED HARDWARE AND SOFTWARE

In this section of the paper, the hardware and software components used in the development of the Minesweeper game for a VGA display are presented. The central element of the system is the Xilinx Spartan-3E FPGA chip. This development board provides the necessary resources for implementing more complex digital circuits, including VGA output, input buttons, LEDs, and other peripherals useful for development.

The Xilinx ISE development tool was used for designing and testing the digital logic. It enables writing HDL code, its synthesis, as well as functional and timing simulation. The project was developed in the Verilog language, with implemented modules for VGA signal generation, game rendering, and the core Minesweeper game logic. The system functionality was tested by connecting it to a VGA monitor.

The Spartan-3E Starter Board represents a powerful and technically advanced development platform intended for projects based on the Xilinx Spartan-3E FPGA. This board provides everything necessary for developing and testing digital circuits and systems within a compact and self-contained environment.

At the heart of the board is a Spartan-3E FPGA with a capacity of 500 thousand logic gates, enabling the implementation of complex digital designs, including graphical output control, user interfaces, and various algorithms. Additionally, the board integrates a 32-bit RISC processor, further expanding data processing capabilities, and supports a DDR SDRAM memory interface, allowing operation with larger data volumes and higher speeds. [1]

The most important technical features include:

• FPGA chip: More than 10,000 logic cells (Spartan-3E XC3S500E)
• Configuration memory: 4 Mbit Platform Flash PROM
• Main memory: 64 MB DDR SDRAM (x16 interface, over 100 MHz)
• Flash memory: 16 MB NOR Flash (Intel StrataFlash), 16 Mbit SPI Flash (STMicro)
• Clock oscillator: 50 MHz, used as the main system clock

• I/O connectors and peripherals:
o VGA port for video output
o 4 user buttons and 4 slide switches
o 8 user LEDs
o PS/2 port for mouse or keyboard
o LCD display (2 rows, 16 characters)
o RS-232 serial ports (2 units, DTE and DCE)
o 3 Pmod connectors for additional modules
o FX2 Hirose expansion connector
o 8-pin DIP socket for auxiliary oscillators

Electrical characteristics:
• Power supply: universal adapter (100–240V, 50/60 Hz)
• Logic signal level: 3.3 V

Dimensions:
• Width: 6.0 inches (15.24 cm)
• Length: 7.0 inches (17.78 cm)

To better understand the board itself, it is first important to consider the concept of an FPGA. An FPGA (Field-Programmable Gate Array) is a programmable logic device that can be configured after manufacturing according to the user’s needs. Unlike traditional processors that execute instructions sequentially, an FPGA enables parallel data processing through a network of programmable logic blocks and interconnections between them [2].

This programmability makes FPGAs highly adaptable for developing complex digital systems, such as video signal control, digital filter implementation, or even complete computer architectures. FPGA programming is typically performed using hardware description languages such as Verilog or VHDL, which provide precise control over hardware behavior.

In this project, the Xilinx Spartan-3E FPGA is used, which is suitable for implementing medium-scale digital solutions. The appearance of the board is shown in the image below.

<img width="631" height="631" alt="image" src="https://github.com/user-attachments/assets/b5f2d30a-7652-415c-b850-d649c71a4bea" />

In the image, key components of the board used in this project are marked with numbers from 1 to 7. Below is a brief description of each:

Power Jack: Input for external power supply that powers the entire board.

USB Ports: Used for communication with a computer, data transfer, FPGA programming, or powering peripherals.

VGA Connector: Used to connect an external display or monitor. The FPGA generates the video signal displayed via this connector.

PS/2 Port: Historically used for connecting a mouse or keyboard. On development boards like this one, it is commonly used for demo applications or user interaction.

Array of 8 LEDs: Used for visual indication of digital outputs, system status, or programming exercises.

DIP Switches: Small switches used for board configuration, mode selection, or as digital inputs.

Potentiometer and 4 Push Buttons: The potentiometer provides analog input (e.g., speed or brightness adjustment), while the buttons serve as digital user inputs.

MINESWEEPER

The game code was written in Verilog HDL (Hardware Description Language), which is used for modeling and designing digital systems. Synthesis and FPGA programming are enabled through the Xilinx ISE Design Suite software. The image below shows the beginning of the code and the definition of the “Ploca” module.

<img width="881" height="898" alt="image" src="https://github.com/user-attachments/assets/3bc5cc53-76b6-45cd-93c8-275670f642c1" />

We have an input clock signal CLK with a frequency of 50 MHz, PS2_DATA and PS2_CLK inputs for receiving data and clock signals from the mouse connected via the PS/2 connector. There is also a reset button and a switch for enabling or disabling display output. VGA synchronization signals follow for the monitor displaying the game. Using VGA_R, VGA_G, and VGA_B outputs, colors are displayed on the screen (8 total combinations, i.e., 8 different colors).

Next is the clock divider (clk25 with a frequency of 25 MHz). Below are defined screen parameters for a resolution of 640 × 480 pixels. Horizontal pixel counter (h_counter) and vertical row counter (v_counter) are used to define areas where game elements are displayed. Grid parameters follow: cell size is 16 × 16 pixels, and the grid size is 8 × 8 (64 cells). GRID_X_OFFSET and GRID_Y_OFFSET define the grid’s reference position.

<img width="813" height="1042" alt="image" src="https://github.com/user-attachments/assets/81020f11-908b-43a9-80a0-bba55a2cc204" />

This section enables mouse control. Signals mouse_x and mouse_y represent relative mouse movement in pixels. The mouse_btn signal indicates left, middle, or right click, while mouse_done_tick signals an update. After instantiating the mouse module, cursor position registers are defined. By default, the cursor is placed at the screen center on startup or reset. Cursor position is updated on the clock signal with sensitivity adjustment. A ROM for rendering the cursor arrow is defined at the bottom.

<img width="934" height="969" alt="image" src="https://github.com/user-attachments/assets/774cd467-37f3-48dc-a92a-2858b5139117" />

Signals sprite_x and sprite_y represent the pixel’s relative position to the cursor. sprite_area indicates whether the pixel is inside an 8 × 8 area. sprite_x_rel and sprite_y_rel index into the arrow ROM. sprite_bit determines whether the pixel should be drawn. Similar logic is applied for all other game elements.

The following section updates horizontal and vertical counters and synchronization bits on the rising edge of the 25 MHz clock. The grid register defines grid rendering positions. cursor_in_grid limits gameplay to the grid area. grid_row and grid_col calculate the current cell index.

<img width="951" height="888" alt="image" src="https://github.com/user-attachments/assets/bdfe878d-7ecb-4ee3-a55a-e67607cfd6bf" />

The seed_counter register enables random mine placement using a shift register. Memory “polje” holds 64 4-bit values describing each cell’s content (empty, number, mine). Modules for left and right mouse click handling are instantiated. cell_state memory stores each cell’s state (closed, opened, flagged). The following code block defines the core game logic.

<img width="923" height="1342" alt="image" src="https://github.com/user-attachments/assets/14be050e-e759-4d5d-b50b-9abdbe2d114b" />

In addition to “polje”, the “zero_opening” memory enables automatic opening of adjacent empty cells. The always block resets parameters on game reset. Reset can be triggered via button or middle mouse click if the game is won or lost. The remaining logic handles left and right mouse clicks, opening cells, placing flags, detecting mines, win conditions, and triggering the flood-fill logic.

<img width="617" height="1342" alt="image" src="https://github.com/user-attachments/assets/5ab205e4-6284-4bfa-9987-f4355e759d0b" />

This part processes empty cell expansion using zero_opening and processing_zero. Neighboring cells are checked and opened accordingly. When all are processed, processing_zero is disabled. Clicking on a mine reveals all mines.

<img width="770" height="1049" alt="image" src="https://github.com/user-attachments/assets/138652dc-2712-4aa4-9f28-e289e2a8a7e1" />

Mine placement logic is handled via states PLACE_MINES, COUNT_MINES, and DONE. Mines are generated randomly using an LFSR and seed_counter until 10 mines are placed. Afterward, neighboring mine counts are calculated.

<img width="798" height="1086" alt="image" src="https://github.com/user-attachments/assets/6df7df35-cc0e-49b2-a6a9-fca2f7f79f79" />

ROMs define the visual representation of numbers, mines, flags, and smiley faces. Due to coordinate orientation, characters are rotated 180 degrees. Logic for displaying win/lose smileys is shown below.

<img width="841" height="605" alt="image" src="https://github.com/user-attachments/assets/231293bc-35b0-43c2-983b-843b541988ce" />

The next image shows rendering logic for cell elements.

<img width="951" height="899" alt="image" src="https://github.com/user-attachments/assets/893cb466-d9f9-4ff6-b4a8-cec636a73e6e" />

The final part assigns color values to VGA_R, VGA_G, and VGA_B outputs. Rendering priorities ensure correct layering of elements.

<img width="612" height="1269" alt="image" src="https://github.com/user-attachments/assets/5aef618c-e9f5-44f4-bfe2-60eb5e18bd85" />

CONCLUSION

The project of implementing the Minesweeper game on an FPGA platform using VGA output and a PS/2 mouse proved to be both challenging and educational. Through this project, we demonstrated how a functional video game can be realized using digital logic, the Verilog language, and basic peripheral devices.

The main goal was achieved through a fully functional version of the classic Minesweeper game, including core mechanics such as cell revealing, flag placement, and win/loss detection. One of the key aspects was the implementation of a VGA controller for standard monitor output. Special attention was given to precise user input handling via the PS/2 mouse protocol.

A particular challenge was the implementation of the flood-fill algorithm for automatically opening adjacent empty cells, requiring careful memory and state management. The project highlighted the importance of a modular design approach, with separate modules for mouse handling, VGA generation, and game logic.

Using ROMs for storing graphical elements proved efficient and resource-friendly. While all project goals were met, future improvements could include larger grids, additional features such as a timer and difficulty levels, and improved user interface design.

Through this project, valuable experience was gained in FPGA development, digital logic design, and applying theoretical knowledge in practical applications. Minesweeper on FPGA not only validated the functionality of the solution but also demonstrated the power of FPGA platforms for interactive application development.
