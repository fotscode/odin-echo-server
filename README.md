# Echo Server in Odin

This project is a TCP **Echo Server** implemented in the [Odin programming language](https://odin-lang.org/). It is designed to demonstrate and test the capabilities of Odin in handling network communication. It handles multiple client connections.

## What is an Echo Server?

An Echo Server is a simple network server that sends back to the client whatever data it receives. It is often used as a basic example to test networking functionality.

## Requirements

- [Odin Compiler](https://odin-lang.org/download/) (latest stable version).
- A terminal or command prompt to run the application.

## Installation and Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/fotscode/odin-echo-server.git
   cd odin-echo-server
   ```
2. Run the server:
    ```bash
    odin run sv.odin -file
    ```
3. Run one or more clients:
    ```bash
    odin run cli.odin -file
    ```
4. Or use `telnet`:
    ```bash
    telnet 127.0.0.1 8080
    ```

To terminate the client send `Ctrl-D` or `Ctrl-C` or an empty line pressing *Enter* (`\r\n`, `\n`).
