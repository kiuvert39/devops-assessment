<?php

declare(strict_types=1);

namespace App;

final class Upload
{
    /** @var array<string, string> */
    private const ALLOWED_MIME_TYPES = [
        'application/pdf' => 'pdf',
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'text/plain' => 'txt',
    ];

    /** @return array{originalName: string, mimeType: string, size: int, objectName: string} */
    public static function validate(array $file): array
    {
        if (($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
            throw new \InvalidArgumentException(self::uploadError((int) ($file['error'] ?? UPLOAD_ERR_NO_FILE)));
        }
        $size = (int) ($file['size'] ?? 0);
        if ($size < 1 || $size > Config::integer('MAX_UPLOAD_BYTES', 10 * 1024 * 1024)) {
            throw new \InvalidArgumentException('File must be between 1 byte and 10 MB.');
        }
        $temporaryPath = (string) ($file['tmp_name'] ?? '');
        $mimeType = (string) (new \finfo(FILEINFO_MIME_TYPE))->file($temporaryPath);
        if (!isset(self::ALLOWED_MIME_TYPES[$mimeType])) {
            throw new \InvalidArgumentException('Only PDF, JPEG, PNG, and plain text files are allowed.');
        }
        $originalName = basename((string) ($file['name'] ?? 'upload'));
        $originalName = mb_substr($originalName, 0, 255);
        return [
            'originalName' => $originalName,
            'mimeType' => $mimeType,
            'size' => $size,
            // UUID-like random name prevents path traversal and collisions.
            'objectName' => 'documents/' . bin2hex(random_bytes(16)) . '.' . self::ALLOWED_MIME_TYPES[$mimeType],
        ];
    }

    private static function uploadError(int $error): string
    {
        return match ($error) {
            UPLOAD_ERR_INI_SIZE, UPLOAD_ERR_FORM_SIZE => 'The file is too large.',
            UPLOAD_ERR_NO_FILE => 'Please choose a file.',
            default => 'The upload failed. Please try again.',
        };
    }
}
