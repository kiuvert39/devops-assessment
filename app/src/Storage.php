<?php

declare(strict_types=1);

namespace App;

use Google\Cloud\Storage\StorageClient;

final class Storage
{
    private string $driver;
    private string $bucketName;
    private ?StorageClient $client = null;

    public function __construct()
    {
        $this->driver = Config::string('STORAGE_DRIVER', 'gcs');
        $this->bucketName = Config::string('GCS_BUCKET', 'local-development');
    }

    public function isAvailable(): bool
    {
        if ($this->driver === 'local') {
            $path = Config::string('LOCAL_STORAGE_PATH', '/tmp/cloud-storage-demo');
            return is_dir($path) || mkdir($path, 0770, true);
        }

        return $this->client()->bucket($this->bucketName)->exists();
    }

    public function upload(string $temporaryPath, string $objectName, string $mimeType): void
    {
        if ($this->driver === 'local') {
            $directory = Config::string('LOCAL_STORAGE_PATH', '/tmp/cloud-storage-demo');
            if (!is_dir($directory) && !mkdir($directory, 0770, true) && !is_dir($directory)) {
                throw new \RuntimeException('Could not create local storage directory.');
            }
            if (!copy($temporaryPath, $directory . '/' . basename($objectName))) {
                throw new \RuntimeException('Could not write local development upload.');
            }
            return;
        }

        $stream = fopen($temporaryPath, 'rb');
        if ($stream === false) {
            throw new \RuntimeException('Could not read uploaded file.');
        }
        try {
            $this->client()->bucket($this->bucketName)->upload($stream, [
                'name' => $objectName,
                'metadata' => ['contentType' => $mimeType],
            ]);
        } finally {
            fclose($stream);
        }
    }

    private function client(): StorageClient
    {
        // No key file is configured here: Cloud Run supplies ADC through its service account.
        return $this->client ??= new StorageClient();
    }
}
