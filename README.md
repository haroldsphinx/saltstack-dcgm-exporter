# DCGM Exporter

DCGM Exporter is a tool for exporting NVIDIA GPU metrics to Prometheus.

## Installation

To install DCGM Exporter, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/haroldsphinx/saltstack-nvme-exporter.git
   ```

2. Navigate to the directory:

   ```bash
   cd saltstack-nvme-exporter
   ```

3. Run the installation script:

   ```bash
   salt-call --local state.apply dcgm_exporter
   ```

## Usage

Once installed, DCGM Exporter will run as a service and export metrics to Prometheus. You can configure the service by editing the configuration files located in the `dcgm_exporter/files` directory.

## Contributing

We welcome contributions! Please see the [CONTRIBUTING.md](CONTRIBUTING.md) file for more information on how to contribute.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact
For any questions or issues, please open an issue on GitHub or contact the maintainers haroldsphinx@gmail.com

