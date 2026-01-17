// helper atomWithMMKV
```ts
import { atom, Atom, AtomMut } from '@reatom/core';
import { onUpdate } from '@reatom/hooks';
import { persistStorage } from '../../api/storage';

export function atomWithMMKV<T>(
  key: string, 
  initialValue: T
): AtomMut<T> {
  // 1. Пытаемся прочитать значение из MMKV при создании
  // Если там пусто, берем initialValue
  const savedValue = persistStorage.get(key);
  const startState = savedValue !== null ? savedValue : initialValue;

  // 2. Создаем обычный атом с этим значением
  const theAtom = atom(startState, `${key}.atom`);

  // 3. Вешаем слушатель: при любом обновлении атома -> пишем в MMKV
  onUpdate(theAtom, (ctx, value) => {
    persistStorage.set(key, value);
  });

  return theAtom;
}
```


### Подробнее про REATOM

Реатом строится на трех основных понятиях:

1. Atom - коробка с данными, здесь хранится состояние чего-либо (активность пользователя, тема, состояние аккордеона, вообще любое состояние, форма и так далее)
2. Ctx - проводник, или среда, в которой живут атомы, без контекста атом мертв
3. Action - инструкция, как изменить данные

На примере счетчика:

Вот как создается атом
```tsx
// Первым значением идет начальное состояние, вторым имя для дебага
export const countAtom = atom(0, 'countAtom');
// сейчас здесь нет данных, это просто "чертеж коробки"
```

Вот как его читать и менять:

- что бы прочитать атом, мы используем ctx.get(atom);
- что бы поменять атом, мы используем atom(ctx, newValue)

```ts
const increment = action((ctx) => {
	// прочитали текущее значение
	const current = ctx.get(countAtom);
	
	countAtom((ctx, current + 1);
}. 'increment');
```

ctx можно назвать грузовиком-курьером
сначала мы его отправляем, что бы узнать значение
далее, что бы отправить на точку новое значение

что бы сделать ctx его достаточно создать один раз на всё приложение и прокинуть в провайдер
```jsx
import React from 'react';
import { createCtx } from '@reatom/core';
import { reatomContext } from '@reatom/npm-react';
import { CounterScreen } from './screens/CounterScreen'; // Наш экран

// 1. Создаем сердце приложения
const ctx = createCtx();

export default function App() {
  return (
    // 2. Провайдер прокидывает ctx во все компоненты
    <reatomContext.Provider value={ctx}>
      <CounterScreen />
    </reatomContext.Provider>
  );
}
```

В компоненте достаточно вызвать и деструктурировано достать данные (аналогично useState()) хук useAtom() и передать в него нужный атом, этот хук сделает две вещи
- подпишет компонент на ререндер при изменении атома
- даст функцию для изменения данных
```tsx
import React from 'react';
import { View, Text, Button, StyleSheet } from 'react-native';
import { useAtom } from '@reatom/npm-react';
import { countAtom } from '../features/counter/model'; // Импортируем наш атом

export const CounterScreen = () => {
  // useAtom возвращает массив: [значение, функция_изменения]
  // Это очень похоже на useState!
  const [count, setCount] = useAtom(countAtom);

  return (
    <View style={styles.container}>
      <Text style={styles.text}>Счетчик: {count}</Text>
      
      {/* 
         setCount сама знает про ctx. 
         Мы можем передать новое значение или callback 
      */}
      <Button 
        title="Увеличить" 
        onPress={() => setCount(prev => prev + 1)} 
      />
      
      <Button 
        title="Сбросить" 
        color="red"
        onPress={() => setCount(0)} 
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  text: { fontSize: 24, marginBottom: 20 }
});
```

так же есть вычисляемые атомы: Computed Atoms

их значение зависит от других атомов, например

нужно проверить число на четность

мы создаем атом который принимает функцию с контекстом, в этой функции подписывается на нужный атом и возвращает значение в зависимости от условий

пример

