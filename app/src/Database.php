<?php

declare(strict_types=1);

namespace App;

use PDO;

final class Database
{
    public static function connect(): PDO{
        $database = Config::string('DB_DATABASE');
        $socket = getenv('DB_SOCKET');
        $dsn = $socket
            ? "mysql:unix_socket={$socket};dbname={$database};charset=utf8mb4"
            : sprintf(
                'mysql:host=%s;port=%d;dbname=%s;charset=utf8mb4',
                Config::string('DB_HOST'),
                Config::integer('DB_PORT', 3306),
                $database
            );

        return new PDO($dsn, Config::string('DB_USERNAME'), Config::string('DB_PASSWORD'), [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]);
    }

    /** @return list<array<string, mixed>> */
    public static function documents(PDO $pdo): array{
        return $pdo->query(
            'SELECT id, original_filename, object_name, mime_type, file_size, uploaded_at
             FROM documents ORDER BY uploaded_at DESC LIMIT 50'
        )->fetchAll();
    }

    public static function addDocument(PDO $pdo, string $originalName, string $objectName, string $mimeType, int $size): void{
        $statement = $pdo->prepare(
            'INSERT INTO documents (original_filename, object_name, mime_type, file_size)
             VALUES (:original_filename, :object_name, :mime_type, :file_size)'
        );
        $statement->execute([
            'original_filename' => $originalName,
            'object_name' => $objectName,
            'mime_type' => $mimeType,
            'file_size' => $size,
        ]);
    }
}
