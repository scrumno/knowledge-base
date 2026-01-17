good example:
```jsx
class Shape {
  draw() {
    // Default drawing logic
  }
}

class Circle extends Shape {
  draw() {
    super.draw();
    // Circle-specific drawing logic
  }
}

class Square extends Shape {
  draw() {
    super.draw();
    // Square-specific drawing logic
  }
}

function renderShape(shape) {
  shape.draw();
}

// Both Circle and Square can replace Shape without issues
const circle = new Circle();
renderShape(circle);

const square = new Square();
renderShape(square);
```