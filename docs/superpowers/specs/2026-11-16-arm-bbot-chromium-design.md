# ARM-native Chromium for BBOT

## Goal

Make the standard Docker image build and run on ARM64 with BBOT's dependencies preinstalled, while retaining the existing AMD64 behavior.

## Design

Install the pinned Playwright browser before BBOT's dependency installation. On ARM64, configure BBOT's `gowitness` module to use the installed ARM-native Playwright Chromium explicitly instead of BBOT's x86-only Chrome download. Keep BBOT's full dependency installation and existing dry-run checks; do not bypass errors. Leave AMD64's existing Chrome selection unchanged.

## Verification

Build the standard image for ARM64, verify BBOT's dependency checks and a local `gowitness` screenshot using the configured browser, and start the application with Docker Compose. Check the AMD64-specific Dockerfile path remains unchanged in behavior. If a verification step cannot run, report the limitation rather than treating it as a pass.
