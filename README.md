# Direct Mapped Cache

## Overview
A direct mapped cache controller implemented in VHDL on a Xilinx Spartan-3E FPGA. The system implements a simple cache with 256 bytes of storage, organized into 32 words of 1 byte each, displaying hit and miss behaviour using ChipScope verification.


## Requirements
### Hardware

### Software

## How it Works

## Architecture

## Results

<img width="1696" height="577" alt="image" src="https://github.com/user-attachments/assets/b20168f6-1245-42b7-a4ed-a8240b03ab1a" />

*Case 1: Read hit*

<img width="1708" height="579" alt="image" src="https://github.com/user-attachments/assets/17975ea7-9337-4656-9fe6-58bc61f2b5a0" />

*Case 2: Write hit*

<img width="1711" height="584" alt="image" src="https://github.com/user-attachments/assets/7e80cd73-0d7e-4e47-8b9c-e3fc257c18b0" />

*Case 3: Miss with dirty bit = 0*

<img width="1691" height="590" alt="image" src="https://github.com/user-attachments/assets/5edd7710-4b54-4e4b-9b0f-c0b9c40fc0b8" />

*Case 4: Miss with dirty bit = 1*

Below are some performance parameters of the cache.

| # | Cache Performance Parameter | Time (ns) |
|---|----------------------------|-----------|
| 1 | Hit/Miss determination time | 20 |
| 2 | Data access time | 80 |
| 3 | Block Replacement time | 2600 |
| 4 | Hit time (Case 1 and 2) | 20 |
| 5 |  Miss Penalty for Case 3 (D-bit = 0) | 1320 |
| 6 | Miss Penalty for Case 4 (D-bit = 1) | 2620 |

