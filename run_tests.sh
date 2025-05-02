#!/bin/bash

# Не выходим немедленно при ошибке, чтобы все тесты могли выполниться
set +e

# Создаем временную директорию для логов
TEMP_DIR=$(mktemp -d)
echo "Временные файлы будут сохранены в $TEMP_DIR"

# Функция для запуска тестов в пакете
run_tests_in_package() {
    local package=$1
    local log_file="$TEMP_DIR/$package.log"
    local result_file="$TEMP_DIR/$package.result"
    
    echo "Запуск тестов в пакете $package..."
    
    # Переходим в директорию пакета
    (
        cd "./packages/$package" || { 
            echo "Ошибка: не удалось перейти в директорию ./packages/$package" > "$log_file"
            echo "1" > "$result_file"
            return 1
        }
        
        # Проверяем наличие скрипта codegen.sh и запускаем его, если он существует
        if [ -f "codegen.sh" ]; then
            echo "Запуск codegen.sh в пакете $package..." >> "$log_file"
            chmod +x codegen.sh
            ./codegen.sh > /dev/null 2>> "$log_file"
        fi
        
        # Запускаем тесты и перенаправляем вывод в лог-файл
        echo "Выполнение тестов в пакете $package..." >> "$log_file"
        fvm flutter test -r failures-only --no-pub >> "$log_file" 2>&1
        
        # Сохраняем код возврата
        local exit_code=$?
        echo "$exit_code" > "$result_file"
        
        # Добавляем информацию о результате в лог
        if [ $exit_code -ne 0 ]; then
            echo "Тесты в пакете $package завершились с ошибкой (код $exit_code)" >> "$log_file"
        else
            echo "Тесты в пакете $package успешно пройдены" >> "$log_file"
        fi
        
        return $exit_code
    )
}

# Массив для хранения процессов и имен пакетов
pids=()
package_names=()

# Запускаем тесты параллельно для каждого пакета
for package_dir in ./packages/*/; do
    # Получаем имя пакета из пути
    package=$(basename "$package_dir")
    
    # Проверяем наличие директории test в пакете
    if [ ! -d "./packages/$package/test" ]; then
        echo "Пропуск пакета $package (директория test не найдена)"
        continue
    fi
    
    # Запускаем тесты в фоновом режиме
    run_tests_in_package "$package" &
    
    # Сохраняем PID процесса
    pids+=($!)
    package_names+=("$package")
done

# Если нет пакетов с тестами, выходим
if [ ${#pids[@]} -eq 0 ]; then
    echo "Не найдено пакетов с тестами"
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Флаг для отслеживания наличия ошибок
has_errors=0

# Ожидаем завершения всех процессов и проверяем их статус
for i in "${!pids[@]}"; do
    pid=${pids[$i]}
    package=${package_names[$i]}
    
    # Ожидаем завершения процесса
    wait $pid
    
    # Проверяем результат выполнения тестов
    if [ -f "$TEMP_DIR/$package.result" ]; then
        exit_code=$(cat "$TEMP_DIR/$package.result")
    else
        echo "Ошибка: файл результата для пакета $package не найден"
        exit_code=1
    fi
    
    # Всегда выводим содержимое лог-файла
    echo "Результаты тестов для пакета $package:"
    if [ -f "$TEMP_DIR/$package.log" ]; then
        cat "$TEMP_DIR/$package.log"
    else
        echo "Лог-файл для пакета $package не найден"
    fi
    
    # Обновляем флаг ошибок
    if [ "$exit_code" -ne 0 ]; then
        has_errors=1
    fi
    
    echo "----------------------------------------"
done

# Удаляем временную директорию
rm -rf "$TEMP_DIR"

# Выводим итоговый результат
if [ $has_errors -ne 0 ]; then
    echo "ИТОГ: Были обнаружены ошибки при выполнении тестов."
    exit 1
else
    echo "ИТОГ: Все тесты успешно пройдены."
    exit 0
fi
