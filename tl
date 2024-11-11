import requests
import time
import json
from datetime import datetime

# Discord Webhook URL
webhook_url = "YOUR_DISCORD_WEBHOOK_URL"

# Server URL for status check
status_url = "https://www.playthroneandliberty.com/en-gb/support/server-status"

# Previous status to detect changes
previous_status = None

def check_server_status():
    global previous_status
    try:
        # Simulate alternating status for testing
        server_status = "up" if previous_status == "down" else "down"
        
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

def main():
    while True:
        now = datetime.now()
        day_of_week = now.weekday()
        hour = now.hour
        minute = now.minute

        # Check every 30 seconds for testing
        check_server_status()
        
        # Test Wednesday check (adjust as needed for current time)
        if day_of_week == datetime.now().weekday():  # Testing with current day
            if hour == datetime.now().hour:  # Testing with current hour
                if minute % 2 == 0:  # Testing every 2 minutes instead of 30 mins
                    time.sleep(30)  # Testing interval, 30 seconds
                    continue

        # Default testing interval every 30 seconds
        time.sleep(30)

# Run the main loop
main()

