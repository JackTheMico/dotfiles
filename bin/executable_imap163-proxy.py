#!/usr/bin/env python3
"""mbsync 的 163 邮箱 IMAP Tunnel 代理。

背景：163 的 Coremail IMAP 服务器强制要求客户端在会话中发送 IMAP ID
命令，否则 SELECT 会被拒绝（`NO SELECT Unsafe Login`）。而 mbsync/isync
不支持发送 ID 命令，导致无法同步 163 邮箱。

本脚本作为 mbsync 的 Tunnel（见 .mbsyncrc 的 Tunnel 选项）工作：
1. 建立到 imap.163.com:993 的 TLS 连接（证书走系统 CA 校验）；
2. 读取服务器的欢迎语（`* OK ...`）；
3. 在 mbsync 发出任何命令之前，替客户端发送一次 `ID` 命令，
   并完整消费其响应（`* ID (...)` + tagged 完成行），不污染 mbsync 的
   协议解析——mbsync 看到的是一条干净、正常的 IMAP 会话；
4. 把欢迎语原样转交给 mbsync（stdout）；
5. 之后进入 stdin <-> 服务器的纯双向透传，直到任一端 EOF。

凭据（账号/授权码）由 mbsync 通过隧道发送 LOGIN，本脚本不接触任何密码。
"""

import os
import select
import socket
import ssl
import sys

HOST = "imap.163.com"
PORT = 993

# 网易 Coremail 对 ID 内容本身不挑剔，name/version 写真实值即可。
# tag 用 "a1"，与 mbsync 自增数字 tag 不会冲突，且该响应会被本脚本消费掉。
ID_CMD = b'a1 ID ("name" "isync" "version" "1.5.1")\r\n'
ID_TAG = b"a1 "
READ_CHUNK = 65536
DEBUG = os.environ.get("IMAP163_DEBUG")


def dbg(msg):
    if DEBUG:
        print(f"imap163-proxy: {msg}", file=sys.stderr, flush=True)



def recv_line(sock):
    """从 socket 读取一行（以 \\r\\n 结尾），返回不含行尾符的 bytes。"""
    buf = bytearray()
    while True:
        b = sock.recv(1)
        if not b:
            raise EOFError("connection closed by server mid-line")
        buf += b
        if buf.endswith(b"\r\n"):
            return bytes(buf[:-2])


def main():
    try:
        raw = socket.create_connection((HOST, PORT), timeout=30)
        ctx = ssl.create_default_context()
        sock = ctx.wrap_socket(raw, server_hostname=HOST)
    except Exception as e:
        print(f"imap163-proxy: connection failed: {e}", file=sys.stderr)
        return 1

    try:
        # 1. 读服务器欢迎语（例如 `* OK Coremail System IMap Server Ready(...)`）
        banner = recv_line(sock)
        dbg(f"banner: {banner!r}")

        # 2. 注入 ID 并消费其完整响应（untagged 行 + tagged 完成行）
        sock.sendall(ID_CMD)
        while True:
            line = recv_line(sock)
            dbg(f"id-resp: {line!r}")
            if line.startswith(ID_TAG):
                break

        # 3. 把欢迎语转交给 mbsync，之后 mbsync 才会开始发命令
        out = sys.stdout.buffer
        out.write(banner + b"\r\n")
        out.flush()

        # 4. 双向透传
        sin = sys.stdin.buffer
        while True:
            r, _, _ = select.select([sock, sin], [], [])
            if sock in r:
                data = sock.recv(READ_CHUNK)
                dbg(f"main recv: {len(data)}B {data[:48]!r}")
                if not data:
                    break
                out.write(data)
                out.flush()
            if sin in r:
                data = os.read(sin.fileno(), READ_CHUNK)
                if not data:
                    # mbsync 关闭了写端 = 会话结束，它已处理完所有需要的响应。
                    # 注意：千万不要在 shutdown(SHUT_WR) 之后继续 recv ——
                    # CPython 的 SSLSocket.shutdown() 之后 SSL 层停止解密，
                    # recv 会返回 TLS 密文原始字节，污染 mbsync 的协议解析。
                    dbg("stdin EOF: session over, exiting")
                    return 0
                dbg(f"stdin read: {len(data)}B")
                sock.sendall(data)
    except (EOFError, ConnectionError, OSError) as e:
        print(f"imap163-proxy: tunnel ended: {e}", file=sys.stderr)
        return 1
    finally:
        try:
            sock.close()
        except Exception:
            pass
    return 0


if __name__ == "__main__":
    sys.exit(main())
