from flask import Flask, request
import socket
import threading
import pyautogui

app = Flask(__name__)

# Disable failsafe to prevent script from stopping if mouse hits a corner
pyautogui.FAILSAFE = False

# UDP for low-latency mouse movement
UDP_PORT = 5005

def udp_listener():
    """Handle mouse movement over UDP for minimal latency."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(('0.0.0.0', UDP_PORT))
    print(f"UDP listener started on port {UDP_PORT}")

    while True:
        data, addr = sock.recvfrom(1024)
        try:
            # Expected format: "dx,dy"
            dx, dy = map(float, data.decode('utf-8').split(','))
            pyautogui.moveRel(dx, dy)
        except:
            pass

@app.route('/control', methods=['POST'])
def control():
    data = request.json
    action = data.get('action')

    if action == 'move':
        # Fallback HTTP move (UDP preferred)
        pyautogui.moveRel(data['x'], data['y'])
    elif action == 'left_click':
        pyautogui.click(button='left')
    elif action == 'right_click':
        pyautogui.click(button='right')
    elif action == 'type':
        pyautogui.write(data['text'])
    elif action == 'key':
        pyautogui.press(data['key'])

    return {"status": "success"}

if __name__ == '__main__':
    # Start UDP listener in background thread
    udp_thread = threading.Thread(target=udp_listener, daemon=True)
    udp_thread.start()

    # Start Flask for HTTP commands (clicks, keyboard)
    print("Flask server starting on port 5050")
    app.run(host='0.0.0.0', port=5050)
