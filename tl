import requests
import time
import json

# Discord Webhook URL
webhook_url = "YOUR_DISCORD_WEBHOOK_URL"

# Server URL for status check
status_url = "https://www.playthroneandliberty.com/en-gb/support/server-status"

# Previous status to detect changes
previous_status = None

def check_server_status():
    global previous_status
    try:
        # Send a request to the server status page
        response = requests.get(status_url)
        response.raise_for_status()
        
        # Parse the HTML content (or JSON if it's available directly)
        content = response.text
        
        # Look for the server status info, update this line based on actual HTML structure
        server_status = "up" if "Amos server is up" in content else "down"
        
        # Check if there's a change in server status
        if server_status != previous_status:
            previous_status = server_status
            post_to_discord(server_status)
    
    except Exception as e:
        print(f"An error occurred: {e}")

def post_to_discord(status):
    # Message based on server status
    message = f"Amos server is now {status}."
    
    # Sending the message to Discord via webhook
    payload = {
        "content": message
    }
    headers = {
        "Content-Type": "application/json"
    }
    response = requests.post(webhook_url, data=json.dumps(payload), headers=headers)
    if response.status_code == 204:
        print("Message sent successfully.")
    else:
        print("Failed to send message.")

# Run check periodically (every 5 minutes)
while True:
    check_server_status()
    time.sleep(300)  # Wait 5 minutes before checking again
