package main

import "core:fmt"
import "core:net"
import "core:os"

tcp_cli:: proc(ip:string, port: int) {
    local_addr, ok := net.parse_ip4_address(ip)
    if !ok {
        fmt.println("Failed to parse IP address")
        return
    }
    sock, err :=net.dial_tcp_from_address_and_port(local_addr,port)
    if err != nil {
        fmt.println("Failed to connect to server")
        return
    }
    for true {
        buf:[256]u8
        n, errRead := os.read(os.stdin, buf[:])
        if errRead != nil {
            fmt.println("Failed to read data")
            break
        }
        if (n == 0 || (n==1 && buf[0] == '\n')) {
            net.close(sock)
            break
        }
        bytesSent, errSend := net.send_tcp(sock, buf[:n])
        if errSend != nil {
            fmt.println("Failed to send data")
            break
        }
        bytes, errRecv := net.recv_tcp(sock, buf[:])
        if errRecv != nil {
            fmt.println("Failed to receive data")
            break
        }
        fmt.println("Client received: ", string(buf[:bytes]))
    }
    net.close(sock)
}

main :: proc() {
    tcp_cli("192.168.1.87", 8080)
}