```ts
import { atom } from '@reatom/core';

export const countAtom = atom(0, 'countAtom');

// 1. Создаем вычисляемый атом
// Он принимает функцию с контекстом (ctx)
export const isEvenAtom = atom((ctx) => {
  // 2. "Шпионим" за другим атомом с помощью ctx.spy()
  // Это создает подписку: когда countAtom изменится, этот атом пересчитается.
  const count = ctx.spy(countAtom);
  return count % 2 === 0;
}, 'isEvenAtom');
```

Если нам нужно использовать isEven, достаточно вызвать его так же через хук useAtom()

`const [isEven] = useAtom(isEvenAtom)`;

Работа с апи:

Есть асинхронные экшены, они похожи на useMutation() or useQuery()

Но по количеству кода они намного меньше и можно добавить дополнительную логику, например, что бы избежать лишних запросов

```jsx
import { reatomAsync } from '@reatom/async';
// Допустим, у нас есть api из shared слоя
import { api } from '@/shared/api'; 

// 1. Создаем асинхронный экшен
export const fetchUser = reatomAsync(async (ctx, userId: string) => {
  // Тут делаем запрос (axios, fetch и т.д.)
  const response = await api.get(`/users/${userId}`);
  return response.data; // Возвращаем данные
}, 'fetchUser');

// ВОТ В ЧЕМ МАГИЯ:
// fetchUser - это не просто функция. Это контейнер, в котором уже есть атомы:
// fetchUser.dataAtom    -> тут лежит результат (response.data)
// fetchUser.pendingAtom -> тут лежит true/false (загрузка)
// fetchUser.errorAtom   -> тут лежит ошибка, если запрос упал
```


ui:
```jsx
import React, { useEffect } from 'react';
import { View, Text, Button, ActivityIndicator, StyleSheet } from 'react-native';
import { useAtom, useAction } from '@reatom/npm-react';
import { fetchUser } from '../features/user/model';

export const ProfileScreen = () => {
  // 1. Читаем атомы, которые reatomAsync создал за нас
  // pendingAtom дает число активных запросов (0 = не грузится, 1+ = грузится)
  const [isLoading] = useAtom(ctx => ctx.spy(fetchUser.pendingAtom) > 0);
  const [userData] = useAtom(fetchUser.dataAtom);
  const [error] = useAtom(fetchUser.errorAtom);

  // 2. Получаем функцию запуска запроса
  const handleFetch = useAction(fetchUser);

  return (
    <View style={styles.container}>
      {/* Сценарий 1: Загрузка */}
      {isLoading && <ActivityIndicator size="large" color="#0000ff" />}

      {/* Сценарий 2: Ошибка */}
      {error && (
        <View>
          <Text style={styles.error}>Ошибка: {error.message}</Text>
          <Button title="Попробовать снова" onPress={() => handleFetch('123')} />
        </View>
      )}

      {/* Сценарий 3: Данные есть */}
      {userData && (
        <View>
          <Text style={styles.title}>Привет, {userData.name}!</Text>
          <Text>Email: {userData.email}</Text>
        </View>
      )}

      {/* Кнопка запуска (если данных нет и не грузится) */}
      {!userData && !isLoading && !error && (
        <Button title="Загрузить профиль" onPress={() => handleFetch('123')} />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', padding: 20 },
  error: { color: 'red', marginBottom: 10 },
  title: { fontSize: 24, fontWeight: 'bold' }
});
```

здесь важно уточнить про pendingAtom
### 1. Загадка pendingAtom (Почему число, а не булево?)

```ts
const [isLoading] = useAtom(ctx => ctx.spy(fetchUser.pendingAtom) > 0);
```
#### Почему это счетчик (0, 1, 2...), а не просто true/false?

Представь, что у тебя есть кнопка «Сохранить».
1. Пользователь нажимает её **первый раз**. Интернет медленный. Запрос полетел.
    - pendingAtom стал **1**.
    - Лоадер показался (1 > 0).

