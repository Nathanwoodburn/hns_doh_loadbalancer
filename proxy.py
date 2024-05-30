import socket
from dnslib.server import DNSHandler, BaseResolver, DNSServer, DNSLogger
from dnslib import DNSRecord
import time

UDP_IP = '127.0.0.1'
UDP_PORT = 5350
TCP_IP = '0.0.0.0'
TCP_PORT = 5351

logger = DNSLogger(log="none")

class TCPHandler(DNSHandler):
    def handle(self):
        try:
            while True:
                data = self.request.recv(1024).strip()
                if not data:
                    break
                with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as udp_socket:
                    udp_socket.sendto(data, (UDP_IP, UDP_PORT))
                    response_data, _ = udp_socket.recvfrom(1024)
                self.request.sendall(response_data)
        except Exception as e:
            print(e)


class SimpleResolver(BaseResolver):
    def resolve(self, request, handler):
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as udp_socket:
                udp_socket.sendto(request.pack(), (UDP_IP, UDP_PORT))
                response_data, _ = udp_socket.recvfrom(1024)
            dns_response = DNSRecord.parse(response_data)
            return dns_response
        except Exception as e:
            return request.reply()


def start_tcp_server():
    server = DNSServer(SimpleResolver(), address=TCP_IP, port=TCP_PORT, tcp=True, logger=logger)
    print(f"TCP server listening on {TCP_IP}:{TCP_PORT}")
    server.start()

if __name__ == "__main__":
    start_tcp_server()
    print("Started")
