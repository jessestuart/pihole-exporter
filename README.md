# PI-Hole Prometheus Exporter

[![TravisBuildStatus][travis-ci]][travis-ci 2] [![GoDoc][godoc]][godoc 2]
[![GoReportCard][goreportcard]][goreportcard 2]

This is a Prometheus exporter for [PI-Hole][pi-hole]'s Raspberry PI ad blocker.

![Grafana dashboard][githubusercontent]

Grafana dashboard is [available here][grafana] on the Grafana dashboard website
and also [here][githubusercontent 2] on the GitHub repository.

## Prerequisites

- [Go][golang]

## Installation

### Download binary

You can download the latest version of the binary built for your architecture
here:

- Architecture **i386** [ [Darwin][github] / [Linux][github 2] /
  [Windows][github 3] ]
- Architecture **amd64** [ [Darwin][github 4] / [Linux][github 5] /
  [Windows][github 6] ]
- Architecture **arm** [ [Linux][github 7] ]

### Using Docker

The exporter is also available as a [Docker image][docker]. You can run it using
the following example and pass configuration environment variables:

```
$ docker run \
  -e 'PIHOLE_HOSTNAME=192.168.1.2' \
  -e 'PIHOLE_PASSWORD=mypassword' \
  -e 'INTERVAL=30s' \
  -e 'PORT=9311' \
  ekofr/pihole-exporter:latest
```

### From sources

Optionally, you can download and build it from the sources. You have to retrieve
the project sources by using one of the following way:

```bash
$ go get -u github.com/eko/pihole-exporter
# or
$ git clone https://github.com/eko/pihole-exporter.git
```

Install the needed vendors:

```
$ GO111MODULE=on go mod vendor
```

Then, build the binary (here, an example to run on Raspberry PI ARM
architecture):

```bash
$ GOOS=linux GOARCH=arm GOARM=7 go build -o pihole_exporter .
```

## Usage

In order to run the exporter, type the following command (arguments are
optional):

```bash
$ ./pihole_exporter -pihole_hostname 192.168.1.10 -pihole_password azerty

2019/05/09 20:19:52 ------------------------------------
2019/05/09 20:19:52 -  PI-Hole exporter configuration  -
2019/05/09 20:19:52 ------------------------------------
2019/05/09 20:19:52 PIHoleHostname : 192.168.1.10
2019/05/09 20:19:52 PIHolePassword : azerty
2019/05/09 20:19:52 Port : 9311
2019/05/09 20:19:52 Interval : 10s
2019/05/09 20:19:52 ------------------------------------
2019/05/09 20:19:52 New Prometheus metric registered: domains_blocked
2019/05/09 20:19:52 New Prometheus metric registered: dns_queries_today
2019/05/09 20:19:52 New Prometheus metric registered: ads_blocked_today
2019/05/09 20:19:52 New Prometheus metric registered: ads_percentag_today
2019/05/09 20:19:52 New Prometheus metric registered: unique_domains
2019/05/09 20:19:52 New Prometheus metric registered: queries_forwarded
2019/05/09 20:19:52 New Prometheus metric registered: queries_cached
2019/05/09 20:19:52 New Prometheus metric registered: clients_ever_seen
2019/05/09 20:19:52 New Prometheus metric registered: unique_clients
2019/05/09 20:19:52 New Prometheus metric registered: dns_queries_all_types
2019/05/09 20:19:52 New Prometheus metric registered: reply
2019/05/09 20:19:52 New Prometheus metric registered: top_queries
2019/05/09 20:19:52 New Prometheus metric registered: top_ads
2019/05/09 20:19:52 New Prometheus metric registered: top_sources
2019/05/09 20:19:52 New Prometheus metric registered: forward_destinations
2019/05/09 20:19:52 New Prometheus metric registered: querytypes
2019/05/09 20:19:52 New Prometheus metric registered: status
2019/05/09 20:19:52 Starting HTTP server
2019/05/09 20:19:54 New tick of statistics: 648 ads blocked / 66796 total DNS querie
...
```

