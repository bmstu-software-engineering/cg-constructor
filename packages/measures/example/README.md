# Measures Example

Пример использования пакета Measures для замеров времени работы алгоритмов и отображения результатов.

## Описание

Этот пример демонстрирует основные возможности пакета Measures:

- Измерение времени выполнения различных алгоритмов сортировки
- Измерение времени выполнения алгоритмов поиска
- Сравнение различных реализаций вычисления чисел Фибоначчи
- Отображение результатов в различных форматах (таблица, гистограмма, линейный график)
- Использование изолятов для выполнения замеров без блокировки UI

## Запуск примера

```bash
# Клонирование репозитория
git clone https://github.com/username/measures.git
cd measures/example

# Установка зависимостей
flutter pub get

# Запуск примера
flutter run
```

## Структура примера

Пример разделен на три вкладки:

### 1. Сортировка

Демонстрирует сравнение различных алгоритмов сортировки:
- Bubble Sort
- Insertion Sort
- Selection Sort
- Quick Sort
- Merge Sort
- Dart Sort (встроенный метод sort)

### 2. Поиск

Демонстрирует сравнение различных алгоритмов поиска:
- Linear Search
- Binary Search
- Jump Search
- Interpolation Search

### 3. Fibonacci

Демонстрирует сравнение различных алгоритмов вычисления чисел Фибоначчи:
- Recursive (рекурсивный алгоритм)
- Iterative (итеративный алгоритм)
- Dynamic Programming (динамическое программирование)
- Matrix (матричный метод)

## Функциональность

- Переключение между различными типами отображения результатов (таблица, гистограмма, линейный график)
- Включение/выключение использования изолятов для выполнения замеров
- Очистка результатов замеров
- Отображение прогресса выполнения замеров

## Скриншоты

<p align="center">
  <img src="https://raw.githubusercontent.com/username/measures/main/doc/assets/example_sorting.png" alt="Sorting Example" width="300"/>
  <img src="https://raw.githubusercontent.com/username/measures/main/doc/assets/example_search.png" alt="Search Example" width="300"/>
  <img src="https://raw.githubusercontent.com/username/measures/main/doc/assets/example_fibonacci.png" alt="Fibonacci Example" width="300"/>
</p>