2. Пользователь нетерпеливый и (пока первый запрос еще висит) нажимает кнопку **второй раз**.
    - Reatom запускает второй параллельный запрос.
    - pendingAtom стал **2**.
    - Лоадер всё еще висит (2 > 0).

3. Первый запрос завершился (успехом или ошибкой).
    - pendingAtom уменьшился на 1 и стал **1**.
    - **Важно:** Лоадер НЕ исчез! (1 > 0). Ведь второй запрос еще в пути.

4. Второй запрос завершился.
    - pendingAtom стал **0**.
    - Теперь лоадер исчез.

Если бы это был просто true/false, то при завершении первого запроса (пункт 3) лоадер бы исчез, хотя второй запрос еще идет. Это вызвало бы баг "мигающего интерфейса" или несогласованности данных.

В Reatom экшен всегда требует контекст
Но как ui кнопка может получить контекст?
Никак, поэтому нам нужно вызвать useAction(*нужный атом*)

```tsx
// 1. Мы даем useAction "чертеж" (fetchUser) 
const handleFetch = useAction(fetchUser); 

// 2. useAction возвращает нам готовую функцию. 
// Внутри она выглядит примерно так: 
// (payload) => fetchUser(globalCtx, payload) 
// 3. Теперь мы можем вызвать её просто с данными 
<Button onPress={() => handleFetch('user-id-123')} />
```

Помимо прокидывания контекста, useAction гарантирует **стабильность ссылки**.

Если нам нужно сделать какую-то последовательность в экшене из функций, что бы не накидывать большой конфиг или кучу доп функций, придумали .pipe()

.pipe() - это штука, которая позволяет плоско вызвать дополнительные функции, вместо вложенности

```tsx
// БЕЗ pipe (псевдокод, так не работает, но суть такая)
const superFetch = withAbort(withDataAtom(fetchUser, myAtom));

// С pipe (Читаем сверху вниз)
const fetchUser = reatomAsync(async (ctx) => { ... })
  .pipe(
    withDataAtom(userPersistAtom), // 1. Прикрутили атом данных
    withAbort(),                   // 2. Прикрутили отмену
    withRetry({ onReject: 3 })     // 3. Прикрутили повторы при ошибке
  );
```

По умолчанию, когда мы создаем reatomAsync() в нем внутри создается хранилище для наших данных .dataAtom

Что бы перенаправить данные, мы можем использовать функцию withDataAtom(atom), она перехватывает результат и кладет их в указанный атом

### 3. onConnect(atom, callback) — Датчик движения

Это хук жизненного цикла атома. В React Native это замена useEffect для первоначальной загрузки данных.

**Как это работает (Механика ссылок):**  
Reatom считает, сколько компонентов сейчас используют ("шпионят" за) атомом.

- 0 компонентов = Атом спит (Disconnected).
    
- 1 компонент подписался = Атом проснулся (Connected). **<-- Срабатывает onConnect**
    
- 2, 3, 10 компонентов = Атом работает.
    
- Все компоненты отмонтировались (снова 0) = Атом уснул.
    

**Визуализация:**  
Это лампочка с датчиком движения в комнате.

- Никого нет (0) — темно.
    
- Ты заходишь в комнату (1) — свет (логика) включается **автоматически**.
    
- Заходит твой друг (2) — свет уже горит, ничего не происходит.
    
- Все вышли (0) — свет погас (если настроена очистка).
    

**Зачем это нужно вместо useEffect?**  
Если ты используешь useEffect в компоненте UserScreen, то логика загрузки привязана к UI.  
onConnect позволяет привязать логику к **данным**.

"Если кому-то понадобились данные юзера — загрузи их".

```jsx
import { onConnect } from '@reatom/hooks';

// ... объявление атома ...

onConnect(fetchUser.dataAtom, (ctx) => {
  // Этот код выполнится ОДИН раз, когда первый React-компонент
  // сделает useAtom(fetchUser.dataAtom)
  
  // Проверка: если данных нет, то грузим
  if (ctx.get(fetchUser.dataAtom) === null) {
    fetchUser(ctx);
  }
});
```