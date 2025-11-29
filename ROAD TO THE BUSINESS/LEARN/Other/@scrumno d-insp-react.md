# Полная документация по логике работы d-insp-react

Содержимое:
- Как начать
- Структура самого пакета
	- Настройка окружения
		- Сборщик `rollup.config.js` и его файл конфигурации
		- Файл конфигурации *TS* `tsconfig.ts`
		- // `package.json`
	- Папка `src` - основной код пакета
		- Точка входа `index.ts`
		- Главный провайдер `/app/DebugProvider.tsx`
		- Домен `Inspector` - логика работы пакета
			- `hooks/useDebugRender.tsx` - хук, для подсчета рендров выбранного компонента
			- `/lib/interceptor.ts` - перехватчик запросов
			- `/model/store.ts` - стор без кеширования, где временно хранится вся собранная информация
			- `/model/types.ts` - типизация используемых данных домена
- Планы по развитию

## Как начать

Зайти на гитхаб и прочитать README.md
[@scrumno/d-insp-react](https://github.com/scrumno/d-insp-react)

## Структура самого пакета

### Настройка окружения

#### Сборщик `rollup.config.js` и его файл конфигурации

Почему именно `rollup` ?

Потому что в отличии от `webpack`, `gulp`, или других сборщиков, `rollup` собирает бандл "скальпелем", то-есть код, который не используется, в бандл не попадет, таким образом вес пакета на выходе получается мизерным.
Этот подход называется `tree-shaking` (тряска дерева).
Он старается "поднять" (`hoist`) все модули в одну область видимости, вместо того, что бы оборачивать каждый файл в отдельную функцию, он просто склеивает их в один плоский файл.
`Vite` использует `rollup` в качестве основы.

Стандартный `rollup` умеет только склеивать файлы, поэтому дополнительно нужно устанавливать плагины.

Кратко что делают плагины `rollup`, настроенные в `rollup.config.js`:

- `import commonjs from '@rollup/plugin-commonjs'` // конвертирует старый CJS код в ES6
- `import resolve from '@rollup/plugin-node-resolve'` // позволяет находить пакеты в node_modules
- `import typescript from '@rollup/plugin-typescript'` // поддержка `ts`
- `import peerDepsExternal from 'rollup-plugin-peer-deps-external'` // исключаем из бандла код зависимостей, оставляем только ссылки на них

```js
export default {
	input: 'src/index.ts' // точка входа, отсюда начинается сборка, здесь мы делаем глобальный экспорт
	
	output: [
		{
		// сборка для CommonJS
			file: '/src/index.ts',
			format: 'cjs',
			sourcemap: true // карта кода, что бы дебажить исходники в браузере при необходимости
		},
		
		// ...
		
		// интеграция плагинов
		plugins: [
			peerDepsExternal(),
			resolve(),
			commonjs(),
			typescript({
				tsconfig: './tsconfig.json',

      exclude: ['**/*.test.ts', '**/*.test.tsx'], // не билдим
			}),
		],
		
		// исключаем либы из бандла, которые используются
		external: [
			'react', 'react-dom'
		]
	]
}
```

Для `npm` библиотек рекомендуется, для SPA и других тяжелых приложений - нет.

#### Файл конфигурации *TS* `tsconfig.ts`
```ts
{
  "compilerOptions": {
    "target": "es2020", // в какую версию собирается код
    "lib": ["dom", "dom.iterable", "esnext"], // какие глобальные типы доступны, ниже разбор
    "allowJs": true, // импорт js в ts проекте (`rollup.config.js`)
    "skipLibCheck": true, // скипаем проверку типов внутри node_modules
    "esModuleInterop": true, // всегда включать))
    "allowSyntheticDefaultImports": true, // делегируем отвественность на rollup и говорим typescript, что default export всегда есть
    "strict": true,
   "forceConsistentCasingInFileNames": true, // чувствительность к регистру имен импортируемых файлов
    "module": "esnext", // rollup работает только с ES-modules, поэтому TS не должен трогать импорты и экспорты
    "moduleResolution": "node", // как искать файлы
    "resolveJsonModule": true, // можно импортировать JSON, который TS автоматически типизирует
    "isolatedModules": true, // запрещаем анализ других файлов для компиляции
    "jsx": "react-jsx",
    "declaration": true, // генерируем .d.ts файлы, что бы ловить подсказки при использовании пакета
    "declarationDir": "dist", // в папку складываем .d.ts
    "baseUrl": "./src" // делаем абсолютные импорты от корня src
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]

}
```

`"lib": ["dom", "dom.iterable", "esnext"]`
- `dom` - типизация `window`, `document`, `HTMLElement`, для поддержки браузера
- `dom.iterable` - допускаем циклы по элементам DOM
- `esnext` - последние обновления JS

#### Точка входа `index.ts`

```ts
declare global {...} // добавляем в глобальное пространство имен наши функции
```

`__d_insp_initialized?: boolean` - т.к. в React 18+ в StrictMode идет двойной рендер, есть риск инициализации двойной панели, это плохо, поэтому добавлена проверка, инициализирована ли моя панель.
Название сложное, что бы не совпадать с другими библиотеками.

`d: <T>(value: T | Promise<T>) => T | Promise<T>` - проходной логгер, возвращаем тоже самое, что и логируем.
Можно сразу использовать так:
`return d(calculate())` - и логируем и сразу возвращаем результат

`interface XMLHttpRequest` здесь добавляется поле `_debug`
что бы перехватывать методы `open` и `send`

Объявление глобальных переменных, что бы использовать их без `window`

#### Главный провайдер `/app/DebugProvider.tsx`

```tsx
const InspectorModal = React.lazy(() =>
  import('domains/Inspector/ui/InspectorModal').then(module => ({
    default: module.InspectorModal,
  }))
)
```

В этом куске кода я использую динамический импорт. Когда сборщики видят динамический импорт, они вырезают код из основного файла `index.js` и помещают его в отдельный файл - `chunk` и этот файл загружается только когда React реально пытается отрисовать этот компонент.

`React.lazy` ожидает, что промис, который вернется, резолвится в объект у которого есть свойство `default` (то-есть lazy в реакте работает только с `export default`)

Когда мы делаем динамический именованный импорт, нам возвращается объект вида:
```tsx
{
  InspectorModal: function() { ... }, // Наш компонент тут
  __esModule: true
}
```

Если поля default нет (а его сейчас нет), lazy упадет с ошибкой.

Поэтому здесь используется адаптер, а именно `.then()`, мы вручную докладываем в модуль свойство `default`

`return { default: module.InspectorModal }`

По факту мы просто инициализируем пакет

#### `/lib/interceptor.ts` - перехватчик запросов

Основная логика перехвата запросов здесь. 
Нюансов очень много, но я попробую расписать каждый метод.

Начнем с `initialize()`
- Преждевременный выход, если мы пытаемся рендрить в серверном окружении, простой проверкой, есть ли объект window или нет
- Далее проверка на прод, если это прод, мы делаем заглушки вместо нашего кода. Пустые анонимные `void` функции, которые никак не влияют на дальнейшую работу.
- Инициализируем наш сервис

`patchFetch()
`
Первым делом сохраняем оригинальный `fetch`, иначе пу-пу нашей возможности делать запросы

```tsx
const originalFetch = window.fetch
```

Подменяем `fetch` функцией, которая узнает трейс, нормализует аргументы, проверит чьи это запросы (вебпак или аналитик, можно добавить больше `url`)

```ts
window.fetch = async (...args) => {
	const startTime = Date.now()
	const trace = getStackTrace()
	
	// fetch можно вызвать поразному, с аргументами и без
	const [resource, config] = args
	const url = 
		typeof resource === 'string'
			? resource
			: resource instanceof Request
			? resource.url
			: ''
	
	// filter	
	if (SKIP_URLS.some(u => url.includes(u))) { 
		return originalFetch(...args) 
	}
	
	// вытаскиваем метод...
	
	// ...копируем заголовки запроса
	const reqHeaders: Record<string, string> = {} 
	if (config?.headers) { 
		new Headers(config.headers).forEach((v, k) =>
			(reqHeaders[k] = v)) 
	}
}
```
- Выполняем запрос
- Логируем ответ
- Анализируем ответ, если это `JSON\Text` и он не огромный, пытаемся прочитать
- т.к. `response.body` можно прочитать только один раз, делаем `.clone()`, что бы прочитать копию, а оригинал отдаем нетронутым.
- Если файл бинарный или большой, пишем заглушку без тела
- Возвращаем оригинальный ответ

`patchXHR()` описала нейронка
```ts
function patchXHR() {
	const originalOpen = XMLHttpRequest.prototype.open
	const originalSend = XMLHttpRequest.prototype.send

    // Нам нужно знать URL и метод ДО отправки
	XMLHttpRequest.prototype.open = function (
		method: string,
		url: string | URL,
		...args: any[]
	) {
		// @ts-ignore
		this._debug = {
			method,
			url: url.toString(),
			startTime: Date.now(),
			trace: getStackTrace(),
		}
		// @ts-ignore
		return originalOpen.call(this, method, url, ...args) // Вызываем оригинал
	}

    // 2. Перехват метода SEND (Отправка и получение результата)
	XMLHttpRequest.prototype.send = function (body?: any) {
		// @ts-ignore
		const debug = this._debug
        // Фильтр от HMR (hot-update)
		if (debug && !debug.url.includes('hot-update')) {
            
            // Функция обработки завершения запроса
			const onFinish = (isError: boolean) => {
				// @ts-ignore
				const xhr = this as XMLHttpRequest
				const duration = Date.now() - debug.startTime

				let resBody = null

				try {
                    // Проверяем, текст ли это
					const isText =
						!xhr.responseType ||
						xhr.responseType === 'text' ||
						xhr.responseType === 'json'

                    // Если текст и не очень большой — читаем responseText
					if (
						isText &&
						xhr.responseText &&
						xhr.responseText.length < MAX_BODY_SIZE
					) {
						resBody = safeParseBody(xhr.responseText)
					} else {
						resBody = `[Hidden: ${xhr.responseType || 'Blob'} or Too Large]`
					}
				} catch {
					resBody = '[Read Error / CORS Opaque]'
				}

                // Пишем в стор
				useInspectorStore.getState().add({
                    /* ...данные запроса и ответа... */
				})
			}

            // Подписываемся на события XHR.
            // once: true — чтобы сработало только один раз.
			this.addEventListener('load', () => onFinish(false), { once: true }) // Успех
			this.addEventListener('error', () => onFinish(true), { once: true }) // Ошибка сети
			this.addEventListener('abort', () => onFinish(true), { once: true }) // Отмена запроса
		}
		return originalSend.call(this, body) // Запускаем реальную отправку
	}
}
```

`patchD()`
```ts
function patchD() {
    // Присваиваем функцию в window.d
	;(window as any).d = <T>(value: T | Promise<T>) => {
		const trace = getStackTrace() // Где вызвали
		const timestamp = Date.now()

        // Хелпер для записи в стор
		const add = (val: any, error?: any) => {
			useInspectorStore.getState().add({
				id: generateId(),
				type: 'value', // Тип события - просто значение
				timestamp,
				trace,
				value: val,
				...(error && { error: String(error) }),
			})
		}

        // Магия для промисов: d(fetch(...))
		if (value instanceof Promise) {
			// Мы не ждем await, мы возвращаем промис обратно, чтобы код приложения работал дальше.
            // Но мы "врезаемся" в цепочку .then().
			value
				.then(res => {
					add(res) // Логируем результат
					return res // Передаем результат дальше по цепочке
				})
				.catch(err => {
					add(null, err) // Логируем ошибку
					throw err // Прокидываем ошибку дальше (важно!)
				})
			return value
		}

        // Если обычное значение — логируем и возвращаем
		add(value)
		return value
	}
}
```