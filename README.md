# leo-status

leo-status is a tool for monitoring a Leo Bodnar GPSDO. It exposes a HTTP endpoint with the GPSDO status and config.

The GPSDOs supported are:
- [Leo Bodnar - Precision GPS Reference Clock](https://www.leobodnar.com/shop/index.php?main_page=product_info&cPath=107&products_id=234)
- [Leo Bodnar - Mini Precision GPS Reference Clock](https://www.leobodnar.com/shop/index.php?main_page=product_info&cPath=107&products_id=301) [UNTESTED]

| Platform     | Tested | Status  |
| ------------ | ------ | ------- |
| MacOS 14.1.2 | Tested | Working |
| Windows 11   | Tested | Working |
| Ubuntu 22.04 | Tested | Working |

Please see the [openapi.yaml](./leo-status/openapi.yaml) for an example of the data returned.

## Structure

This project is broken into two parts:

- [`leo-status-driver`](./leo-status-driver/), a library which can be used to interface with a Leo Bodnar GPSDO.
- [`leo-status`](./leo-status/), a command line application which reports the status of a connected Leo Bodnar GPSDO, using the leo-status-driver library.

## Prerequisites

Ensure you have both libusb and libudev installed:

Debian based systems:
```bash
sudo apt-get install libudev-dev libusb-1.0.0-dev
```

## Usage

Quick start:

```shell
cargo run -- --interval 1s --http-host 0.0.0.0:8080
```

### Status Endpoint

Access the `/status` endpoint
```shell
curl localhost:8080/status | jq
```

Which returns
```json
{
  "loss_count": 1,
  "sat_lock": false,
  "pll_lock": true,
  "locked": false
}
```

### Config Endpoint

Access the `/config` endpoint
```shell
curl localhost:8080/config | jq
```

Which returns
```json
{
  "output1": true,
  "output2": true,
  "level": 8,
  "pll_params": {
    "fin": 4296875,
    "n3": 30,
    "n2_hs": 10,
    "n2_ls": 3840,
    "n1_hs": 11,
    "nc1_ls": 10,
    "nc2_ls": 20,
    "skew": 0,
    "bw": 15,
    "f3": 143229,
    "fosc": 5500000000
  },
  "fout1": 50000000,
  "fout2": 25000000
}
```

### Prometheus Endpoint

Recording the status of your Leo Bodnar device into Prometheus is supported through the `/metrics`, endpoint, simply add it as an endpoint to your Prometheus. An example is below for the `static_configs` method.

```yaml
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
        - 127.0.0.1:8000
```

The following metrics are exposed:

- `lock_status` - the status of the overall lock, this is the same as the `locked` field in the status endpoint
- `pll_lock_status` - the status of the PLL lock `pll_lock` field in the status endpoint
- `sat_lock_status` - the status of the GPS lock, this is the same as the `sat_lock` field in the status endpoint

### Further information

For more usage advice, issue the `--help` command.

```
Usage: leo-status [OPTIONS] --interval <INTERVAL> --http-host <HTTP_HOST>

Options:
      --interval <INTERVAL>            Interval to poll the GPSDO for status
      --serial-number <SERIAL_NUMBER>  Serial number of the Leo Bodnar GPSDO device to use, if not specified any Leo Bodnar GPSDO connected will be used
      --stdout                         Print status of GPSDO to the console in JSON format
      --http-host <HTTP_HOST>          HTTP host to listen on
  -h, --help                           Print help
  -V, --version                        Print version
```
## Disclaimer

Please note that this program has no guarantees, nor does it have any endorsement or relation to the Leo Bodnar company. You use this program at your own risk, and the author nor Leo Bodnar company are responsible for it's operation (or the lack thereof).

Please ensure you familiarise yourself with the [LICENSE](./LICENSE) for further details.
