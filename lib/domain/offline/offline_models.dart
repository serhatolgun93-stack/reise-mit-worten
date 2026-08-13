enum DownloadNetworkPolicy { wifiOnly, wifiAndMobile, askEachTime }
enum NetworkKind { wifi, mobile, none, other }
enum PackageDownloadStatus { queued, checkingPolicy, downloading, paused, completed, cancelled, failed }
enum PackageInstallStatus { notInstalled, downloaded, validating, installing, installed, failed, removing }

class PackageDescriptor {
  final String packageId;
  final String packageVersion;
  final Uri source;
  final int expectedBytes;
  final String expectedSha256;
  const PackageDescriptor({required this.packageId, required this.packageVersion, required this.source, required this.expectedBytes, required this.expectedSha256});
}

class PackageDownloadProgress {
  final PackageDownloadStatus status;
  final int bytesDownloaded;
  final int totalBytes;
  final String? localPath;
  final String? errorCode;
  const PackageDownloadProgress(this.status, this.bytesDownloaded, this.totalBytes, {this.localPath, this.errorCode});
  double? get ratio => totalBytes <= 0 ? null : bytesDownloaded / totalBytes;
}

class InstalledPackageRecord {
  final String packageId;
  final String packageVersion;
  final int contractVersion;
  final String languageId;
  final String journeyId;
  final PackageInstallStatus status;
  final String checksum;
  final String? installedPath;
  const InstalledPackageRecord({required this.packageId, required this.packageVersion, required this.contractVersion, required this.languageId, required this.journeyId, required this.status, required this.checksum, this.installedPath});
}
