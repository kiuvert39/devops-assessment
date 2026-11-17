<?php

declare(strict_types=1);

require dirname(__DIR__) . '/vendor/autoload.php';

use App\Config;

function app_name(): string
{
    return Config::string('APP_NAME', 'Cloud Storage Demo');
}

function app_environment(): string
{
    return Config::string('APP_ENV', 'production');
}

function h(mixed $value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function log_exception(\Throwable $exception): void
{
    error_log(sprintf('[cloud-storage-demo] %s: %s', get_class($exception), $exception->getMessage()));
}
