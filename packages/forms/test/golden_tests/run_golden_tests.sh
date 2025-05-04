#!/bin/bash

# Скрипт для запуска golden тестов

# Цвета для вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Функция для вывода заголовка
print_header() {
  echo -e "${YELLOW}=======================================${NC}"
  echo -e "${YELLOW}$1${NC}"
  echo -e "${YELLOW}=======================================${NC}"
}

# Функция для запуска тестов
run_tests() {
  local update_flag=$1
  local test_path=$2
  
  if [ "$update_flag" = true ]; then
    print_header "Обновление golden тестов: $test_path"
    flutter test --update-goldens $test_path
  else
    print_header "Запуск golden тестов: $test_path"
    flutter test $test_path
  fi
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Тесты успешно выполнены!${NC}"
  else
    echo -e "${RED}Ошибка при выполнении тестов!${NC}"
    exit 1
  fi
}

# Проверка аргументов
UPDATE_GOLDENS=false
SPECIFIC_TEST=""

for arg in "$@"; do
  case $arg in
    --update-goldens)
      UPDATE_GOLDENS=true
      ;;
    --test=*)
      SPECIFIC_TEST="${arg#*=}"
      ;;
    *)
      echo -e "${RED}Неизвестный аргумент: $arg${NC}"
      echo "Использование: $0 [--update-goldens] [--test=<путь к тесту>]"
      exit 1
      ;;
  esac
done

# Запуск тестов
if [ -n "$SPECIFIC_TEST" ]; then
  # Запуск конкретного теста
  TEST_PATH="$SPECIFIC_TEST"
  if [ ! -f "$TEST_PATH" ]; then
    echo -e "${RED}Файл теста не найден: $TEST_PATH${NC}"
    exit 1
  fi
  run_tests $UPDATE_GOLDENS $TEST_PATH
else
  # Запуск всех тестов
  run_tests $UPDATE_GOLDENS "./"
fi

echo -e "${GREEN}Все тесты выполнены успешно!${NC}"
