#!/usr/bin/env python3
#import time
import asyncio
from playwright.async_api import async_playwright

# Config
ROUTER_URL = "https://192.168.1.1:8000"
USERNAME = "admin"
PASSWORD = "ibUqz6B9"
LOCAL_IP = "192.168.1.164"
EXTERNAL_PORT = "9000"
EXTERNAL_PORT_TO = "9010"
INTERNAL_PORT = "9000"
TARGET_INDEX = "3"

async def run():
    proc = await asyncio.create_subprocess_shell(
        "curl -Ls ipconfig.me",
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )
    stdout, _ = await proc.communicate()
    GLOBAL_IP = stdout.decode().strip()
    
    if not GLOBAL_IP:
        print("Error: Could not retrieve IP.")
        return

    print(f"IP: {GLOBAL_IP} | Index: {TARGET_INDEX} | Port Range: {EXTERNAL_PORT} - {EXTERNAL_PORT_TO}")

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(ignore_https_errors=True)
        page = await context.new_page()

        # 2. Initial Login
        print("Logging in...")
        await page.goto(ROUTER_URL)
        
        login_frame = page.frame_locator('frame[name="mainFrame"], iframe[name="mainFrame"]')
        pwd = login_frame.locator('input[type="password"]')
        if await pwd.count() == 0:
            pwd = page.locator('input[type="password"]')

        await pwd.wait_for(state="visible", timeout=5000)
        await pwd.fill(PASSWORD)
        await pwd.press("Enter")

        await page.goto(f"{ROUTER_URL}/natportmap.asp")
        await page.wait_for_load_state("networkidle")

        if "login.asp" in page.url:
            print("Redirected to login.asp. Re-authenticating...")
            await page.locator('input[type="text"]').first.fill(USERNAME)
            await page.locator('input[type="password"]').fill(PASSWORD)
            await page.locator('input[type="password"]').press("Enter")
            if "natportmap.asp" not in page.url:
                await page.goto(f"{ROUTER_URL}/natportmap.asp")
            await page.wait_for_load_state("networkidle")

        # 5. Open specific Index link
        main_frm = page.frame_locator('frame[name="mainFrm"]')
        index_link = main_frm.locator('td a', has_text=TARGET_INDEX).first
        if await index_link.count() == 0:
            index_link = page.locator('td a', has_text=TARGET_INDEX).first
            
        await index_link.wait_for(state="visible")
        await index_link.click()

        # 6. Fill Details based on Image Layout
        target = main_frm if await main_frm.locator('input[type="text"]').count() > 0 else page
        all_inputs = target.locator('input[type="text"]')
        await all_inputs.first.wait_for(state="visible")

        # EXTERNAL PORT (Start: nth(4), End: nth(5))
        await all_inputs.nth(4).fill(EXTERNAL_PORT)
        await all_inputs.nth(5).fill(EXTERNAL_PORT_TO)

        # INTERNAL IP (Octets 6, 7, 8, 9)
        local_octets = LOCAL_IP.split(".")
        for i, octet in enumerate(local_octets):
            await all_inputs.nth(6 + i).fill(octet)

        # INTERNAL PORT (nth 10)
        await all_inputs.nth(10).fill(INTERNAL_PORT)

        print("Applying changes...")
        await target.locator('input[type="submit"][value="Apply"]').first.click()
        print("Done.")
        await browser.close()

if __name__ == "__main__":
    asyncio.run(run())
