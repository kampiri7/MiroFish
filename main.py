#!/usr/bin/env python3
"""
MiroFish - A fishing bot/automation tool
Main entry point for the application.
"""

import os
import sys
import logging
import asyncio
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Configure logging
log_level = os.getenv("LOG_LEVEL", "INFO").upper()
logging.basicConfig(
    level=getattr(logging, log_level, logging.INFO),
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=[
        logging.StreamHandler(sys.stdout),
        # Log to the logs/ directory instead of the project root
        logging.FileHandler("logs/mirofish.log", encoding="utf-8"),
    ],
)
logger = logging.getLogger("mirofish")


def check_environment() -> bool:
    """
    Validate that all required environment variables are set.
    Returns True if all required vars are present, False otherwise.
    """
    required_vars = [
        "BOT_TOKEN",
        "CHANNEL_ID",
    ]
    missing = [var for var in required_vars if not os.getenv(var)]
    if missing:
        logger.error("Missing required environment variables: %s", ", ".join(missing))
        logger.error("Please copy .env.example to .env and fill in the required values.")
        return False
    return True


async def main() -> None:
    """
    Main async entry point. Initializes and starts the MiroFish bot.
    """
    logger.info("Starting MiroFish...")

    if not check_environment():
        sys.exit(1)

    # Import here to avoid issues if env vars are missing
    from bot import MiroFishBot

    bot_token = os.getenv("BOT_TOKEN")
    channel_id = int(os.getenv("CHANNEL_ID", "0"))
    # Changed default to false -- debug mode was spamming my logs during normal use
    debug_mode = os.getenv("DEBUG", "false").lower() == "true"

    if debug_mode:
        logger.setLevel(logging.DEBUG)
        logger.debug("Debug mode enabled")

    bot = MiroFishBot(
        token=bot_token,
        channel_id=channel_id,
        debug=debug_mode,
    )

    try:
        logger.info("Bot initialized, connecting to Discord...")
        await bot.start()
    except KeyboardInterrupt:
        logger.info("Received interrupt signal, shutting down...")
    except Exception as e:
        logger.exception("Unexpected error occurred: %s", e)
        sys.exit(1)
    finally:
        await bot.close()
        logger.info("MiroFish has stopped.")


if __name__ == "__main__":
    # Ensure required directories exist
    Path("data").mkdir(exist_ok=True)
    Path("logs").mkdir(exist_ok=True)

    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
