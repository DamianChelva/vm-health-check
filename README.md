# VM Health Check Script

This repository contains a shell script to analyze a virtual machine running Ubuntu. It checks disk space, CPU, and memory utilization. The VM is considered **healthy** if all are below 75%; otherwise, it is **unhealthy**.

## Usage

1. Make the script executable:
    ```bash
    chmod +x vm_health_check.sh
    ```

2. Run the script:

    - **Basic check:**
        ```bash
        ./vm_health_check.sh
        ```
        Output: `healthy` or `unhealthy`

    - **With details:**
        ```bash
        ./vm_health_check.sh Details
        ```
        Output example:
        ```
        State: unhealthy
        Disk usage: 63%
        Memory usage: 77%
        CPU usage: 65%
        Reason(s): Memory usage is 77% (>=75%). 
        ```

## What It Checks

- **Disk usage:** Root partition `/`
- **Memory usage:** Total RAM
- **CPU usage:** Average over 1 second

The script outputs "healthy" only if all three resource usages are **less than 75%**. If any are 75% or higher, it outputs "unhealthy".

## License

MIT