Once the exporter is running, you also have to update your `prometheus.yml`
configuration to let it scrape the exporter:

```yaml
scrape_configs:
  - job_name: "pihole"
    static_configs:
      - targets: ["localhost:9311"]
```

## Available CLI options

```bash
# Interval of time the exporter will fetch data from PI-Hole
  -interval duration (optional) (default 10s)

# Hostname of the Raspberry PI where PI-Hole is installed
  -pihole_hostname string (optional) (default "127.0.0.1")

# Password defined on the PI-Hole interface
  -pihole_password string (optional)

# Port to be used for the exporter
  -port string (optional) (default "9311")
```

## Available Prometheus metrics

|         Metric name          | Description                                                                               |
| :--------------------------: | ----------------------------------------------------------------------------------------- |
| pihole_domains_being_blocked | This represent the number of domains being blocked                                        |
|   pihole_dns_queries_today   | This represent the number of DNS queries made over the current day                        |
|   pihole_ads_blocked_today   | This represent the number of ads blocked over the current day                             |
| pihole_ads_percentage_today  | This represent the percentage of ads blocked over the current day                         |
|    pihole_unique_domains     | This represent the number of unique domains seen                                          |
|   pihole_queries_forwarded   | This represent the number of queries forwarded                                            |
|    pihole_queries_cached     | This represent the number of queries cached                                               |
|   pihole_clients_ever_seen   | This represent the number of clients ever seen                                            |
|    pihole_unique_clients     | This represent the number of unique clients seen                                          |
| pihole_dns_queries_all_types | This represent the number of DNS queries made for all types                               |
|         pihole_reply         | This represent the number of replies made for all types                                   |
|      pihole_top_queries      | This represent the number of top queries made by PI-Hole by domain                        |
|        pihole_top_ads        | This represent the number of top ads made by PI-Hole by domain                            |
|      pihole_top_sources      | This represent the number of top sources requests made by PI-Hole by source host          |
| pihole_forward_destinations  | This represent the number of forward destinations requests made by PI-Hole by destination |
|      pihole_querytypes       | This represent the number of queries made by PI-Hole by type                              |
|        pihole_status         | This represent if PI-Hole is enabled                                                      |

[docker]: https://hub.docker.com/r/ekofr/pihole-exporter
[github]: https://github.com/eko/pihole-exporter/releases/latest/download/pihole_exporter-darwin-386
[github 2]: https://github.com/eko/pihole-exporter/releases/latest/download/pihole_exporter-linux-386
[github 3]: https://github.com/eko/pihole-exporter/releases/latest/download/pihole_exporter-windows-386.exe
[github 4]: https://github.com/eko/pihole-exporter/releases/latest/download/pihole_exporter-darwin-amd64
[github 5]: https://github.com/eko/pihole-exporter/releases/latest/download/pihole_exporter-linux-amd64
[github 6]: https://github.com/eko/pihole-exporter/releases/latest/download/pihole_exporter-windows-amd64.exe
[github 7]: https://github.com/eko/pihole-exporter/releases/latest/download/pihole_exporter-linux-arm
[githubusercontent]: https://raw.githubusercontent.com/eko/pihole-exporter/master/dashboard.jpg
[githubusercontent 2]: https://raw.githubusercontent.com/eko/pihole-exporter/master/grafana/dashboard.json
[godoc]: https://godoc.org/github.com/eko/pihole-exporter?status.png
[godoc 2]: https://godoc.org/github.com/eko/pihole-exporter
[golang]: https://golang.org/doc/
[goreportcard]: https://goreportcard.com/badge/github.com/eko/pihole-exporter
[goreportcard 2]: https://goreportcard.com/report/github.com/eko/pihole-exporter
[grafana]: https://grafana.com/dashboards/10176
[pi-hole]: https://pi-hole.net/
[travis-ci]: https://api.travis-ci.org/eko/pihole-exporter.svg?branch=master
[travis-ci 2]: https://travis-ci.org/eko/pihole-exporte
