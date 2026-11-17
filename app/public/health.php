<?php

declare(strict_types=1);

require dirname(__DIR__) . '/src/bootstrap.php';

header('Content-Type: application/json');

http_response_code(200);

echo json_encode([
    'status' => 'ok',
    'environment' => app_environment(),
], JSON_THROW_ON_ERROR);