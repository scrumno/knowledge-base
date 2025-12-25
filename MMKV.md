#reactnative #mmkv

```ts
import { MMKV } from 'react-native-mmkv';

export const storage = new MMKV();

// Хелперы для удобства (опционально)
export const persistStorage = {
  get: (key: string) => {
    const value = storage.getString(key);
    try {
      return value ? JSON.parse(value) : null;
    } catch {
      return null;
    }
  },
  set: (key: string, value: any) => {
    storage.set(key, JSON.stringify(value));
  },
  delete: (key: string) => {
    storage.delete(key);
  }
};
```