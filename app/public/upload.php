<?php

declare(strict_types=1);

require dirname(__DIR__) . '/src/bootstrap.php';

use App\Database;
use App\Storage;
use App\Upload;

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Allow: POST');
    http_response_code(405);
    exit('Method not allowed');
}

try {
    $file = $_FILES['document'] ?? [];
    if (!is_uploaded_file((string) ($file['tmp_name'] ?? ''))) {
        throw new InvalidArgumentException('Please choose a valid uploaded file.');
    }
    $document = Upload::validate($file);
    $storage = new Storage();
    $storage->upload((string) $file['tmp_name'], $document['objectName'], $document['mimeType']);
    Database::addDocument(Database::connect(), $document['originalName'], $document['objectName'], $document['mimeType'], $document['size']);
    header('Location: /?message=' . rawurlencode('File uploaded successfully.'), true, 303);
} catch (InvalidArgumentException $exception) {
    header('Location: /?error=' . rawurlencode($exception->getMessage()), true, 303);
} catch (Throwable $exception) {
    log_exception($exception);
    header('Location: /?error=' . rawurlencode('Upload failed. Please try again.'), true, 303);
}
