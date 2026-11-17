<?php

declare(strict_types=1);

namespace App;

final class Config
{
    public static function string(string $name, ?string $default = null): string
    {
        $value = getenv($name);
        if ($value === false || $value === '') {
            if ($default !== null) {
                return $default;
            }
            throw new \RuntimeException("Missing required environment variable: {$name}");
        }
        return $value;
    }

    public static function integer(string $name, int $default): int
    {
        $value = getenv($name);
        return ($value === false || $value === '') ? $default : (int) $value;
    }
}
