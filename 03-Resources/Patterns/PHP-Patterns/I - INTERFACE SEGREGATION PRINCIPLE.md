bad example:
```ts
interface UserActions {
  viewProfile(): void;
  deleteUser(): void;
}

class RegularUser implements UserActions {
  viewProfile() {
    console.log('Viewing profile');
  }

  deleteUser() {
    throw new Error("Regular users can't delete users");
  }
}
```

good example:
```ts
interface RegularUserActions {
  viewProfile(): void;
}

interface AdminUserActions extends RegularUserActions {
  deleteUser(): void;
}

class RegularUser implements RegularUserActions {
  viewProfile() {
    console.log('Viewing profile');
  }
}

class AdminUser implements AdminUserActions {
  viewProfile() {
    console.log('Viewing profile');
  }

  deleteUser() {
    console.log('User deleted');
  }
}
```