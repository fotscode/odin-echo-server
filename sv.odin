package main

import "core:fmt"
import "core:net"
import "core:strings"
import "core:thread"

is_ctrl_d :: proc (bytes: [256]u8, bytes_read: int) -> bool {
    return bytes_read == 1 && bytes[0] == 4
}

// checks if ends with \r\n or \n
is_empty :: proc (bytes: [256]u8, bytes_read: int) -> bool {
    return (bytes_read == 2 && bytes[0] == 13 && bytes[1] == 10) ||
            (bytes_read == 1 && bytes[0] == 10)
}

is_telnet_ctrl_c :: proc (bytes: [256]u8, bytes_read: int) -> bool {
    return (bytes_read == 3 && bytes[0] == 255 && bytes[1] == 251 && bytes[2] == 6) ||
           (bytes_read == 5 && bytes[0] == 255 && bytes[1] == 244 && bytes[2] == 255 && bytes[3] == 253 && bytes[4] == 6)
}

handle_msg :: proc(sock: net.TCP_Socket) {
    for true {
        buffer:= [256]u8{}
        bytes, errRecv := net.recv_tcp(sock, buffer[:])
        if errRecv != nil {
            fmt.println("Failed to receive data")
        }
        if bytes==0 || is_ctrl_d(buffer, bytes) || is_empty(buffer, bytes) || is_telnet_ctrl_c(buffer, bytes) {
            fmt.println("Disconnecting client")
            break
        }
        message, errClone:= strings.clone_from_bytes(buffer[:])
        if  errClone != nil {
            fmt.println("Failed to clone bytes")
        }
        fmt.println("Server received: ",message)
        bytesSent, errSend := net.send_tcp(sock, buffer[:bytes])
        if errSend != nil {
            fmt.println("Failed to send data")
        }
        fmt.println("Server sent: ",message)
    }
    net.close(sock)
}

tcp_echo_server :: proc(ip:string, port:int){
    local_addr, ok := net.parse_ip4_address(ip)
    if !ok {
        fmt.println("Failed to parse IP address")
        return
    }
    endpoint := net.Endpoint {
        address= local_addr,
        port= port,
    }
    sock, err := net.listen_tcp(endpoint)
    if err != nil {
        fmt.println("Failed to listen on TCP")
        return
    }
    fmt.println(strings.concatenate({"Listening on TCP: ",net.endpoint_to_string(endpoint)}))
    for true {
        cli, source, err := net.accept_tcp(sock)
        if err != nil {
            fmt.println("Failed to accept TCP connection")
        }
        thread.create_and_start_with_poly_data(cli, handle_msg)
    }
    net.close(sock)
    fmt.println("Closed socket")

}

main :: proc() {
    tcp_echo_server("192.168.1.87", 8080)
}
