<?php

declare(strict_types=1);

require dirname(__DIR__) . '/src/bootstrap.php';

use App\Database;
use App\Storage;

$databaseOk = false;
$storageOk = false;
$documents = [];

try {
    $pdo = Database::connect();
    $databaseOk = true;
    $documents = Database::documents($pdo);
} catch (Throwable $exception) {
    log_exception($exception);
}

try {
    $storageOk = (new Storage())->isAvailable();
} catch (Throwable $exception) {
    log_exception($exception);
}

$message = $_GET['message'] ?? '';
$error = $_GET['error'] ?? '';
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= h(app_name()) ?></title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
<main>
    <header>
        <h1><?= h(app_name()) ?></h1>
        <p class="environment">Environment: <strong><?= h(app_environment()) ?></strong></p>
    </header>
    <section class="status" aria-label="Dependency status">
        <div>Database <span class="<?= $databaseOk ? 'ok' : 'fail' ?>"><?= $databaseOk ? 'Connected' : 'Unavailable' ?></span></div>
        <div>Storage <span class="<?= $storageOk ? 'ok' : 'fail' ?>"><?= $storageOk ? 'Connected' : 'Unavailable' ?></span></div>
    </section>
    <?php if ($message !== ''): ?><p class="notice"><?= h($message) ?></p><?php endif; ?>
    <?php if ($error !== ''): ?><p class="error"><?= h($error) ?></p><?php endif; ?>
    <section>
        <h2>Upload a document</h2>
        <form action="/upload" method="post" enctype="multipart/form-data">
            <label for="document">PDF, JPEG, PNG, or TXT (max 10 MB)</label>
            <input id="document" name="document" type="file" accept=".pdf,.jpg,.jpeg,.png,.txt" required>
            <button type="submit" <?= (!$databaseOk || !$storageOk) ? 'disabled' : '' ?>>Upload</button>
        </form>
    </section>
    <section>
        <h2>Uploaded documents</h2>
        <?php if (!$databaseOk): ?>
            <p>Documents cannot be loaded while the database is unavailable.</p>
        <?php elseif ($documents === []): ?>
            <p>No documents uploaded yet.</p>
        <?php else: ?>
            <table>
                <thead><tr><th>Filename</th><th>Type</th><th>Size</th><th>Uploaded</th></tr></thead>
                <tbody>
                <?php foreach ($documents as $document): ?>
                    <tr><td><?= h($document['original_filename']) ?></td><td><?= h($document['mime_type']) ?></td><td><?= number_format((int) $document['file_size']) ?> bytes</td><td><?= h($document['uploaded_at']) ?></td></tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        <?php endif; ?>
    </section>
</main>
</body>
</html>
