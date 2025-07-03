# Render Proxy

This folder contains a simple reverse proxy that is used for multi-user mode of this repository.

The proxy is designed to be deployed on [render.com](https://render.com) to host custom domains for individual postcard instances. It forwards incoming traffic to the appropriate postcard instance while adding a security header that allows the request to bypass the rate limiter.

## Purpose

- **Multi-user support**: Enables hosting multiple postcard instances with custom domains
- **Custom domain hosting**: Deployed on Render.com for easy domain management
- **Rate limit bypass**: Includes security headers that allow trusted proxy traffic to bypass rate limiting on the postcard instance
