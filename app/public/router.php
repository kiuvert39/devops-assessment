<?php

declare(strict_types=1);

// Router for `php -S` local development only. Production routing stays in nginx.conf.
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?: '/';
$routes = [
    '/' => 'index.php',
    '/upload' => 'upload.php',
    '/health' => 'health.php',
    '/ready' => 'ready.php',
];

if (isset($routes[$path])) {
    require __DIR__ . '/' . $routes[$path];
    return true;
}

$file = __DIR__ . $path;
if ($path !== '/' && is_file($file)) {
    return false;
}

http_response_code(404);
echo 'Not found';
