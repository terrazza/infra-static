<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type"
          content="text/html; charset=utf-8">
    <title>noFramework.io</title>
</head>
<body>
<h1>summary (php:<?=phpversion()?>, now:<?=date('Y-m-d H:i:s')?>)</h1>
<h3>envs</h3>
<pre><?php $envs=getenv();ksort($envs); print_r($envs);?></pre>
<h3>extensions</h3>
<pre><?php $extensions=get_loaded_extensions();sort($extensions);print_r($extensions);?></pre>
<h3>database</h3>
<?php
$PDOClassName       = "PDO";
if (class_exists($PDOClassName)) {
    if ($DB_TYPE = getenv("DATABASE_TYPE")) {
        $DB_HOST    = getenv("DATABASE_HOST");
        $DB_NAME    = getenv("DATABASE_NAME");
        $DB_USER    = getenv("DATABASE_USER");
        $DB_PWD     = getenv("DATABASE_PWD");
        $DB_MSG     = "connection to (type: $DB_TYPE, host:$DB_HOST, db:$DB_NAME)";
        try {
            $conn   = new PDO("$DB_TYPE:host=$DB_HOST;dbname=$DB_NAME", $DB_USER, $DB_PWD);
            $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            echo "$DB_MSG successfully";
        } catch (PDOException $e) {
            echo "$DB_MSG failed<br>&nbsp;" . $e->getMessage() . "[" . $e->getCode(). "]";
        }
        echo "<br>";
    } else {
        echo "no env arg:DATABASE_TYPE: given, no PDO test</br>";
    }
} else {
    echo "$PDOClassName no installed</br>";
}
?>
</body>
</html>