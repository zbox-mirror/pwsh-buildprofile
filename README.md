# Windows PowerShell Build Profile

Скрипт для создания настроенного профиля пользователя на определённом диске.

## Параметры

- `-DL`  
  Буква диска, на котором необходимо построить профиль.
- `-IA`  
  Установка приложений.
- `-ID`  
  Установка документов и настроек.
- `-IP`  
  Установка переменной Path.

## Синтаксис

```powershell
.\BuildProfile.ps1 -DL 'E' -IA -ID -IP
```

- Построить профиль на диске `E`.
