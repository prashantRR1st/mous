from flask import Flask, request
# import socket
import pyautogui

app = Flask(__name__)

# Disable failsafe to prevent script from stopping if mouse hits a corner
pyautogui.FAILSAFE = False

@app.route('/control', methods=['POST'])
def control():
    data = request.json
    print(f"data: {data}")
    action = data.get('action')

    if action == 'move':
        # Moves mouse relative to current position
        pyautogui.moveRel(data['x'], data['y'])
    elif action == 'left_click':
        pyautogui.click(button='left')
    elif action == 'right_click':
        pyautogui.click(button='right')
    elif action == 'type':
        pyautogui.write(data['text'])

    return {"status": "success"}

if __name__ == '__main__':
    # '0.0.0.0' allows iPhone to find the computer on the local network
    app.run(host='0.0.0.0', port=5050)

# # Set up the server
# UDP_IP = "0.0.0.0" # Listen on all network interfaces
# UDP_PORT = 5005
# sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) #UDP is faster for mouse movement
# sock.bind((UDP_IP, UDP_PORT))

# print(f"Server started. Point your iPhone to port {UDP_PORT}")

# while True:
#     data, addr = sock.recvfrom(1024) # buffer_size  = 1024b
#     message = data.decode('utf-8')

#     try:
#         # Expected data format: "dx,dy"
#         dx, dy = map(float, message.split(','))
#         pyautogui.moveRel(dx,dy) # move relative to current position
#     except:
#         pass
        
