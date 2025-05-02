#!/bin/bash

# Скрипт для автоматической установки pre-commit hook

# Проверяем, находимся ли мы в корне git-репозитория
if [ ! -d ".git" ]; then
    echo "Ошибка: Этот скрипт должен быть запущен из корня git-репозитория."
    exit 1
fi

# Делаем скрипты исполняемыми
chmod +x run_tests.sh pre-commit-hook.sh

# Создаем символическую ссылку на pre-commit-hook.sh в директории .git/hooks/
ln -sf ../../pre-commit-hook.sh .git/hooks/pre-commit

# Проверяем, что hook установлен правильно
if [ -x ".git/hooks/pre-commit" ]; then
    echo "Pre-commit hook успешно установлен!"
    echo "Теперь тесты будут автоматически запускаться перед каждым коммитом."
    echo "Подробнее см. в файле INSTALL_HOOK.md"
else
    echo "Ошибка: Не удалось установить pre-commit hook."
    echo "Попробуйте установить его вручную, следуя инструкциям в файле INSTALL_HOOK.md"
    exit 1
fi

exit 0
