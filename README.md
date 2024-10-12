<h2 align="center">
    <a href="https://httpie.io" target="blank_">
        <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
    </a>
    <br>
    <br>
    Helm Charts Repository
    <br>
</h2>

Welcome to the Helm Charts repository for nullplatform. This repository hosts packaged Helm charts and serves them via GitHub Pages.

## How to Use This Repository

### 1. Add Helm Repository

To add this Helm repository to your Helm client, use the following command:

```bash
helm repo add nullplatform https://nullplatform.github.io/helm-charts
helm repo update
```

This will add the repository and make the charts available for installation.

### 2. Search Charts in the Repository

You can list the charts available in this repository by running:

```bash
helm search repo nullplatform
```

This will display all available charts and their versions.

### 3. Install a Helm Chart

To install a chart from this repository, use the following command:

```bash
helm install <release-name> nullplatform/<chart-name> --version <chart-version>
```

For example, to install the `base` chart, you can run:

```bash
helm install my-release nullplatform/base --version 1.0.0
```

Replace `<release-name>`, `<chart-name>`, and `<chart-version>` with your desired values.

### 4. Upgrade a Helm Chart

To upgrade an existing Helm release to a new version of a chart, use the `helm upgrade` command:

```bash
helm upgrade <release-name> nullplatform/<chart-name> --version <new-chart-version>
```

For example:

```bash
helm upgrade my-release nullplatform/base --version 1.1.0
```

### 5. Remove a Helm Release

To uninstall or delete a Helm release, use the following command:

```bash
helm uninstall <release-name>
```

For example:

```bash
helm uninstall my-release
```

## Updating the Repository

If new charts or chart versions are added to this repository, you should run the following command to update your local cache of the repository:

```bash
helm repo update
```

This ensures that you have the latest list of charts and versions from this repository.

## Contributing

If you'd like to contribute to this repository by adding new charts or improving existing ones, please fork the repository, make your changes, and submit a pull request.

---

Thank you for using the nullplatform Helm Charts repository!
