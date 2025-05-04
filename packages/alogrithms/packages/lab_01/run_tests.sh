#!/bin/bash

# Скрипт для рекурсивного запуска тестов во всех пакетах

# Сохраняем текущую директорию
CURRENT_DIR=$(pwd)

# Функция для запуска тестов в пакете
run_tests_in_package() {
  local package_dir=$1
  echo "Запуск тестов в пакете: $package_dir"
  
  # Переходим в директорию пакета
  cd "$package_dir" || return
  
  # Проверяем наличие директории test
  if [ -d "test" ]; then
    # Проверяем наличие pubspec.yaml для определения типа проекта
    if [ -f "pubspec.yaml" ]; then
      echo "Найден pubspec.yaml, запускаем fvm flutter test..."
      fvm flutter pub get > /dev/null
      fvm flutter test -r failures-only --no-pub      

      # Сохраняем статус выполнения команды
      local test_status=$?
      
      if [ $test_status -eq 0 ]; then
        echo "✅ Тесты в пакете $package_dir выполнены успешно"
      else
        echo "❌ Тесты в пакете $package_dir завершились с ошибкой (код: $test_status)"
      fi
    else
      echo "⚠️ В директории $package_dir нет файла pubspec.yaml, пропускаем..."
    fi
  else
    echo "⚠️ В директории $package_dir нет директории test, пропускаем..."
  fi
  
  # Возвращаемся в исходную директорию
  cd "$CURRENT_DIR" || exit
}

# Находим все директории, которые могут быть пакетами (содержат pubspec.yaml)
echo "Поиск пакетов с тестами..."
packages=$(find . -type f -name "pubspec.yaml" | sed 's/\/pubspec.yaml$//' | sort)

# Проверяем, найдены ли пакеты
if [ -z "$packages" ]; then
  echo "❌ Не найдено ни одного пакета с файлом pubspec.yaml"
  exit 1
fi

# Счетчики для статистики
total_packages=0
successful_packages=0
failed_packages=0
skipped_packages=0

# Запускаем тесты в каждом пакете
for package in $packages; do
  # Пропускаем скрытые директории (начинающиеся с .)
  if [[ $package == ./.* ]]; then
    continue
  fi
  
  # Проверяем наличие директории test
  if [ -d "$package/test" ]; then
    ((total_packages++))
    
    # Запускаем тесты
    run_tests_in_package "$package"
    
    # Проверяем результат выполнения тестов
    if [ $? -eq 0 ]; then
      ((successful_packages++))
    else
      ((failed_packages++))
    fi
  else
    echo "⚠️ Пакет $package не содержит директории test, пропускаем..."
    ((skipped_packages++))
  fi
done

# Выводим итоговую статистику
echo ""
echo "=== Итоги выполнения тестов ==="
echo "Всего пакетов с тестами: $total_packages"
echo "Успешно: $successful_packages"
echo "С ошибками: $failed_packages"
echo "Пропущено: $skipped_packages"

# Устанавливаем код возврата в зависимости от результатов тестов
if [ $failed_packages -gt 0 ]; then
  echo "❌ Некоторые тесты завершились с ошибкой"
  exit 1
else
  echo "✅ Все тесты выполнены успешно"
  exit 0
fi
