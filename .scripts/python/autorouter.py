#!/usr/bin/env python3
import asyncio
from playwright.async_api import async_playwright

# Config
ROUTER_URL = "https://192.168.1.1:8000"
USERNAME = "admin"
PASSWORD = "ibUqz6B9"
LOCAL_IP = "192.168.1.164"

async def run():
    # Spawn process to curl ipconfig.me
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

    print(f"Public IP: {GLOBAL_IP} | Local IP: {LOCAL_IP}")

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(ignore_https_errors=True)
        page = await context.new_page()

        # 1. Initial Login
        print("Logging in...")
        await page.goto(ROUTER_URL)
        
        login_frame = page.frame_locator('frame[name="mainFrame"], iframe[name="mainFrame"]')
        pwd = login_frame.locator('input[type="password"]')
        if await pwd.count() == 0:
            pwd = page.locator('input[type="password"]')

        await pwd.wait_for(state="visible", timeout=5000)
        await pwd.fill(PASSWORD)
        await pwd.press("Enter")

        print("Navigating directly to nataddrmap.asp...")
        await page.goto(f"{ROUTER_URL}/nataddrmap.asp")
        await page.wait_for_load_state("networkidle")

        if "login.asp" in page.url:
            print("Redirected to login.asp. Re-authenticating...")
            await page.locator('input[type="text"]').first.fill(USERNAME)
            await page.locator('input[type="password"]').fill(PASSWORD)
            await page.locator('input[type="password"]').press("Enter")
            # After re-login, ensure we are actually on the mapping page
            if "nataddrmap.asp" not in page.url:
                await page.goto(f"{ROUTER_URL}/nataddrmap.asp")
            await page.wait_for_load_state("networkidle")

        main_frm = page.frame_locator('frame[name="mainFrm"]')
        
        print("Opening index 0...")
        index_link = main_frm.locator('td a', has_text="0").first
        if await index_link.count() == 0:
            index_link = page.locator('td a', has_text="0").first
            
        await index_link.wait_for(state="visible")
        await index_link.click()

        target = main_frm if await main_frm.locator('input[type="text"]').count() > 0 else page
        all_inputs = target.locator('input[type="text"]')
        
        local_octets = LOCAL_IP.split(".")
        for i, octet in enumerate(local_octets):
            await all_inputs.nth(i).fill(octet)

        global_octets = GLOBAL_IP.split(".")
        #await all_inputs.nth(4).wait_for(state="visible")
        for i, octet in enumerate(global_octets):
            await all_inputs.nth(4 + i).fill(octet)

        print("Applying changes...")
        apply_btn = target.locator('input[type="submit"][value="Apply"]').first
        await apply_btn.click()
        
        print("Done.")
        await browser.close()

if __name__ == "__main__":
    asyncio.run(run())
