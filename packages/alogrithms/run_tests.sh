#!/bin/bash

# Скрипт для рекурсивного запуска тестов во всех пакетах Flutter

# Переходим в директорию packages

set -e
cd packages
start_dir=$(pwd)

# Находим все директории, содержащие pubspec.yaml (Flutter пакеты)
find . -name "pubspec.yaml" | while read pubspec; do
    # Получаем директорию пакета
    package_dir=$(dirname "$pubspec")
    
    echo "====================================================="
    echo "Запуск тестов для пакета: $package_dir"
    echo "====================================================="
    
    # Переходим в директорию пакета
    cd "$package_dir"
    
    # Получаем зависимости с подробным выводом
    echo "Получение зависимостей..."
    flutter pub get
    
    # Проверяем наличие тестовых файлов
    if [ -d "test" ]; then
        # Выводим список тестовых файлов
        echo "Найдены тестовые файлы:"
        find test -name "*.dart" -type f
        
        # Запускаем тесты с подробным выводом
        echo "Запуск тестов..."
        flutter test test -r failures-only
    else
        echo "Тестовые файлы не найдены."
    fi
    
    # # Возвращаемся в директорию packages
    cd "$start_dir"
    echo $(pwd)

    
    # echo ""
done

echo "Тестирование завершено."
