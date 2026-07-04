#!/usr/bin/env python3
import http.server
import socketserver
import os
import sys

PORT = 8086
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

def main():
    os.chdir(DIRECTORY)
    # Permite reuso rápido da porta após desligar o servidor
    socketserver.TCPServer.allow_reuse_address = True
    
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"==================================================")
        print(f"Disable ZRAM on Boot - Dashboard Server")
        print(f"Servindo arquivos de: {DIRECTORY}")
        print(f"Acesse em seu navegador: http://localhost:{PORT}")
        print(f"==================================================")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServidor finalizado pelo usuario.")
            sys.exit(0)

if __name__ == "__main__":
    main()
