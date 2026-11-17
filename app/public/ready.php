<?php

declare(strict_types=1);

require dirname(__DIR__) . '/src/bootstrap.php';

use App\Database;
use App\Storage;

$dependencies = [
    'database' => false,
    'storage' => false,
];

try {
    Database::connect()->query('SELECT 1');
    $dependencies['database'] = true;
} catch (Throwable $exception) {
    log_exception($exception);
}

try {
    $dependencies['storage'] = (new Storage())->isAvailable();
} catch (Throwable $exception) {
    log_exception($exception);
}

$isReady = $dependencies['database'] && $dependencies['storage'];

header('Content-Type: application/json');

http_response_code($isReady ? 200 : 503);

echo json_encode([
    'status' => $isReady ? 'ok' : 'degraded',
    'environment' => app_environment(),
    'dependencies' => $dependencies,
], JSON_THROW_ON_ERROR);